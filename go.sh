#!/bin/bash
CPU=$(system_profiler SPHardwareDataType | grep 'Processor ')
SERIAL_NUMBER=$(system_profiler SPHardwareDataType | grep Serial)
MEMORY=$(system_profiler SPHardwareDataType | grep Memory)
LAST_4_SERIAL_NUMBER=$(system_profiler SPHardwareDataType | grep Serial | grep -o '.\{4\}$')
PRETTY_NAME_XML=$(curl -o- http://support-sp.apple.com/sp/product?cc="$LAST_4_SERIAL_NUMBER"&lang=en)

echo "-----------------"
echo "About this Mac"

echo "CPU:" $CPU
echo "Serial Number:" $SERIAL_NUMBER

#echo $PRETTY_NAME_XML

