import themidibus.*; //Import the library
import javax.sound.midi.MidiMessage; //Import the MidiMessage classes http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/MidiMessage.html
import javax.sound.midi.SysexMessage;
import javax.sound.midi.ShortMessage;

MidiBus myBus; // The MidiBus

// PImage background;

PImage cube1_1;
PImage cube1_2;
PImage cube1_3;
PImage cube1_4;
PImage cube1_5;
PImage cube1_6;

PImage cube2_1;
PImage cube2_2;
PImage cube2_3;
PImage cube2_4;
PImage cube2_5;
PImage cube2_6;

PImage cube3_1;
PImage cube3_2;
PImage cube3_3;
PImage cube3_4;
PImage cube3_5;
PImage cube3_6;

PImage overlay;

void setup() {
  size(1920,1200);
  background(0);
  
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this, 2, 0); // Create a new MidiBus object

  // background = loadImage("back.png");        
  
  // bild 1 = vinkel 3
  // bild 2 = vinkel 2
  // bild 3 = vinkel 4
  // bild 4 = vinkel 6
  // bild 5 = vinkel 1
  // bild 6 = vinkel 5
  
  // vinkel 1 = bild 5
  // vinkel 2 = bild 2
  // vinkel 3 = bild 1
  // vinkel 4 = bild 3
  // vinkel 5 = bild 6
  // vinkel 6 = bild 4
  
  

  cube1_1 = loadImage("cube1_side5.png");        
  cube1_2 = loadImage("cube1_side2.png");        
  cube1_3 = loadImage("cube1_side1.png");        
  cube1_4 = loadImage("cube1_side3.png");        
  cube1_5 = loadImage("cube1_side6.png");        
  cube1_6 = loadImage("cube1_side4.png");        

  cube2_1 = loadImage("cube2_side5.png");        
  cube2_2 = loadImage("cube2_side2.png");        
  cube2_3 = loadImage("cube2_side1.png");        
  cube2_4 = loadImage("cube2_side3.png");        
  cube2_5 = loadImage("cube2_side6.png");        
  cube2_6 = loadImage("cube2_side4.png"); 
  
  cube3_1 = loadImage("cube3_side5.png");        
  cube3_2 = loadImage("cube3_side2.png");        
  cube3_3 = loadImage("cube3_side1.png");        
  cube3_4 = loadImage("cube3_side3.png");        
  cube3_5 = loadImage("cube3_side6.png");        
  cube3_6 = loadImage("cube3_side4.png");   

  overlay = loadImage("overlay.png");   
}






int cube1 = 4;
int cube2 = 3;
int cube3 = 2;

void draw() {
  clear();

println("cube1="+cube1+", cube2="+cube2+", cube3="+cube3);
  // image(background, 0, 0); 
  
  int x = 0;
  if (cube1 == 1) image(cube1_1, x, 0);
  if (cube1 == 2) image(cube1_2, x, 0);
  if (cube1 == 3) image(cube1_3, x, 0);
  if (cube1 == 4) image(cube1_4, x, 0);
  if (cube1 == 5) image(cube1_5, x, 0);
  if (cube1 == 6) image(cube1_6, x, 0);

  x = 1920 * 1 / 3;
  if (cube2 == 1) image(cube2_1, x, 0);
  if (cube2 == 2) image(cube2_2, x, 0);
  if (cube2 == 3) image(cube2_3, x, 0);
  if (cube2 == 4) image(cube2_4, x, 0);
  if (cube2 == 5) image(cube2_5, x, 0);
  if (cube2 == 6) image(cube2_6, x, 0);
  
  x = 1920 * 2 / 3;
  if (cube3 == 1) image(cube3_1, x, 0);
  if (cube3 == 2) image(cube3_2, x, 0);
  if (cube3 == 3) image(cube3_3, x, 0);
  if (cube3 == 4) image(cube3_4, x, 0);
  if (cube3 == 5) image(cube3_5, x, 0);
  if (cube3 == 6) image(cube3_6, x, 0);
  
  image(overlay, 0, 0);
}

void rawMidi(byte[] data) {
  int b0 = (int)(data[0] & 0xFF);
  println("raw midi b0=" + b0);

  if (b0 == 0xB0) {
    int b1 = (int)(data[1] & 0xFF);
    int b2 = (int)(data[2] & 0xFF);
  //  println("b1="+b1+", b2="+b2);

    if (b1 == 19) {
      cube1 = b2 + 1;
    }

    if (b1 == 29) {
      cube2 = b2 + 1;
    }

    if (b1 == 39) {
      cube3 = b2 + 1;
    }
  }
}

  
