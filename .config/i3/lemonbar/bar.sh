#!/bin/bash

DELAY=0.2

conky -c ~/.config/lemonbar/conky.conf &

while true; do
  output="";

  # Left Align

  # Workspaces
  while read -r line; do
    if [[ "$line" == *'true'* ]]; then
      output="${output}%{F#051525}"
    elif [[ "$line" == *'false'* ]]; then
      output="${output}%{F#888888}"
    fi
    num=$(echo "${line/\]/}" | cut -d , -f 2)
    output="${output}%{A:i3-msg workspace ${num}:}[${num}]%{A}"
  done <<< "$(i3-msg -t get_workspaces | jq -S -M -c -r '.[] | [.focused, .num]')"
  output="${output}%{F#888888}"


  # Center Align
  output="${output}%{c}"

  # Pianobar
  if [[ "$(pgrep pianobar)" != '' ]]; then
    while read -r line; do
      if [[ "$line" != *"Station"* ]]; then
        song=$(echo "$line" | cut -d \" -f 2)
        artist=$(echo "$line" | cut -d \" -f 4)
        output="${output}%{A:echo -n \" \" > ~/.config/pianobar/ctl:}%{A3:echo -n \"n\" > ~/.config/pianobar/ctl:}"
        output="${output}%{F#051525}\"${song}\"%{F#888888} by %{F#051525}\"${artist}\"%{F#888888}"
        output="${output}%{A}%{A}"
        break
      fi
    done <<< "$(tac ~/.config/pianobar/out | grep '|')"
  fi


  # Right Align
  output="${output}%{r} "

  # Wifi
  essid=$(iwgetid | cut -d \" -f 2)
  if [[ "$essid" != "" ]]; then
    output="${output}%{F#051525}$(iwconfig wlan0 | grep Quality | cut -d = -f 2 | cut -d / -f 1)% %{F#888888}@%{F#051525} $essid"
  fi

  output="${output} "

  # Volume
  master="$(amixer | head -1 | cut -d "'" -f 2)"
  output="${output}%{A4:amixer -q sset ${master} 1%+:}%{A5:amixer -q sset ${master} 1%-:}"
  output="${output}%{F#888888}Volume %{F#051525}$(amixer get ${master} | tail -1 | cut -d \[ -f 2 | cut -d \] -f 1)%{F#888888}"
  output="${output}%{A}%{A}"

  output="${output} "

  # Battery
  output="${output}%{F#888888}Battery%{F#051525} $(acpi | cut -d , -f 2 | cut -d " " -f 2)"

  output="${output} "

  # Time
  time=$(date | cut -d " " -f 5)
  output="${output}%{F#888888}Time %{F#051525}${time//:/%\{F\#888888\}:%\{F\#051525\}}"

  echo " ${output} ";sleep $DELAY;
done | lemonbar -f "Droid Sans Mono-8" -d -g 1226x26+27+27 -B \#dde5eb -F \#888888 | /bin/bash
