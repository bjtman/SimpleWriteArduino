// Brian Tice
// 10/15/2015
// 
// Merging simple serial write routines with video playback routines.

import processing.serial.*;
import processing.video.*;

Serial myPort;  // Create object from Serial class
int val;        // Data received from the serial port
Movie movie;
String movieTimeString; // Convert the integer to string for passing along serial port

int movieTimeInMilliSeconds = 0;
float movieTimeInSeconds = 0.0;

boolean loopAgain = true;

void setup() 
{
  size(800, 800);
  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[2];
  myPort = new Serial(this, portName, 115200);
  movie = new Movie(this, "fingers.mov");
  movie.loop();
}

void draw() {
  background(255);
  
  movieTimeInSeconds = movie.time();
  movieTimeString = str(movieTimeInSeconds);
  movieTimeInMilliSeconds = convertMovieTimeToMilliSeconds(movieTimeInSeconds);
  
  
  if (mouseOverRect() == true) {  // If mouse is over square,
    fill(204);                    // change color and
    myPort.write(movieTimeInMilliSeconds + "," + 1 + "\n");            // send an H to indicate mouse is over square
    println(movieTimeInMilliSeconds + "," + 1);
    movie.pause();
    loopAgain = false;
  } 
  else {                          // If mouse is not over square,
    fill(0);                      // change color and
    myPort.write(movieTimeInMilliSeconds + "," + 0 + "\n");            // send an L otherwise
    println(movieTimeInMilliSeconds + "," + 0);
    if(!loopAgain)
    {
      movie.loop();
      loopAgain = true;
    }
  }
  rect(50, 50, 100, 100);         // Draw a square
  
  image(movie, 0, 0, width, height);
  textSize(32);
  
  text(movieTimeString, 600, 30); 
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
