// Application Software for Microcontroller 
// 17/04/2014 by Robert Makepeace
// based on application software developed by Jeff Rowberg
// I2C device class (I2Cdev) demonstration Arduino sketch for MPU6050 class
// 10/7/2011 by Jeff Rowberg <jeff@rowberg.net>
// Updates should (hopefully) always be available at https://github.com/jrowberg/i2cdevlib
//
// Changelog:
//      2013-05-08 - added multiple output formats
//                 - added seamless Fastwire support
//      2011-10-07 - initial release

/* ============================================
I2Cdev device library code is placed under the MIT license
Copyright (c) 2011 Jeff Rowberg

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
===============================================
*/

// I2Cdev and MPU9150 must be installed as libraries, or else the .cpp/.h files
// for both classes must be in the include path of your project
#include "I2Cdev.h"
#include "MPU9150.h"
#include "Timer.h"

// Arduino Wire library is required if I2Cdev I2CDEV_ARDUINO_WIRE implementation
// is used in I2Cdev.h
#if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
    #include "Wire.h"
#endif

// class default I2C address is 0x68
// specific I2C addresses may be passed as a parameter here
// AD0 low = 0x68 (default for InvenSense evaluation board)
// AD0 high = 0x69
MPU9150 accelgyro;
//MPU6050 accelgyro(0x69); // <-- use for AD0 high

int16_t ax, ay, az;
int16_t gx, gy, gz;
int16_t mx, my, mz;
unsigned long time;

