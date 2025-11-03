# 🚗 BLDC Drift Car

A high-performance RC drift car powered by a **BLDC motor**, controlled via **ESP-NOW wireless** or **PS4 controller**.  
This project combines wireless communication, PWM motor control, and embedded electronics for realistic drifting.

---

## 🧠 Project Overview

Two modes of operation:
1. **ESP-NOW Mode** – Wireless transmitter (ESP32 + Pot + Joystick) → Car ESP32  
2. **PS4 Mode** – Bluetooth PS4 controller → Car ESP32  

Both variants control:
- **ESC** for BLDC throttle  
- **Servo (MG995)** for steering

---

## ⚙️ Hardware Setup

| Module | Component | Power Source |
|---------|------------|--------------|
| **Transmitter** | ESP32 + Pot + Joystick | 3.7V Li-ion |
| **Receiver (Car)** | ESP32 + ESC + Servo | 12V Battery → ESC 5V BEC + Buck 7V |
| **Motor** | BLDC | ESC Output |
| **Servo** | MG995 | Buck 7V Output |

---

## 🔌 Power Flow Diagram

12V Battery → ESC → BLDC Motor
↳ ESC 5V BEC → ESP32 (Car)
↳ Buck 7V → Servo MG995

---

## 📡 Communication Flow (ESP-NOW)

ESP32 (Transmitter)
├─ Pot → Throttle
└─ Joystick → Steering
↓
ESP-NOW Wireless
↓
ESP32 (Receiver)
├─ PWM → ESC
└─ PWM → Servo

---

## 🎮 PS4 Variant

In this mode, the ESP32 directly connects to a **PS4 Controller via Bluetooth**, removing the need for a separate transmitter.  
The car then reads analog stick and button data to control throttle and steering.

---

## 🧰 Source Code

- `/src/espnow_transmitter` → Transmitter code
- `/src/espnow_receiver` → Car receiver code
- `/src/ps4_variant` → Bluetooth PS4 version

---

## 🛠️ Features

- Wireless drift control (ESP-NOW)
- Bluetooth PS4 compatibility
- Smooth throttle mapping (1000–2000 µs)
- Servo steering control with angle mapping
- Separate power management for motor and servo

---

## 🎥 Demo

https://github.com/user-attachments/assets/259c5a19-ed34-4902-a378-7739fdd49894
