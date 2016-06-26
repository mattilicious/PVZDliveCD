#!/bin/bash

# format debug output if using bash -x
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

notify-send "Looking for Data medium" -t 25000
logger -p local0.info "Looking for Docker data medium"
sleep 3
notify-send "waiting for auto-mounting of block devices to complete" -t 25000
logger -p local0.info "waiting for auto-mounting of block devices to complete"
sleep 3
for i in {1..10}; do
    sudo /usr/local/bin/predocker.sh >> /tmp/predocker.log 2>&1
    if [ $? -eq 0 ]; then
        break
    else
      zenity --error --text "Data medium not found - please insert/mount a marked data medium (see doc)"
    fi
done

#RET_VAR=$?
if [ $? -eq 0 ]
then 
  notify-send  "Data medium found"  -t 20000
  source /tmp/set_data_dir.sh > /tmp/startapp.log 2>&1
  $DATADIR/startapp.sh >> /tmp/startapp.log 2>&1
else
  notify-send "Data medium not found. Connect a medium (see doc) and run 'sudo /usr/local/bin/start.sh -d /dev/<my-data-drive>'" --timeout 50000
fi

