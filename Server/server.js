var http = require('http');
var fs = require('fs');
var midi = require('midi');

var id_order = [
    'E997B0FD-A0E7-4458-A56E-5B0A6657799E', // 10+
    '48EB35A4-9780-4E1C-8CBC-BB59409724E6', // 20+
    '21F26E62-1300-46F8-B84D-F86F28997D25', // 30+
];
var id_data = {};
var midi_state = {};
var last_midi_state = {};

function handlePost(data) {
    console.log('Got POST: ' + JSON.stringify(data));
    if (data.id) {
        var index = id_order.indexOf(data.id);
        if (index == -1) {
            id_order.push(data.id);
            index = id_order.length - 1;
        }
        id_data[index] = data;
    }
}

server = http.createServer( function(req, res) {
    if (req.method == 'POST') {
        var body = '';
        req.on('data', function (data) {
            body += data;
        });
        req.on('end', function () {
            try {
                handlePost(JSON.parse(body));
            } catch(e) {
                console.error(e);
            }
        });
        res.writeHead(200, {'Content-Type': 'text/plain'});
        res.end('ok');
    }
});

port = 8083;
host = '127.0.0.1';
server.listen(port, host);
console.log('Listening at http://' + host + ':' + port);

function setMIDI(cc, value) {
    if (value < 0) value = 0;
    if (value > 127) value = 127;

    if (typeof(midi_state[cc]) == 'undefined') {
        midi_state[cc] = value;
    }

    midi_state[cc] = value;
}

function interpMIDI(cc, value) {

    if (typeof(midi_state[cc]) == 'undefined') {
        midi_state[cc] = value;
    }

    midi_state[cc] += (value - midi_state[cc]) * 0.33;
}

var output = new midi.output();
output.getPortCount();
console.log('Sending MIDI to port #0: ' + output.getPortName(0));
output.openPort(0);

var output2 = new midi.output();
output2.getPortCount();
console.log('Sending MIDI to port #2: ' + output2.getPortName(2));
output2.openPort(2);

// send a little hello world message over midi
output.sendMessage([0xB0,0,0]);
output.sendMessage([0xB0,0,1]);
output.sendMessage([0xB0,0,0]);

var broadcast_timer = 0;

function lerp(input,inmin,inmax,outmin,outmax) {
    if (input < inmin) input = inmin;
    if (input > inmax) input = inmax;
    return outmin + ((outmax - outmin) * ((input - inmin) / (inmax - inmin)));
}

function clamp(input) {
    var inputclamp = input;
    // y=cos({x * 4})|_cdot_0.5+0.5
    if (inputclamp < -1.0) inputclamp = -1.0;
    if (inputclamp > 1.0) inputclamp = 1.0;
    return inputclamp;
}

function effectcurve(input) {
    var inputclamp = input;
    // y=cos({x * 4})|_cdot_0.5+0.5
    if (inputclamp < -1.0) inputclamp = -1.0;
    if (inputclamp > 1.0) inputclamp = 1.0;

    var y =
        (Math.cos(Math.PI * 2 * input + Math.PI) * 0.5 + 0.5)
        // *
        // Math.cos((clamp(input) + Math.PI) * 5.0)
        ;
    return 1.0 * y;
}

function sendMIDI() {
    // convert list of devices to midi channels.
    for(var d=0; d<5; d++) {
        if (typeof(id_data[d]) != 'undefined') {
            // CC 10 + 0 = RAW_
            var base = 10 + d * 10;

            var x = id_data[d].x;
            var y = id_data[d].y;
            var z = id_data[d].z;

            var side = 0;
            if (x > 0.5) {
                side = 1;
            } else if (y > 0.5) {
                side = 3;
            } else if (z > 0.5) {
                side = 5;
            } else if (x < -0.5) {
                side = 0;
            } else if (y < -0.5) {
                side = 2;
            } else if (z < -0.5) {
                side = 4;
            }

            // console.log(side);

            interpMIDI(base + 0, lerp( x, 0.1, 0.8, 0, 127));
            interpMIDI(base + 1, lerp(-x, 0.1, 0.8, 0, 127));
            interpMIDI(base + 2, lerp( y, 0.1, 0.8, 0, 127));
            interpMIDI(base + 3, lerp(-y, 0.1, 0.8, 0, 127));
            interpMIDI(base + 4, lerp( z, 0.1, 0.8, 0, 127));
            interpMIDI(base + 5, lerp(-z, 0.1, 0.8, 0, 127));

            interpMIDI(base + 6, 90.0 * (effectcurve(x) + effectcurve(y) + effectcurve(z)));

            setMIDI(base + 9, side);
        }
    }

    // send midi state to midi out
    var str = '';
    var anychange = false;

    for(var key in midi_state) {
        var value = Math.round(midi_state[key]);
        if (value < 0) value = 0;
        if (value > 127) value = 127;

        str += key+'='+value+' ';

        if (value != last_midi_state[key]) { // || (broadcast_timer % 50) == 0) {
            // console.log('Send MIDI CC #' + key + ' value ' + value);
            last_midi_state[key] = value;
            anychange = true;

            output.sendMessage([0xB0,0+key,value]);
            output2.sendMessage([0xB0,0+key,value]);
        }
    }

    if (str != '' && anychange) {
        console.log(str);
    }

    broadcast_timer ++;

    queueMIDI();
}

function queueMIDI() {
    setTimeout(sendMIDI, 30);
}

queueMIDI();