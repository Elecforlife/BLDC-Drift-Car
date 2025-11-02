# Wiring Diagram

The wiring is designed for both performance and safety.  
The 12V battery powers the ESC and motor directly, while a buck converter steps down voltage for logic and servo systems.

---

## 🧩 Power Flow

12V Battery → ESC → BLDC Motor
↳ ESC 5V BEC → ESP32 (Car Controller)
↳ Buck Converter 7V → Servo (MG995)

---

## 🔌 Connection Summary

| Component | Power | Signal | Notes |
|------------|--------|---------|-------|
| **ESP32 (Receiver)** | 5V (from ESC BEC) | PWM → ESC & Servo | Main brain |
| **ESC** | 12V | PWM input from ESP32 | Controls BLDC |
| **Servo (MG995)** | 7V (from buck) | PWM from ESP32 | Controls steering |
| **Transmitter ESP32** | 3.3–3.7V Li-ion | Pot + Joystick inputs | Sends via ESP-NOW |
| **Buck Converter** | 12V in → 7V out | — | Powers servo |
| **Li-ion Cell (Remote)** | 3.7V | — | Powers transmitter ESP32 |

---

## 📷 Diagram

