# 🛰️ Transmitter Module — BLDC Drift Car

## 🔧 Overview
The transmitter is responsible for sending throttle (speed) and steering (direction) data wirelessly to the receiver module using **ESP-NOW** protocol.  
It uses an **ESP32**, a **joystick**, and a **potentiometer** to control the drift car.

---

## ⚙️ Hardware Used
| Component | Quantity | Description |
|------------|-----------|-------------|
| ESP32 Dev Board | 1 | Main controller for transmission |
| Joystick Module | 1 | For steering control (X-axis used) |
| Potentiometer (10kΩ) | 1 | For throttle/speed control |
| 3.7V Li-ion Cell | 1 | Power supply for ESP32 |
| Connecting Wires | — | For circuit connections |

---

## 🧩 Pin Connections

| ESP32 Pin | Connected To | Function |
|------------|---------------|----------|
| 35 | Joystick X-axis | Steering input |
| 34 | Potentiometer Output | Throttle input |
| 3V3 | Power (+) | Power supply from Li-ion cell |
| GND | Ground | Common ground for all components |

> ⚠️ **Note:** The Li-ion cell directly powers the ESP32 since it operates around 3.3–3.7 V.  
> Ensure proper battery protection and charging circuitry when using a Li-ion cell.

---

## 📡 Working Principle
1. The **joystick** provides analog voltage corresponding to steering position.  
   - Mapped to servo angle values between **75°–115°**.
2. The **potentiometer** provides analog voltage corresponding to throttle level.  
   - Mapped to ESC PWM range of **1000–2000 µs**.
3. Both readings are converted into a string format:  
   - "<speed>,<angle>"
   - Example: `1450,90`
4. The data is transmitted via **ESP-NOW** to the receiver ESP32, which controls:
- **ESC (BLDC motor speed)**
- **Servo (steering angle)**

---

## 📶 Communication Setup
- **Protocol:** ESP-NOW  
- **WiFi Mode:** Station Mode  
- **Channel:** 1  
- **Target (Receiver) MAC:** `4C:C3:82:BE:EA:28`

The code uses `ESP32_NOW_Serial` to handle data transmission seamlessly.

---

## 🚀 Code Flow Summary
1. Initialize WiFi and ESP-NOW communication.  
2. Continuously read joystick and potentiometer values.  
3. Map readings to servo/ESC-compatible ranges.  
4. Send mapped values to receiver ESP32 every 50 ms.  
5. Print sent data on the Serial Monitor for debugging.

---

## 🧠 Key Functions
| Function | Description |
|-----------|--------------|
| `analogRead(pin)` | Reads analog voltage (0–4095). |
| `map(value, in_min, in_max, out_min, out_max)` | Converts raw input to required range. |
| `NowSerial.println(data)` | Sends data to receiver over ESP-NOW. |

---

## 🧾 Example Serial Output
Sending: 1425,90
Sending: 1900,110
Sending: 1150,80

---

## ⚡ Power Tips
- Use a **Li-ion charger module (TP4056)** for safe charging.  
- Add a small **switch** between cell and ESP32 for convenience.  
- Optionally include a **voltage divider** to monitor battery voltage if needed.

---
