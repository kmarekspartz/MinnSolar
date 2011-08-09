/*
MinnSolar v3
------------
Code by Kyle Marek-Spartz -- mare0132@umn.edu
Project by Vishnuu Mallik

Reads light sensors
then rotates a servo 
to move light sensors
to aim a camera
then triggers a relay
to take a picture

Wiring notes:
    Analog Sensors:
        0 0 degree (relative to camera) light sensor
        1 90
        2 180
        3 270
        4 10
        5 350

    Digital Pins:
        7 Relay for camera shutter
        9 Servo
*/

#include <Servo.h>  

Servo servo; // Initiates Servo

int pos = 0; // Servo position in degrees

int sensorvals[6]; // Integer array of adc sensor vals

int servopin = 9; // Output to Servo
int relaypin = 7; // Output to Relay

int lastPicture = 0; // Milliseconds of last triggered picture

int maxval = 0; // Used to determine max sensor
int maxsensor = 10; // Used to determine if tuned

void setup() {
    servo.attach(servopin); // Initiates Servo
    pinMode(relaypin,OUTPUT); // Initiates Relay
}

void loop(){
    while (maxsensor != 0){ // Asserts that camera is lined up
        maxval = 0;
        for (int x = 0; x < 6; x++) {
            if (sensorvals[x] > maxval){
                maxval = sensorvals[x];
                maxsensor = x;
            }
        }
        switch (maxsensor){
            case 0: 
                break;
            case 1:
                rotate(45);
                break;
            case 2:
                rotate(180);
                break;
            case 3:
                rotate(-45);
                break;
            case 4:
                rotate(5);
                break;
            case 5:
                rotate(-5);
                break;
        }
        readSensors(); // Breaks while loop
    }
    takePicture(); // Triggers Relay
}

void readSensors() {
    for (int x = 0; x < 6; x++) { // Cycles through analog inputs
        sensorvals[x] = analogRead(x); // Sets array vals to input
    }
}

void rotate(int deg) {
    /// Continuous Rotation Servo!!!
}

void takePicture(){
    if(millis() > 2000 + lastPicture){ // Makes sure it has been at least 2 seconds since last picture
        digitalWrite(relaypin,HIGH); // Sets Relay on
        delay(10); // Waits 10 milliseconds
        digitalWrite(relaypin,LOW); // Sets Relay off
        lastPicture = millis(); // Sets LastPicture to current time
    }
    readSensors(); // Goes into While loop, or gets ready for next picture, waiting 2000 milliseconds
}
