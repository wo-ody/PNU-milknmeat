#include <SoftwareSerial.h>
#include <DHT11.h>

#include <DHT.h>
#define DHTPIN A1
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);

//Pins  ************************
//UART TO HM10 Module
const uint8_t bluRX_ardTXpin = 5;
const uint8_t bluTX_ardRXpin = 4;

SoftwareSerial bluetooth(bluTX_ardRXpin, bluRX_ardTXpin);

//function prototypes
void checkBluetooth();

void setup() {
  dht.begin();
  bluetooth.begin(9600);
  Serial.begin(9600);
  bluetooth.print("AT+NAMEHello");
}

void loop() {
  checkBluetooth();
  delay(20);
}

void checkBluetooth() {
  char charBuffer[20];//most we would ever see
  
  if (bluetooth.available() > 0) {
    int numberOfBytesReceived = bluetooth.readBytesUntil('\n', charBuffer, 19);
    charBuffer[numberOfBytesReceived] = NULL;
        Serial.print("Received: ");
        Serial.println(charBuffer);

    if (strstr(charBuffer, "AT+START") == &charBuffer[0]) {
      Serial.println("AT+START");
      
      int h = dht.readHumidity();
      int t = dht.readTemperature();
    
      Serial.print("humidity: ");
      Serial.println(h);
    
      Serial.print("temperature: ");
      Serial.println(t);
      
      bluetooth.print(h);
      bluetooth.print('+');
      bluetooth.print(t);
  }

  }
}
