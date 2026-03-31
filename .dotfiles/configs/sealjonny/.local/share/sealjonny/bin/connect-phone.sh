#!/bin/bash

state_file="$HOME/.local/state/connect-phone"

check_ip() {
  if [[ ! "$1" =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}:[0-9]{1,5}$ ]]; then
    return 1
  fi
}

device_connected() {
  local device
  device="$(adb devices | awk 'NR > 1 { print $1 }')"

  if [ -z "$device" ]; then
    return 1
  fi

  if check_ip "$device"; then
    echo "$device"
    return 0
  fi

  return 2
}

connect_previous() {
  local ip
  ip="$(cat "$state_file")"

  if ! check_ip "$ip"; then
    return 1
  fi

  if adb connect "$ip" | awk '{ print $1 }' | grep -qx failed; then
    echo "" > "$state_file"
    return 1
  fi

  echo "$ip"
}

connect() {
  local ip
  ip="$(adb shell ip route | awk '{ print $9 }')"
  adb tcpip 5555 &> /dev/null
  adb connect "$ip" &> /dev/null
  echo "${ip}:5555"
}

ip="$(connect_previous)"

if [ $? -ne 0 ]; then
  ip="$(device_connected)"

  case "$?" in
    1) echo "No device connected!"; exit 1 ;;
    2) ip="$(connect)" ;;
  esac

  if ! check_ip "$ip"; then
    echo "$ip is not a valid ip address!"
    exit 1
  fi
fi

uwsm-app -- scrcpy --tcpip="$ip"

echo "$ip" > "$state_file"
