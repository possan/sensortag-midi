SensorTag To MIDI Hack
======================

[Texas Instruments SensorTags](http://www.ti.com/ww/en/wireless_connectivity/sensortag) are cheap, battery powered bluetooth low energy (BTLE) beacons that has lots of sensors built in.

Naturally all those sensors needs to be connect to MIDI somehow, this project does that (only using the accelerometer sensor for now), but it consists of a few different parts:

* **Objective-C Bluetooth Scanner** - Talks to the sensors using the built in Mac bluetooth stack (4.0 req.) - When readings are received, they are posted to a specific web address as JSON blobs.

* **Web-to-MIDI Bridge in Node.JS** - Waits for POST messages from the previous application, transforms the accelerometer values into cubes and figures out which sides are up and how much effects to apply, then sends those values as CC MIDI messages.

* **Ableton Live** - For playback and effects, with custom midi mappings that responds to CC sent from the proxy.

* **Processing** - Provides visual feedback of which sides of the cubes are in front/which sounds are playing, also listens for CC events on a MIDI port and updates the display accordingly.

Presented at MIDIHACK 2014 with sensors attached to a huge inflatable cube.
