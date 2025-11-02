#include <Wire.h>
#include <MPU6050.h>
#include "ESP32_NOW_Serial.h"
#include "MacAddress.h"
#include "WiFi.h"
#include "esp_wifi.h"

#define ESPNOW_WIFI_MODE_STATION 1
#define ESPNOW_WIFI_CHANNEL 1
#if ESPNOW_WIFI_MODE_STATION          // ESP-NOW using WiFi Station mode
#define ESPNOW_WIFI_MODE WIFI_STA     // WiFi Mode
#define ESPNOW_WIFI_IF   WIFI_IF_STA  // WiFi Interface
#else                                 // ESP-NOW using WiFi AP mode
#define ESPNOW_WIFI_MODE WIFI_AP      // WiFi Mode
#define ESPNOW_WIFI_IF   WIFI_IF_AP   // WiFi Interface
#endif

int joyX = 35;
int potPin = 34;
int angle;
const MacAddress peer_mac({0x4C, 0xC3, 0x82, 0xBE, 0xEA, 0x28});
ESP_NOW_Serial_Class NowSerial(peer_mac, ESPNOW_WIFI_CHANNEL, ESPNOW_WIFI_IF);

void setup() {
  Serial.begin(115200);
  pinMode(potPin, INPUT);
  pinMode(joyX, INPUT);
  Serial.print("WiFi Mode: ");
  Serial.println(ESPNOW_WIFI_MODE == WIFI_AP ? "AP" : "Station");
  WiFi.mode(ESPNOW_WIFI_MODE);

  Serial.print("Channel: ");
  Serial.println(ESPNOW_WIFI_CHANNEL);
  WiFi.setChannel(ESPNOW_WIFI_CHANNEL, WIFI_SECOND_CHAN_NONE);

  while (!(WiFi.STA.started() || WiFi.AP.started())) {
    delay(100);
  }

  NowSerial.begin(115200);
  delay(3000);
  Wire.begin();

}

void loop() {
  int val = analogRead(joyX);     // Joystick X-axis
  int angle = map(val, 0, 4095, 75, 115);
  int potValue = analogRead(potPin); // Reads 0–4095
  int speed = map(potValue, 0, 4095, 1000, 2000);

  String data = String(speed) + "," + String(angle);

  // Send via ESP-NOW and print locally
  Serial.println("Sending: " + data);
  NowSerial.println(data);

  delay(50);
}
