# 🎮 PS4 Controller Variant — BLDC Drift Car

## 🔧 Overview
This variant replaces the ESP-NOW transmitter with a **wireless PS4 DualShock controller**, connected directly to the **ESP32** via **Bluetooth** using the **Bluepad32** library.

It gives smoother and more responsive control for both **throttle** and **steering**, while simplifying the hardware setup — no second ESP32 transmitter is required.

---

## ⚙️ Hardware Used

| Component | Quantity | Description |
|------------|-----------|-------------|
| ESP32 Dev Board | 1 | Main controller |
| BLDC Motor + ESC | 1 | For propulsion |
| Servo (MG995) | 1 | Steering control |
| 12V Battery | 1 | Power source for ESC and motor |
| Buck Converter | 1 | Steps down 12V → 7V for servo |
| PS4 DualShock Controller | 1 | Wireless input device |

---

## 🧩 Pin Connections

| ESP32 Pin | Connected To | Function |
|------------|---------------|----------|
| 12 | ESC Signal | Controls BLDC throttle |
| 14 | Servo Signal | Controls steering direction |
| 5V (from ESC BEC) | ESP32 5V | Powers ESP32 |
| GND | Common Ground | Shared between ESC, Servo, and ESP32 |

> ⚠️ Always connect **all grounds** together — this ensures stable PWM operation for both ESC and servo.

---

## ⚡ Power Flow

12V Battery
├──> ESC (drives BLDC motor)
│ └──> 5V BEC → powers ESP32
└──> Buck Converter → 7V → Servo (MG995)


---

## 🎮 Controller Mapping

| PS4 Control | Function | Range / Action |
|--------------|-----------|----------------|
| R2 Trigger | Throttle (speed) | 0 → 1023 → mapped to 1000–2000 µs |
| R1 Button | Turn Right | Sets steering to 115° |
| L1 Button | Turn Left | Sets steering to 75° |
| Neutral (no press) | Center | Sets steering to 95° |

---

## 🧠 Working Principle

1. The **PS4 controller** connects to the ESP32 via **Bluetooth** using the **Bluepad32** library.  
2. The ESP32 reads the **R2 trigger** for throttle and **R1/L1 buttons** for steering.  
3. The **R2 trigger** (0–1023) is mapped to PWM (1000–2000 µs) for the **ESC**.  
4. The **servo** angle is set depending on which button is pressed:
   - `R1 → 115°`  
   - `L1 → 75°`  
   - Neutral → `95°`
5. The values are updated continuously for real-time control.

---

## 🚀 Code Flow Summary

1. Initialize **Bluepad32** with connection callbacks.  
2. Attach **ESC** and **servo** to pins 12 and 14.  
3. **Arm the ESC** by writing 1000 µs at startup.  
4. On each controller update:
   - Read throttle from **R2** trigger.  
   - Read steering from **R1/L1** buttons.  
   - Map and send PWM signals to ESC and servo.  
5. Print debug info over Serial.

---

## 🧾 Example Serial Output

=== Bluepad32: Throttle (0–1023 → 1000–2000) + R1/L1 Steering (75–115) ===
Arming ESC...
ESC Armed!
Controller connected: DualShock 4
ThrottleRaw= 512 | PWM=1500 | R1=0 | L1=0 | Steer=95°
ThrottleRaw=1023 | PWM=2000 | R1=1 | L1=0 | Steer=115°
ThrottleRaw= 150 | PWM=1200 | R1=0 | L1=1 | Steer=75°

---

## 🧰 Setup Instructions

1. Install the **Bluepad32** library from the Arduino Library Manager or GitHub.  
2. Flash this code to the ESP32.  
3. Pair your PS4 controller:
   - Hold **Share + PS** buttons together until the LED blinks rapidly.  
   - Wait for the Serial Monitor to show `Controller connected`.  
4. After pairing once, it will auto-connect next time on power-up.  
5. Power sequence:
   - Connect 12V battery → powers ESC  
   - ESC powers ESP32 via 5V BEC  
   - Buck converter provides 7V to servo

---

## ⚙️ Library References

- **[Bluepad32 Library](https://github.com/ricardoquesada/bluepad32)**  
  For Bluetooth gamepad interface and controller input parsing.
- **ESP32Servo Library**  
  For precise PWM control of ESC and steering servo.

---

## ⚡ Tips & Safety

- Keep wheels lifted during first tests.  
- Ensure servo is powered from a **separate 7V buck converter**, not directly from the ESP32.  
- If motor spins uncontrollably, recalibrate ESC with minimum throttle signal (1000 µs).  
- Check that **Bluetooth Classic** is enabled on ESP32.

---

