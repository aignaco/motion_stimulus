#include <IRROBOT_ServoTesterShield.h>
//#include <Utility.h>

#define ID_NUM 0

IRROBOT_ServoTesterShield Tester(&Serial1);

int armHome = 900; 


void setup() {
  // In mightyZap's documentation 32 == 9600 baud rate, so esentially I am putting the servo shield and the 
  // Serial monitor on the same baud rate
  Serial.begin(9600);

  Tester.begin();
  Tester.servo_CH1.writeMicroseconds(armHome);


}

void loop() {
  // put your main code here, to run repeatedly:
  if (Serial.available()) {
    int type = Serial.parseInt();

    if (type == 1){
      int goalPos = Serial.parseInt();
      Tester.servo_CH1.writeMicroseconds(goalPos); 
    }
  }
  delay(0); 

}
