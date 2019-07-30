#! /bin/sh
# A simple script that compares the times returned by gcal -c to the current
# time and alerts if an event is in the next five minutes.

TIME=`date "+%s"`
let TWO_MINUTES_SECONDS=60*2
/usr/local/bin/gcal -c | grep -v "Fixed" | grep -v "^$" | while read -r EVENT; do
    EVENT_TIME=`echo $EVENT | cut -d "*" -f1 | cut -d "," -f2 | sed "s/[\<\>]/ /g" | sed -E "s/(st)|(nd)|(rd)|(th)//g"`
    EVENT_START=`echo $EVENT_TIME | cut -d "-" -f1`":00"
    EVENT_START_EPOCH=`date -j -f "%b %d %Y: %T" "$EVENT_START" "+%s"`
    let REMAINING_TIME=$EVENT_START_EPOCH-$TIME
    if [ $REMAINING_TIME -gt 0 ] && [ $REMAINING_TIME -lt $TWO_MINUTES_SECONDS ]
    then
       /usr/local/bin/terminal-notifier -message "$EVENT"
    fi
done
