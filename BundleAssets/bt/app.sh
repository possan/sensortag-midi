#!/usr/bin/env bash
cd "$(dirname "$0")"

# Start BT server
../Resources/app/SensorTagMidi poll http://127.0.0.1:8083 >/tmp/SensorTagMidi.log 2>&1 &

# Get PID
sleep 0.1
PID=`ps aux|grep SensorTagMidi|grep -v grep|awk '{print $2}'`

if [ "${PID}" ]
then

	# launch the cocoa app
	./apache-callback-mac -url "file://$(dirname "$0")/../Resources/index.html"

	# Stop BT server
	kill ${PID}

else

	# Didn't start at all,
	exit 1

fi
