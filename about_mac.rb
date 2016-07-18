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

  get_value_only(processor_name) + ' - ' + get_value_only(processor_speed)
end

def serial_number
  serial_number=`system_profiler SPHardwareDataType | grep Serial`
  get_value_only(serial_number)
end

def memory
  memory=`system_profiler SPHardwareDataType | grep Memory`
  get_value_only(memory)
end

def model
  doc = Nokogiri::XML(open("http://support-sp.apple.com/sp/product?cc=FVH6&lang=en"))

  mac_model = doc.xpath('//root')
  mac_model.xpath('//configCode').text
end

def print_about_mac
  puts "Serial Number: " + serial_number
  puts "Processor: " + processor
  puts "Memory: " + memory
  puts "Model: " + model
end

print_about_mac
