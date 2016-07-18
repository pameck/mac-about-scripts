#!/usr/bin/env ruby
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

def print_about_mac
  puts "Serial Number: " + serial_number
  puts "Processor: " + processor
  puts "Memory: " + memory
end

print_about_mac
