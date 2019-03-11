#!/bin/bash

BRIGHTNESS=$(echo "scale=0;${1}*1808/100" | bc)

sudo chmod +w /sys/class/backlight/intel_backlight/brightness
sudo sh -c "echo ${BRIGHTNESS} > /sys/class/backlight/intel_backlight/brightness"
sudo chmod -w /sys/class/backlight/intel_backlight/brightness
