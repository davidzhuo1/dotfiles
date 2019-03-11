#!/bin/sh

cli=/Applications/Karabiner.app/Contents/Library/bin/karabiner

$cli set general.dont_remap_apple_pointing 1
/bin/echo -n .
$cli set parameter.acceleration_of_pointer 0
/bin/echo -n .
$cli set parameter.acceleration_of_scroll 0
/bin/echo -n .
$cli set parameter.maximum_speed_of_pointer 25
/bin/echo -n .
$cli set parameter.maximum_speed_of_scroll 35
/bin/echo -n .
$cli set parameter.mousekey_high_speed_of_scroll 35
/bin/echo -n .
$cli set parameter.mousekey_initial_wait_of_scroll 10
/bin/echo -n .
$cli set parameter.mousekey_repeat_wait_of_scroll 10
/bin/echo -n .
$cli set remap.controlArrow2optionLarrow 1
/bin/echo -n .
$cli set remap.pclikehomeend 1
/bin/echo -n .
$cli set remap.pclikepageupdown 1
/bin/echo -n .
$cli set remap.reverse_both_scrolling 1
/bin/echo -n .
$cli set repeat.consumer_initial_wait 100
/bin/echo -n .
$cli set repeat.consumer_wait 25
/bin/echo -n .
$cli set repeat.initial_wait 250
/bin/echo -n .
$cli set repeat.wait 20
/bin/echo -n .
/bin/echo
