SensorTag To MIDI Hack
======================

[Texas Instruments SensorTags|http://www.ti.com/ww/en/wireless_connectivity/sensortag] are cheap, battery powered bluetooth low energy (BTLE) beacons that has lots of sensors built in.

Naturally all those sensors needs to be connect to MIDI, this project does that (only using the accelerometer sensor for now), but it consists of a few different parts:

* _Cocoa/ObjectiveC Binary_ that talks to the sensors using the built in Mac bluetooth stack (4.0 req.) - When readings are received, they are posted to a specific web address as JSON blobs.

* _Web-to-MIDI Proxy_ in NodeJS - Based on node-midi and express.

* _Ableton Live_ - For playback, with custom midi mappings

* _Processing Sketch_ - For visual feedback

Presented at MIDIHACK 2014
