#!/usr/bin/env bash
cd "$(dirname "$0")"

# Start BT server
../Resources/app/SensorTagMidi poll http://127.0.0.1:8083 >/tmp/SensorTagMidi.log 2>&1 &

# launch the cocoa app
./apache-callback-mac -url "file://$(dirname "$0")/../Resources/index.html"

# Stop BT server
PID=`ps aux|grep SensorTagMidi|awk '{print $2}'`
kill ${PID}
