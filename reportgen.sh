#!/bin/sh

day="$(date '+%d-%m')"
dat="date '+%H:%M %d-%m: '"
DIRECTORY="/home/$USER/reports"
FILE="/home/$USER/report-$day.dat"

monitor()
{
  sleep "$((15 - $(date '+%-M') % 15))m"

  while true
  do
    echo -n "$(eval $dat)" >> $FILE
    info=$(zenity --text-info \
          --title="Report" \
          --editable \
          --filename=$FILE 2> /dev/null)
    if [[ $? -eq 0 ]]; then
        echo "$info" >| $FILE
        if [[ "$info" =~ "KONIEC" ]]; then
          break;
        fi
    fi
    sleep "$((15 - $(date '+%M') % 15))m"
  done
}

mkdir -p $DIRECTORY
monitor &

#TODO:
#zenity auto scroll patch ( or maybe it already is in source )
