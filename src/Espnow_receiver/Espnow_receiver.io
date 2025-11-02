#include "ESP32_NOW_Serial.h"
#include "MacAddress.h"
#include "WiFi.h"
#include "ESP32Servo.h"
#include "esp_wifi.h"

#define ESPNOW_WIFI_MODE_STATION 1
#define ESPNOW_WIFI_CHANNEL 1

#if ESPNOW_WIFI_MODE_STATION
#define ESPNOW_WIFI_MODE WIFI_STA
#define ESPNOW_WIFI_IF WIFI_IF_STA
#else
#define ESPNOW_WIFI_MODE WIFI_AP
#define ESPNOW_WIFI_IF WIFI_IF_AP
#endif

// MAC address of the MASTER ESP32 (change this!)
const MacAddress peer_mac({0x00, 0x4B, 0x12, 0x22, 0xD4, 0x88});
ESP_NOW_Serial_Class NowSerial(peer_mac, ESPNOW_WIFI_CHANNEL, ESPNOW_WIFI_IF);

int escPin = 12;
int servoPin = 14;
Servo esc, steering;

void setup() {
  Serial.begin(115200);
  Serial.println("Slave ESP32 - Starting...");

  WiFi.mode(ESPNOW_WIFI_MODE);
  WiFi.setChannel(ESPNOW_WIFI_CHANNEL, WIFI_SECOND_CHAN_NONE);

  while (!(WiFi.STA.started() || WiFi.AP.started())) {
    delay(100);
  }

  Serial.print("My MAC: ");
  Serial.println(WiFi.macAddress());

  NowSerial.begin(115200);
  Serial.println("ESP-NOW listening...");

  esc.attach(escPin);
  steering.attach(servoPin);

  Serial.println("Arming ESC...");
  esc.writeMicroseconds(1000);
  delay(4000);
  Serial.println("ESC Armed!");
}

void loop() {
  if (NowSerial.available()) {
    String data = NowSerial.readStringUntil('\n');
    int comma = data.indexOf(',');
    if (comma > 0) {
      int speed = data.substring(0, comma).toInt();
      int angle = data.substring(comma + 1).toInt();

      esc.writeMicroseconds(speed);
      steering.write(angle);

      Serial.printf("Speed: %d | Angle: %d\n", speed, angle);
    }
  }
  delay(20);
}
