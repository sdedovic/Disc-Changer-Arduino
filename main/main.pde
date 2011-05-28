#include <Servo.h>
#include <EEPROM.h>
#include <AFMotor.h>


void move_cw(int x);
void move_ccw(int x);
int det_spaces(int x, int y);
void servoL();
void servoH();

AF_Stepper motor(48, 1);
Servo servo;
int current=-1;
int servoTime=20;
int sLow=0;
int sHigh=90;

void setup(){
  servo.attach(9);
  motor.setSpeed(12);
  Serial.begin(9600);
  current = EEPROM.read(0);
}

void loop(){
  int inbyte;
  int spaces;
  float steps;
  float gearRatio = 11.796;
  
  if(Serial.available() > 0){

    inbyte = Serial.read();

    spaces = det_spaces(inbyte, current);
    steps = spaces * gearRatio;
    
    servoL();
    
    if(steps > 0){
      move_cw((int)(steps+.5));
    }
    if(steps < 0){
      steps = abs(steps);
      move_ccw((int)(steps+.5));
    }
    
    servoH();
    
    current=inbyte;
    EEPROM.write(0, current);
    
  }
}



void move_cw(int x){
  motor.step(x, FORWARD, DOUBLE);
  delay(1000);
  motor.release();
  }

void move_ccw(int x){
  motor.step(x, BACKWARD, DOUBLE);
  delay(1000);
  motor.release();
 }


int det_spaces(int x, int y){  // x = desired, y = current, z = spaces
  int z;  
  if(x>y){
    z=x-y;
    if(z<=12)
      return z;
    else if(z>12){
      z=24-z;
      z=-z;
      return z;
    }
  }
  if(x<y){
    z=y-x;
    if(z<=12){
      z=-z;
      return z;
    }
    else if(z>12){
      z=24-z;
      return z;
    }
  }
  if(x==y){
    z=0;
    return z;
  }
}

void servoL(){
  int move;
  for(move=sHigh; move>sLow; move--){
    servo.write(move);
    delay(servoTime);
  }
  delay(2000);
}


void servoH(){
  delay(500);
  int move;
  for(move=sLow; move<sHigh; move++){
    servo.write(move);
    delay(servoTime);
  }
  delay(2000);
}

