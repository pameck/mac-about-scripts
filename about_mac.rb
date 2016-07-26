#!/usr/bin/env ruby
require 'nokogiri'
require 'open-uri'
require 'json'
require 'rubygems'
require 'aws-sdk'

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

def about_mac
  {
    "model" => model,
    "processor" => processor,
    "memory" => memory,
    "battery" => battery,
    "graphic_card" => graphic_card,
    "hard_drive" => hard_drive,
    "serial" => serial_number
  }
end

def to_json_file(the_info, file_name)
  out_file = File.new(file_name, "w")
  out_file.puts(the_info.to_json)
  out_file.close
end

# sudo gem install aws-sdk && ruby about_mac.rb
def upload_to_s3
  bucket_name = 'techops-tests'
  file_name = 'out.json'

  to_json_file(about_mac, file_name)

  puts "Hi! I am going to need the AWS access key"
  access_key_id = gets.chomp

  puts "and now the secret..."
  secret_access_key = gets.chomp

  s3 = Aws::S3::Resource.new(
    region: 'ap-southeast-2',
    access_key_id: access_key_id,
    secret_access_key: secret_access_key
  )

  file = File.basename file_name
  obj = s3.bucket(bucket_name).object(file)

  if obj.upload_file(file)
    puts "Uploaded #{file} to bucket #{bucket_name}"
  else
    puts "Could not upload #{file} to bucket #{bucket_name}!"
  end
end

def print_about_mac
  the_mac = about_mac

  puts the_mac["model"]
  puts '--------------------------------'
  puts "Processor: " + the_mac["processor"]["name"] + ' - ' + the_mac["processor"]["speed"]
  puts "Memory: " + the_mac["memory"]["size"] + ' - ' + the_mac["memory"]["speed"] + ' - ' + the_mac["memory"]["type"]
  puts "Serial Number: " + the_mac["serial"]
  puts "Battery Condition: " + the_mac["battery"]["condition"] + ' / Cycles: ' + the_mac["battery"]["cycles"]
  puts "Graphics: " + the_mac["graphic_card"]["chip"] + " - " + the_mac["graphic_card"]["vram"]
  puts "Storage: " + the_mac["hard_drive"]["type"] + " - " + the_mac["hard_drive"]["capacity"]
end

print_about_mac