int mode;
#define BLUE_INT_FAST     1
#define BLUE_INT_TWOWAY   2
#define BLUE_INT_TIMER    3
#define BLUE_BIN_FAST     4
#define BLUE_BIN_TWOWAY   5
#define BLUE_BIN_TIMER    6
#define USB_INT_FAST      7
#define USB_INT_TWOWAY    8
#define USB_INT_TIMER     9
#define USB_BIN_FAST      10
#define USB_BIN_TWOWAY    11
#define USB_BIN_TIMER     12
Timer t;
#define LED_PIN 13
bool blinkState = false;
void setup() {
    char in_val = -1;
    char blue_in_val = -1;
    char usb_in_val = -1;    
    // join I2C bus (I2Cdev library doesn't do this automatically)
    #if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
        Wire.begin();
    #elif I2CDEV_IMPLEMENTATION == I2CDEV_BUILTIN_FASTWIRE
        Fastwire::setup(400, true);
    #endif

    // initialize serial communication
    // (38400 chosen because it works as well at 8MHz as it does at 16MHz, but
    // it's really up to you depending on your project)
    //USB
    Serial.begin(38400);
    //Bluetooth
    Serial1.begin(38400);

    delay(500);
     
    //Get ready for serial
    while(in_val == -1 || (in_val < 'a' && in_val > 'l')){
        delay(1);
        blue_in_val = Serial1.read();
        usb_in_val = Serial.read();    
        if (usb_in_val > blue_in_val) {
          in_val = usb_in_val;  
        } else {
          in_val = blue_in_val;
        }      
    }
 
    //Determine printing mode
    if (in_val == 'a') {
        mode = BLUE_INT_FAST;
    } else if (in_val == 'b') {
        mode = BLUE_INT_TWOWAY;   
    } else if (in_val == 'c') {
        mode = BLUE_INT_TIMER;   
        int tickEvent = t.every(50, printOutput);
    } else if (in_val == 'd') {
        mode = BLUE_BIN_FAST;   
    } else if (in_val == 'e') {
        mode = BLUE_BIN_TWOWAY;   
    } else if (in_val == 'f') {
        mode = BLUE_BIN_TIMER;  
        int tickEvent = t.every(50, printOutput);   
    } else if (in_val == 'g') {
        mode = USB_INT_FAST;
    } else if (in_val == 'h') {
        mode = USB_INT_TWOWAY;   
    } else if (in_val == 'i') {
        mode = USB_INT_TIMER;   
        int tickEvent = t.every(50, printOutput);
    } else if (in_val == 'j') {
        mode = USB_BIN_FAST;   
    } else if (in_val == 'k') {
        mode = USB_BIN_TWOWAY;   
    } else if (in_val == 'l') {
        mode = USB_BIN_TIMER;  
        int tickEvent = t.every(50, printOutput);   
    }           
    delay(500);
     // initialize device
    Serial.println("Initializing I2C devices...");    
    Serial1.println("Initializing I2C devices...");
    accelgyro.initialize();

    // verify connection
    Serial.println("Testing device connections...");    
    Serial1.println("Testing device connections...");
    Serial.println(accelgyro.testConnection() ? "MPU6050 connection successful" : "MPU6050 connection failed");    
    Serial1.println(accelgyro.testConnection() ? "MPU6050 connection successful" : "MPU6050 connection failed");
     // use the code below to change accel/gyro offset values
    
    //Serial1.println("Updating internal sensor offsets...");
    // -76	-2359	1688	0	0	0
    accelgyro.setXGyroOffset(6);
    accelgyro.setYGyroOffset(0);
    accelgyro.setZGyroOffset(3);
    Serial.println("A Offsets ");
    Serial.print(accelgyro.getXAccelOffset()); Serial.print("\t"); // -76
    Serial.print(accelgyro.getYAccelOffset()); Serial.print("\t"); // -2359
    Serial.print(accelgyro.getZAccelOffset()); Serial.println("\t"); // 1688
    Serial.println("G Offsets ");    
    Serial.print(accelgyro.getXGyroOffset()); Serial.print("\t"); // 0
    Serial.print(accelgyro.getYGyroOffset()); Serial.print("\t"); // 0
    Serial.print(accelgyro.getZGyroOffset()); Serial.println("\t"); // 0
    Serial1.print("\n");
    Serial1.println("A Offsets ");    
    Serial1.print(accelgyro.getXAccelOffset()); Serial1.print("\t"); // -76
    Serial1.print(accelgyro.getYAccelOffset()); Serial1.print("\t"); // -2359
    Serial1.print(accelgyro.getZAccelOffset()); Serial1.println("\t"); // 1688
    Serial1.println("G Offsets ");        
    Serial1.print(accelgyro.getXGyroOffset()); Serial1.print("\t"); // 0
    Serial1.print(accelgyro.getYGyroOffset()); Serial1.print("\t"); // 0
    Serial1.print(accelgyro.getZGyroOffset()); Serial1.println("\t"); // 0
    Serial1.print("\n");
    // configure Arduino LED for
    pinMode(LED_PIN, OUTPUT);
  delay(1000);
}

