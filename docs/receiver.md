# 🚗 Receiver Module — BLDC Drift Car

## 🔧 Overview
The **receiver module** is the heart of the BLDC Drift Car.  
It receives real-time **speed** and **steering** commands from the transmitter (via **ESP-NOW**) and controls:
- A **BLDC motor** through an **ESC** (Electronic Speed Controller)
- A **steering servo (MG995)** for direction

This module uses another **ESP32** board for processing the wireless data and generating PWM signals.

---

## ⚙️ Hardware Used

| Component | Quantity | Description |
|------------|-----------|-------------|
| ESP32 Dev Board | 1 | Main controller |
| BLDC Motor | 1 | Vehicle drive motor |
| ESC (Electronic Speed Controller) | 1 | Drives BLDC motor |
| Servo Motor (MG995) | 1 | For front wheel steering |
| 12V Battery | 1 | Power source for ESC and motor |
| Buck Converter | 1 | Steps down 12V to ~7V for servo power |
| Connecting Wires | — | Power and signal connections |

---

## 🧩 Pin Connections

| ESP32 Pin | Connected To | Function |
|------------|---------------|----------|
| 12 | ESC Signal Wire | Throttle control (BLDC speed) |
| 14 | Servo Signal Wire | Steering control |
| 5V (from ESC BEC) | ESP32 5V Input | Power supply for ESP32 |
| GND | Common Ground | Shared with ESC and Servo |

> ⚠️ **Important:** Always connect all grounds together — ESC GND, Servo GND, and ESP32 GND.

---

## ⚡ Power Distribution

12V Battery
├──> ESC (drives BLDC motor)
│ └──> 5V BEC output → powers ESP32
└──> Buck Converter → 7V → Servo (MG995)

This ensures:
- Stable 5V supply to ESP32 via ESC’s internal BEC.
- Adequate power to the MG995 servo using a buck converter.

---

## 📡 Communication Setup

- **Protocol:** ESP-NOW  
- **WiFi Mode:** Station Mode  
- **Channel:** 1  
- **Peer MAC (Transmitter):** `00:4B:12:22:D4:88`

---

## 🚀 Code Flow Summary

1. Initialize **WiFi** and **ESP-NOW** communication.
2. Attach **ESC** to pin 12 and **Servo** to pin 14.
3. **Arm the ESC** (send 1000 µs signal for 4 seconds).
4. Continuously check for incoming data.
5. Parse data into:
   - `speed` → sent to ESC (1000–2000 µs)
   - `angle` → sent to Servo (75°–115°)
6. Update motor and steering in real time.

---

## 🧠 Key Functions

| Function | Description |
|-----------|--------------|
| `NowSerial.available()` | Checks if new data has been received |
| `NowSerial.readStringUntil('\n')` | Reads the latest transmitted data line |
| `esc.writeMicroseconds(speed)` | Sends PWM signal to ESC |
| `steering.write(angle)` | Rotates servo to specified angle |
| `WiFi.mode(WIFI_STA)` | Sets ESP32 in Station mode for ESP-NOW |

---
