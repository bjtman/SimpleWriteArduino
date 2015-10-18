
// Wiring/Arduino code:
// Read data from the serial and turn ON or OFF a light depending on the value

#include "meArm.h"
#include <Servo.h>
// include the library code:
#include "Wire.h"
#include "LiquidCrystal.h"
 
char val; // Data received from the serial port
int ledPin =11; // Set the pin to digital I/O 4
int fadePin = 9; // Set the pin for digial fade.
int fadeValue = 0; // A value between 0 and 255 mapped from video length
float videoTime = 0.0;



LiquidCrystal lcd(0);
 
void setup() 
{
  
  // set up the LCD's number of rows and columns: 
  lcd.begin(16, 2);
  pinMode(ledPin, OUTPUT); // Set pin as OUTPUT
  pinMode(fadePin, OUTPUT); // Set pin as OUTPUT
  Serial.begin(115200); // Start serial communication at 9600 bps
  digitalWrite(fadePin,LOW);
  lcd.print("Test");
  delay(3000);
}
 
void loop() 
{
  //serialEvent(); //call the function
   
   
   
  if (Serial.available() > 0) {
    // get incoming byte:
    val = Serial.read(); 
  }
  
  lcd.setCursor(0, 1);
  
  
    //Serial.println(inputString);
    
      
  if (val == 'H') 
  { // If H was received
    digitalWrite(ledPin, HIGH); // turn the LED on
    lcd.print("H");
  } 
  else 
  {
    digitalWrite(ledPin, LOW); // Otherwise turn it OFF
    // analogWrite(fadePin, 0);
    lcd.print("L");
  }  
      
    //fadeValue = map(inputString.toInt(),0,8000,0,205);
    analogWrite(fadePin, fadeValue);
    
   
  
 
  
   
  //fadeValue = map(inputString.toInt(),0,8000,0,205);
 // analogWrite(fadePin, fadeValue);
//  delay(100); // Wait 100 milliseconds for next reading
}
 


