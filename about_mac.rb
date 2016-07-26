#!/usr/bin/env ruby
require 'nokogiri'
require 'open-uri'

def get_value_only(property)
  property.split(':')[1].delete!("\n").strip()
end

def processor
  #system('system_profiler SPHardwareDataType | grep \'Processor\'')
  processor_name=`system_profiler SPHardwareDataType | grep 'Processor\sName'`
  processor_speed=`system_profiler SPHardwareDataType | grep 'Processor\sSpeed'`

  {"name" => get_value_only(processor_name),"speed" => get_value_only(processor_speed)}
end

def serial_number
  serial_number=`system_profiler SPHardwareDataType | grep Serial`

  get_value_only(serial_number)
end

def memory
  memory_size= get_value_only(`system_profiler SPHardwareDataType | grep Memory`)
  memory_type= get_value_only(`system_profiler SPMemoryDataType | grep -m 1 Type`)
  memory_speed= get_value_only(`system_profiler SPMemoryDataType | grep -m 1 Speed`)

  {"size" => memory_size, "type" => memory_type, "speed" => memory_speed}
end

def model_offline
  `sysctl -n hw.model`
end

def model
  last_4_serial_number = serial_number[-4,4]
  begin
    doc = Nokogiri::XML(open("http://support-sp.apple.com/sp/product?cc=#{last_4_serial_number}&lang=en"))
    mac_model = doc.xpath('//root')
    model_info = mac_model.xpath('//configCode').text

  rescue => error
    model_info = model_offline
  end

  model_info
end

def battery
  battery_condition= get_value_only(`system_profiler SPPowerDataType | grep -i condition`)
  battery_cycles= get_value_only(`system_profiler SPPowerDataType | grep -i "cycle count"`)

  {"condition" => battery_condition, "cycles" => battery_cycles}
end

def graphic_card
  chip = get_value_only(`system_profiler SPDisplaysDataType | grep -i chipset`)
  vram = get_value_only(`system_profiler SPDisplaysDataType | grep -i vram`)

  {"chip" => chip, "vram" => vram}
end

def hard_drive
  capacity = get_value_only(`system_profiler SPSerialATADataType | grep -i -m 1 capacity`)
  type = get_value_only(`system_profiler SPSerialATADataType | grep -i "medium type"`)
  {"type" => type, "capacity" => capacity}
end

def print_about_mac
  processor_info = processor
  memory_info = memory
  battery_info = battery
  graphic_card_info = graphic_card
  hard_drive_info = hard_drive

  puts model
  puts '--------------------------------'
  puts "Processor: " + processor_info["name"] + ' - ' + processor_info["speed"]
  puts "Memory: " + memory_info["size"] + ' - ' + memory_info["speed"] + ' - ' + memory_info["type"]
  puts "Serial Number: " + serial_number
  puts "Battery Condition: " + battery_info["condition"] + ' / Cycles: ' + battery_info["cycles"]
  puts "Graphics: " + graphic_card_info["chip"] + " - " + graphic_card_info["vram"]
  puts "Storage: " + hard_drive_info["type"] + " - " + hard_drive_info["capacity"]
end

print_about_mac
