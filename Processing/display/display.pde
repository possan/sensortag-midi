import themidibus.*; //Import the library
import javax.sound.midi.MidiMessage; //Import the MidiMessage classes http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/MidiMessage.html
import javax.sound.midi.SysexMessage;
import javax.sound.midi.ShortMessage;

MidiBus myBus; // The MidiBus

// PImage background;

PImage cube1_0;
PImage cube1_1;
PImage cube1_2;
PImage cube1_3;
PImage cube1_4;
PImage cube1_5;

PImage cube2_0;
PImage cube2_1;
PImage cube2_2;
PImage cube2_3;
PImage cube2_4;
PImage cube2_5;

void setup() {
  size(1920,1080);
  background(0);
  
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this, 2, 0); // Create a new MidiBus object

  // background = loadImage("back.png");        

  cube1_0 = loadImage("cube1-0.png");        
  cube1_1 = loadImage("cube1-1.png");        
  cube1_2 = loadImage("cube1-2.png");        
  cube1_3 = loadImage("cube1-3.png");        
  cube1_4 = loadImage("cube1-4.png");        
  cube1_5 = loadImage("cube1-5.png");        

  cube2_0 = loadImage("cube2-0.png");        
  cube2_1 = loadImage("cube2-1.png");        
  cube2_2 = loadImage("cube2-2.png");        
  cube2_3 = loadImage("cube2-3.png");        
  cube2_4 = loadImage("cube2-4.png");        
  cube2_5 = loadImage("cube2-5.png");        
}

int cube1 = 4;
int cube2 = 3;

void draw() {
  clear();

  // image(background, 0, 0); 
  
  int x = 0;
  if (cube1 == 0) image(cube1_0, x, 0);
  if (cube1 == 1) image(cube1_1, x, 0);
  if (cube1 == 2) image(cube1_2, x, 0);
  if (cube1 == 3) image(cube1_3, x, 0);
  if (cube1 == 4) image(cube1_4, x, 0);
  if (cube1 == 5) image(cube1_5, x, 0);

  x = 1920 / 2;
  if (cube2 == 0) image(cube2_0, x, 0);
  if (cube2 == 1) image(cube2_1, x, 0);
  if (cube2 == 2) image(cube2_2, x, 0);
  if (cube2 == 3) image(cube2_3, x, 0);
  if (cube2 == 4) image(cube2_4, x, 0);
  if (cube2 == 5) image(cube2_5, x, 0);
}

void rawMidi(byte[] data) {
  int b0 = (int)(data[0] & 0xFF);
  println("raw midi b0=" + b0);

  if (b0 == 0xB0) {
    int b1 = (int)(data[1] & 0xFF);
    int b2 = (int)(data[2] & 0xFF);
    println("b1="+b1+", b2="+b2);

    if (b1 == 19) {
      cube1 = b2;
    }

    if (b1 == 29) {
      cube2 = b2;
    }
  }
}

  
