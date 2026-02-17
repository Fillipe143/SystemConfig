#!/usr/bin/env bash

status=$(cat /sys/class/power_supply/BAT0/status)
level=$(cat /sys/class/power_supply/BAT0/capacity)

[[ "$status" = "Discharging" ]] && icons=("󰁺" "󰁾" "󰁹") || icons=("󰢜" "󰢝" "󰂅")
idx=$(echo "$level/34" | bc)

echo "${icons[idx]} $level%"
