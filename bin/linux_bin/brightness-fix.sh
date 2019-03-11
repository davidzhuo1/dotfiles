#!/bin/bash

# Screen brightness
LEVEL=60
BRIGHTNESS=$(echo "scale=0;${LEVEL}*1808/100" | bc)

chmod +w /sys/class/backlight/intel_backlight/brightness
echo ${BRIGHTNESS} > /sys/class/backlight/intel_backlight/brightness
chmod -w /sys/class/backlight/intel_backlight/brightness


# Keyboard backlighting
LEVEL=0
BRIGHTNESS=$(echo "scale=0;${LEVEL}*254/100" | bc)

# chattr +i /sys/class/leds/smc::kbd_backlight/brightness
chmod +w /sys/class/leds/smc::kbd_backlight/brightness
echo ${BRIGHTNESS} > /sys/class/leds/smc::kbd_backlight/brightness
chmod -w /sys/class/leds/smc::kbd_backlight/brightness
# chattr -i /sys/class/leds/smc::kbd_backlight/brightness
