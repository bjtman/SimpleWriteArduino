// Brian Tice
// 10/15/2015
// 
// Merging simple serial write routines with video playback routines.

import processing.serial.*;
import processing.video.*;
import controlP5.*;

ControlP5 cp5;


int myColor = color(0,0,0);

int sliderValue = 100;
int sliderTicks1 = 100;
int sliderTicks2 = 30;
Slider abc;

int myColorBackground = color(0,0,0);
int knobValue = 100;

Knob myKnobA;
Knob myKnobB;
Button mybutton;

Serial myPort;  // Create object from Serial class
int val;        // Data received from the serial port
Movie movie;
String movieTimeString; // Convert the integer to string for passing along serial port

int movieTimeInMilliSeconds = 0;
float movieTimeInSeconds = 0.0;

boolean loopAgain = true;

void setup() 
{
  size(1000, 800);
  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[2];
  myPort = new Serial(this, portName, 115200);
  movie = new Movie(this, "ThirdHand.mp4");
  movie.loop();
  
  cp5 = new ControlP5(this);
  
  color c1 = color(204, 153, 0);
  color c2 = color(230, 10, 10);
  
  myKnobA = cp5.addKnob("Third Hand Sub Loop")
               .setRange(26,36)
               .setValue(26)
               .setPosition(795,650)
               .setRadius(50)
               .setDragDirection(Knob.VERTICAL)
               ;
                     
  myKnobB = cp5.addKnob("Third Hand Speed Control")
               .setRange(0,255)
               .setValue(220)
               .setPosition(100,210)
               .setRadius(50)
               .setNumberOfTickMarks(10)
               .setTickMarkLength(4)
               .snapToTickMarks(true)
               .setColorForeground(color(255))
               .setColorBackground(color(0, 160, 100))
               .setColorActive(color(255,255,0))
               .setDragDirection(Knob.HORIZONTAL)
               ;
  
  // create a new button with name 'buttonA'
mybutton =cp5.addButton("Third Hand Active")
     .setValue(0)
     .setPosition(372,730)
     .setSize(130,50)
     .setColorForeground(color(255))
     .setColorBackground(color(0, 160, 100))
     ;
  
     
  // add a vertical slider
  abc = cp5.addSlider("Complete")
       .setPosition(100,730)
       .setSize(600,20)
       .setRange(0,movie.duration())
       .setValue(128)
       ;
  
  // reposition the Label for controller 'slider'
  cp5.getController("Complete").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("Complete").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  

  
  // use Slider.FIX or Slider.FLEXIBLE to change the slider handle
  // by default it is Slider.FIX
               
   
  
}

void draw() {
  background(255);
  
  movieTimeInSeconds = movie.time();
  movieTimeString = str(movieTimeInSeconds);
  movieTimeInMilliSeconds = convertMovieTimeToMilliSeconds(movieTimeInSeconds);
  
  
  if (mouseOverRect() == true) {  // If mouse is over square,
    fill(0);                    // change color and
    myPort.write(movieTimeInSeconds + "," + 1 + "\n");            // send an H to indicate mouse is over square
    println(movieTimeInSeconds + "," + 1);
    movie.pause();
    loopAgain = false;
  } 
  
  else if((movieTimeInSeconds > 26) && (movieTimeInSeconds < 38)) {
    myPort.write(movieTimeInSeconds + "," + 2 + "\n");
    println(movieTimeInSeconds + "," + 2);
    mybutton.setColorBackground(color(230,10,10));
    myKnobA.setValue(movieTimeInSeconds);
    // set subtrack to red
    
  }
  
  
  
  else {                          // If mouse is not over square,
    fill(150);                      // change color and
    myPort.write(movieTimeInSeconds + "," + 0 + "\n");            // send an L otherwise
    println(movieTimeInSeconds + "," + 0);
     mybutton.setColorBackground(color(0,160,100));
      myKnobA.setValue(26);
    if(!loopAgain)
    {
      movie.loop();
      loopAgain = true;
    }
  }
  rect(50, 50, 100, 100);         // Draw a square
  
  image(movie, 0, 0, width, height);
  textSize(32);
  
  text(movieTimeString, 800, 30); 
  abc.setValue(movieTimeInSeconds);
  
  
  //movieTimeInSeconds = int(movie.time());
 // myPort.write(str(movieTimeInMilliSeconds));
 // myPort.write('\n');
  // println(movieTimeInMilliSeconds);
  //println("Movie in seconds: " + movieTimeString + "  Movie in MilliSeconds: " + movieTimeInMilliSeconds);
 
  
  
}

boolean mouseOverRect() 
{ // Test if mouse is over square
  return ((mouseX >= 50) && (mouseX <= 150) && (mouseY >= 50) && (mouseY <= 150));
}


void movieEvent(Movie m) 
{
  m.read();
}

int convertMovieTimeToMilliSeconds(float movieTimeInSeconds)
{
  return int(movieTimeInSeconds * 1000);
  
}

void slider(float theColor) {
  myColor = color(theColor);
  println("a slider event. setting background to "+theColor);
}



/*
  // Wiring/Arduino code:
 // Read data from the serial and turn ON or OFF a light depending on the value
 
 char val; // Data received from the serial port
 int ledPin = 4; // Set the pin to digital I/O 4
 
 void setup() {
 pinMode(ledPin, OUTPUT); // Set pin as OUTPUT
 Serial.begin(9600); // Start serial communication at 9600 bps
 }
 
 void loop() {
 if (Serial.available()) { // If data is available to read,
 val = Serial.read(); // read it and store it in val
 }
 if (val == 'H') { // If H was received
 digitalWrite(ledPin, HIGH); // turn the LED on
 } else {
 digitalWrite(ledPin, LOW); // Otherwise turn it OFF
 }
 delay(100); // Wait 100 milliseconds for next reading
 }
 
 */
