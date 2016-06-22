#!/bin/bash

# format debug output if using bash -x
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

notify-send "Looking for Docker data medium" -t 30000
logger -p local0.info "Looking for Docker data medium"
sleep 3
notify-send "waiting for auto-mounting of block devices to complete" -t 30000
logger -p local0.info "waiting for auto-mounting of block devices to complete"
sleep 3
for i in {1..10}; do
    sudo /usr/local/bin/predocker.sh >> /tmp/predocker.log 2>&1
    zenity --error --text "Docker data medium not found - please insert/mount a marked medium (see doc)"
    [ $? -eq 0 ] && break
done

#RET_VAR=$?
if [ $? -eq 0 ]
then 
  notify-send  "Docker data medium found, starting docker image"  -t 30000
  /tmp/startapp_inv.sh > /tmp/startapp_inv.log 2>&1
else
  notify-send "Docker data medium not found. Connect a medium (see doc) and run 'sudo /usr/local/bin/start.sh -d /dev/<my-docker-drive>'" --timeout 3
fi