void loop() {
    if (mode == BLUE_INT_FAST || mode == BLUE_BIN_FAST || mode == USB_INT_FAST || mode == USB_BIN_FAST) {
      printOutput();    
    } else if (mode == BLUE_INT_TWOWAY || mode == BLUE_BIN_TWOWAY) {
      while(Serial1.read() != 'Y') {
        delay(1);
      }
      printOutput();  
     } else if (mode == USB_INT_TWOWAY || mode == USB_BIN_TWOWAY) {
      while(Serial.read() != 'Y') {
        delay(1);
      }
      printOutput();        
    } else if (mode == BLUE_INT_TIMER || mode == BLUE_BIN_TIMER || mode == USB_INT_TIMER || mode == USB_BIN_TIMER) {
      t.update();
    }
}
void printOutput() { 
    // read raw accel/gyro measurements from device
    accelgyro.getMotion9(&ax, &ay, &az, &gx, &gy, &gz, &mx, &my, &mz);
    time = millis();
    
    if (mode == BLUE_INT_FAST || mode == BLUE_INT_TWOWAY || mode == BLUE_INT_TIMER) {
        Serial1.print(time); Serial1.print(" ");          
        Serial1.print(ax); Serial1.print(" ");      
        Serial1.print(ay); Serial1.print(" ");      
        Serial1.print(az); Serial1.print(" ");       
        Serial1.print(gx); Serial1.print(" ");        
        Serial1.print(gy); Serial1.print(" ");     
        Serial1.print(gz); Serial1.print(" ");      
        Serial1.print(mx); Serial1.print(" ");        
        Serial1.print(my); Serial1.print(" ");        
        Serial1.print(mz); Serial1.println(" ");         

    } else if (mode == BLUE_BIN_FAST || mode == BLUE_BIN_TWOWAY || mode == BLUE_BIN_TIMER) {      
        Serial1.write((uint8_t)(time >> 24));Serial1.write((uint8_t)(time >> 16));Serial1.write((uint8_t)(time >> 8)); Serial1.write((uint8_t)(ax & 0xFF));
        Serial1.write((int8_t)(ax >> 8)); Serial1.write((uint8_t)(ax & 0xFF));
        Serial1.write((int8_t)(ay >> 8)); Serial1.write((uint8_t)(ay & 0xFF));
        Serial1.write((int8_t)(az >> 8)); Serial1.write((uint8_t)(az & 0xFF));
        Serial1.write((int8_t)(gx >> 8)); Serial1.write((uint8_t)(gx & 0xFF));
        Serial1.write((int8_t)(gy >> 8)); Serial1.write((uint8_t)(gy & 0xFF));
        Serial1.write((int8_t)(gz >> 8)); Serial1.write((uint8_t)(gz & 0xFF));
        Serial1.write((int8_t)(mx >> 8)); Serial1.write((uint8_t)(mx & 0xFF));
        Serial1.write((int8_t)(my >> 8)); Serial1.write((uint8_t)(my & 0xFF));
        Serial1.write((int8_t)(mz >> 8)); Serial1.write((uint8_t)(mz & 0xFF));
        Serial1.println("");  
    } else if (mode == USB_INT_FAST || mode == USB_INT_TWOWAY || mode == USB_INT_TIMER) {
        Serial.print(time); Serial.print(" ");          
        Serial.print(ax); Serial.print(" ");      
        Serial.print(ay); Serial.print(" ");      
        Serial.print(az); Serial.print(" ");       
        Serial.print(gx); Serial.print(" ");        
        Serial.print(gy); Serial.print(" ");     
        Serial.print(gz); Serial.print(" ");      
        Serial.print(mx); Serial.print(" ");        
        Serial.print(my); Serial.print(" ");        
        Serial.print(mz); Serial.println(" ");         
    } else if (mode == USB_BIN_FAST || mode == USB_BIN_TWOWAY || mode == USB_BIN_TIMER) {
Serial.write((uint8_t)(time >> 24));Serial.write((uint8_t)(time >> 16));Serial.write((uint8_t)(time >> 8)); Serial.write((uint8_t)(ax & 0xFF));
        Serial.write((int8_t)(ax >> 8)); Serial.write((uint8_t)(ax & 0xFF));
        Serial.write((int8_t)(ay >> 8)); Serial.write((uint8_t)(ay & 0xFF));
        Serial.write((int8_t)(az >> 8)); Serial.write((uint8_t)(az & 0xFF));
        Serial.write((int8_t)(gx >> 8)); Serial.write((uint8_t)(gx & 0xFF));
        Serial.write((int8_t)(gy >> 8)); Serial.write((uint8_t)(gy & 0xFF));
        Serial.write((int8_t)(gz >> 8)); Serial.write((uint8_t)(gz & 0xFF));
        Serial.write((int8_t)(mx >> 8)); Serial.write((uint8_t)(mx & 0xFF));
        Serial.write((int8_t)(my >> 8)); Serial.write((uint8_t)(my & 0xFF));
        Serial.write((int8_t)(mz >> 8)); Serial.write((uint8_t)(mz & 0xFF));
        Serial.println("");         
    }

    // blink LED to indicate activity
    blinkState = !blinkState;
    digitalWrite(LED_PIN, blinkState);
}
