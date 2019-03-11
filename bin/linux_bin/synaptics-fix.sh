#!/bin/bash

/usr/bin/xinput set-prop 12 'Synaptics Scrolling Distance' 385, 385
/usr/bin/xinput set-prop 12 'Device Accel Adaptive Deceleration' 2.64
/usr/bin/xinput set-prop 12 'Device Accel Constant Deceleration' 2.4
/usr/bin/synclient AccelFactor=0.02633 \
                   MaxSpeed=3.5 \
                   MinSpeed=0.045 \
                   VertHysteresis=28.5
                   HorizHysteresis=28.5
