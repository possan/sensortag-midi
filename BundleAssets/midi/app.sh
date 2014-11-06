#!/usr/bin/env bash
cd "$(dirname "$0")"

# Start node midi server
../Resources/app/node ../Resources/app/server.js >/tmp/MIDIServer.log 2>&1 &

# Get PID
sleep 0.1
PID=`ps aux|grep node|grep server.js|grep -v grep|awk '{print $2}'`

if [ "${PID}" ]
then

	# launch the cocoa app
	./apache-callback-mac -url "file://$(dirname "$0")/../Resources/index.html"

	# Stop node midi server
	kill ${PID}

else

	# Node failed to start
	exit 1

fi
