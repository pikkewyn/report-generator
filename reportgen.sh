#!/bin/sh

day="$(date '+%d-%m')"
dat="date '+%H:%M %d-%m: '"
DIRECTORY="/home/$USER/reports"
FILE="/home/$USER/report-$day.dat"
BIN_PATH="$HOME/.local/bin"
monitor()
{
  sleep "$((15 - $(date '+%-M') % 15))m"

  while true
  do
    echo -n "$(eval $dat)" >> $FILE
    cp $FILE ${FILE}.bak
    local info=$(zenity --text-info \
          --title="Report" \
          --editable \
          --filename=$FILE 2> /dev/null)
    if [[ $? -eq 0 ]]; then
        local new_lines=$(echo $info | awk 'END{print NR}')
        local old_lines=$(awk 'END{print NR}')

        if [[ $new_lines -gt $old_lines ]]; then
            rm ${FILE}.bak
        fi

        echo "$info" >| $FILE
        if [[ "$info" =~ "KONIEC" ]]; then
            break;
        fi
    fi
    sleep "$((15 - $(date '+%-M') % 15))m"
  done
}

install()
{
    if [[ ! -f $BIN_PATH ]]; then
        echo "Missing $BIN_PATH install path"
    else
        ln -vfs $0 "${BIN_PATH}/reportgen"
    fi
}

stop()
{
    kill -SIGSTOP $(pidof -x $0)
}

cont()
{
    kill -SIGCONT $(pidof -x $0)
}

mkdir -p $DIRECTORY
monitor &
