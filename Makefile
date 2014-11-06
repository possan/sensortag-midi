all: midiapp btapp

OUTPUT=dist
MIDIBUNDLE=${OUTPUT}/SensorTag\ MIDI\ Server.app
BTBUNDLE=${OUTPUT}/SensorTag\ Bluetooth\ Server.app

midiapp:
	rm -rf ${MIDIBUNDLE}
	mkdir -p ${MIDIBUNDLE}/Contents/Resources/app
	mkdir -p ${MIDIBUNDLE}/Contents/Resources/English.lproj
	mkdir -p ${MIDIBUNDLE}/Contents/MacOS
	cp BundleAssets/MainMenu.nib ${MIDIBUNDLE}/Contents/Resources/English.lproj/
	cp BundleAssets/PkgInfo ${MIDIBUNDLE}/Contents/
	cp BundleAssets/apache-callback-mac ${MIDIBUNDLE}/Contents/MacOS/
	cp BundleAssets/midi/Info.plist ${MIDIBUNDLE}/Contents/
	cp BundleAssets/midi/index.html ${MIDIBUNDLE}/Contents/Resources/index.html
	cp BundleAssets/midi/app.sh ${MIDIBUNDLE}/Contents/MacOS/app.sh
	chmod +x ${MIDIBUNDLE}/Contents/MacOS/app.sh
	sips -s format icns BundleAssets/midi/icon.png --out ${MIDIBUNDLE}/Contents/Resources/icon.icns
	touch ${MIDIBUNDLE}
	touch ${MIDIBUNDLE}/Contents/Info.plist
	rm -rf ${MIDIBUNDLE}/Contents/Resources/app/*
	cp -R Server/* ${MIDIBUNDLE}/Contents/Resources/app/
	cp `which node` ${MIDIBUNDLE}/Contents/Resources/app/


btapp:
	rm -rf ${BTBUNDLE}
	mkdir -p ${BTBUNDLE}/Contents/Resources/app
	mkdir -p ${BTBUNDLE}/Contents/Resources/English.lproj
	mkdir -p ${BTBUNDLE}/Contents/MacOS
	cp BundleAssets/MainMenu.nib ${BTBUNDLE}/Contents/Resources/English.lproj/
	cp BundleAssets/PkgInfo ${BTBUNDLE}/Contents/
	cp BundleAssets/apache-callback-mac ${BTBUNDLE}/Contents/MacOS/
	cp BundleAssets/bt/Info.plist ${BTBUNDLE}/Contents/
	cp BundleAssets/bt/index.html ${BTBUNDLE}/Contents/Resources/index.html
	cp BundleAssets/bt/app.sh ${BTBUNDLE}/Contents/MacOS/app.sh
	chmod +x ${BTBUNDLE}/Contents/MacOS/app.sh
	sips -s format icns BundleAssets/bt/icon.png --out ${BTBUNDLE}/Contents/Resources/icon.icns
	touch ${BTBUNDLE}
	touch ${BTBUNDLE}/Contents/Info.plist
	rm -rf ${BTBUNDLE}/Contents/Resources/app/*
	cp BundleAssets/SensorTagMidi ${BTBUNDLE}/Contents/Resources/app/
