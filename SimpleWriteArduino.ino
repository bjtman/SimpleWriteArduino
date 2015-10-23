
// Wiring/Arduino code:
// Read data from the serial and turn ON or OFF a light depending on the value

#include <Servo.h>
#include "meArm.h"
#include "Wire.h"
#include "LiquidTWI.h"

Servo gripperservo;  // create servo object to control a servo
Servo baseservo;
Servo shoulderservo;
Servo elbowservo;


char val; // Data received from the serial port
int ledPin =11; // Set the pin to digital I/O 4
int fadePin = 9; // Set the pin for digial fade.
int fadeValue = 0; // A value between 0 and 255 mapped from video length
float videoTime = 0.0;

int videoTimeInMillis = 0;
int buttonState;
int gripperPin = 6;

LiquidTWI lcd(0);
 
void setup() 
{
  
  gripperservo.attach(6); // the gripper: 0 means open, 77 means closed
  baseservo.attach(11);
//  shoulderservo.attach(10);
//  elbowservo.attach(9);
  
  // set up the LCD's number of rows and columns: 
  lcd.begin(16, 2);
  pinMode(ledPin, OUTPUT); // Set pin as OUTPUT
  pinMode(fadePin, OUTPUT); // Set pin as OUTPUT
  Serial.begin(115200); // Start serial communication at 9600 bps
  digitalWrite(fadePin,LOW); 
  lcd.print("The 3rd Hand");
  gripperservo.write(0);
  delay(3000);
 // elbowservo.write(80);
  lcd.clear();
  gripperservo.write(30);
}
 
void loop() 
{
  //lcd.clear();
   // if there's any serial available, read it:
  while (Serial.available() > 0) {

    // look for the next valid integer in the incoming serial stream:
    videoTime = Serial.parseFloat();
    // do it again:
    buttonState = Serial.parseInt();
   

    // look for the newline. That's the end of your
    // sentence:
    if (Serial.read() == '\n') {
     
   
    
   
/*  if (Serial.available() > 0) {
    // get incoming byte:
    val = Serial.read(); 
  }
*/

  
  lcd.setCursor(0, 0);
  lcd.print(videoTime);
  lcd.setCursor(0,1);
  lcd.print(buttonState);
  
    //Serial.println(inputString);
    
      
  if (buttonState == 1) 
  { // If H was received
    lcd.clear();
    lcd.setCursor(0,1);
    lcd.print(buttonState);
  } 
  /*else 
  {
    digitalWrite(ledPin, LOW); // Otherwise turn it OFF
    // analogWrite(fadePin, 0);
    lcd.print("L");
  } */  
      
    //fadeValue = map(inputString.toInt(),0,8000,0,205);
    analogWrite(fadePin, fadeValue);
    
  if(buttonState == 2) // time to move!
  {
     
     if(videoTime < 28) 
     {
        gripperservo.write(0);
        baseservo.write(45);
     }
     else if(videoTime < 30) {
        //gripperservo.write(77);
        baseservo.write(90);
     }
     else if(videoTime < 32) {
        gripperservo.write(0);
     }
     
     
    /* gripperservo.write(77);
     delay(1000);
     gripperservo.write(0);
     delay(1000);
     gripperservo.write(45);
     delay(1000);
     gripperservo.write(0);
     delay(1000);
     gripperservo.write(45);
     delay(1000);
     gripperservo.write(77);
     delay(1000);
     gripperservo.write(0); */
  } 
    
    
  
 
  
   
  //fadeValue = map(inputString.toInt(),0,8000,0,205);
 // analogWrite(fadePin, fadeValue);
//  delay(100); // Wait 100 milliseconds for next reading
    }
   // lcd.clear();
}
}


