#include <LSM303AGR_ACC_Sensor.h>
#include <LSM303AGR_MAG_Sensor.h>

#if defined(ARDUINO_SAM_DUE)
#define DEV_I2C Wire1   //Define which I2C bus is used. Wire1 for the Arduino Due
#define SerialPort Serial
#else
#define DEV_I2C Wire    //Or Wire
#define SerialPort Serial
#endif
LSM303AGR_ACC_Sensor *Acc;
LSM303AGR_MAG_Sensor *Mag;


void setup(){
//  Serial.begin(115200);
  Serial.begin(2000000);
  pinMode(A3, INPUT);
  DEV_I2C.begin();
  // Initlialize components.
  Acc = new LSM303AGR_ACC_Sensor(&DEV_I2C);
  Acc->Enable();
  Acc->EnableTemperatureSensor();
  Mag = new LSM303AGR_MAG_Sensor(&DEV_I2C);
  Mag->Enable();

}


void sendtopc(float f) {
  byte * b = (byte *) &f;
  Serial.write(b[0]);
  Serial.write(b[1]);
  Serial.write(b[2]);
  Serial.write(b[3]);
}

int i ;
int stp = 8;
void loop(){

  // Read magnetometer LSM303AGR.
  int32_t magnetometer[3];
  Mag->GetAxes(magnetometer);
  float temperature;
  Acc->GetTemperature(&temperature);
  int32_t accelerometer[3];
  Acc->GetAxes(accelerometer);

  Serial.write(195); // decimal value = 160 for handshaking
  Serial.write(192); // decimal value = 160 for handshaking
  Serial.write(105); // decimal value = 160 for handshaking
  Serial.write(95); // decimal value = 160 for handshaking
  sendtopc(magnetometer[0]);
  sendtopc(magnetometer[1]);
  sendtopc(magnetometer[2]);
  sendtopc(temperature);
  sendtopc(accelerometer[0]);
  sendtopc(accelerometer[1]);
  sendtopc(accelerometer[2]);
//  sendtopc(P2);
//  sendtopc(P3);
  delay(1);
}
