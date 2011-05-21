#include <EEPROM.h>
#include <AFMotor.h>
#include <Servo.h> 

AF_Stepper motor(48, 1);
Servo myservo;

void move_cw(int x);
void move_ccw(int x);
int det_spaces(int x, int y);
void raise_arm();
void lower_arm();



void setup(){
  motor.setSpeed(5);
  Serial.begin(9600);
  myservo.attach(10);
  myservo.write(180);
}



void loop(){
  int inbyte;
  if(Serial.available() > 0){

    inbyte = Serial.read();

    int spaces;
    int current = EEPROM.read(0);
    
    spaces = det_spaces(inbyte, current);
    lower_arm();
    
    if(spaces > 0){
      move_cw(spaces);
    }
    if(spaces < 0){
      spaces = abs(spaces);
      move_ccw(spaces);
    }
    

    current=inbyte;
    EEPROM.write(0, current);
    raise_arm();
    motor.release();
  }
}




void move_cw(int x){
  motor.step(x, FORWARD, DOUBLE);
  }

void move_ccw(int x){
  motor.step(x, BACKWARD, DOUBLE);
 }


void raise_arm(){
  int arm;
   for(arm=10; arm <180 ; arm++){
    myservo.write(arm);
    delay(15);
    return;
  }

}

void lower_arm(){
  int arm;
  for(arm = 180; arm > 10 ; arm--){
    myservo.write(arm);
    delay(50);
    return;
  }
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





