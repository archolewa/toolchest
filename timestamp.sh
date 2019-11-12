#! /bin/sh

# A simple script that converts the specified timestamp to milliseconds since the 
# Unix epoch.
# Takes in the date in the format: "Mon day hour:minutes:seconds timezone year",
# so `timestamp.sh "Aug 15 11:09:00 CDT 2019"`.

if [[ $# = 1 ]]
then
    timestamp_seconds=$(date -j -f "%b %d %T %Z %Y" "$1" "+%s")
    bc <<< "$timestamp_seconds * 1000"
else
    echo 'Sample: timestamp.sh "Aug 15 11:09:00 CDT 2019"'
fi
