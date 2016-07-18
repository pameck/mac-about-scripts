#!/usr/bin/env ruby
def print_about_mac
  #system('system_profiler SPHardwareDataType | grep \'Processor\'')
  processor=`system_profiler SPHardwareDataType | grep 'Processor'`
  serial_number=`system_profiler SPHardwareDataType | grep Serial`
  memory=`system_profiler SPHardwareDataType | grep Memory`
  puts processor
end

print_about_mac
