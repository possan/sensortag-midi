#!/usr/bin/env bash
cd "$(dirname "$0")"

# Start node midi server
../Resources/app/node ../Resources/app/server.js >/tmp/MIDIServer.log 2>&1 &

# launch the cocoa app
./apache-callback-mac -url "file://$(dirname "$0")/../Resources/index.html"

# Stop node midi server
PID=`ps aux|grep node|grep server.js|awk '{print $2}'`
kill ${PID}
