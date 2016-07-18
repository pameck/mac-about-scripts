#!/bin/bash
CPU=$(system_profiler SPHardwareDataType | grep 'Processor ')
SERIAL_NUMBER=$(system_profiler SPHardwareDataType | grep Serial)
MEMORY=$(system_profiler SPHardwareDataType | grep Memory)

LAST_3_SERIAL_NUMBER=$($SERIAL_NUMBER | grep -o '.\{3\}$')
PRETTY_NAME_XML=$(curl -o- "http://support-sp.apple.com/sp/product?cc=$LAST_3_SERIAL_NUMBER&lang=en_AU")

echo "-----------------"
echo "About this Mac"

echo "CPU:" $CPU
echo "Serial Number:" $SERIAL_NUMBER

echo $PRETTY_NAME_XML