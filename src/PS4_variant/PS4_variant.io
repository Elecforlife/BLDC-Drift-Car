#include <Bluepad32.h>
#include <ESP32Servo.h>

int escPin = 12;
int servoPin = 14;
Servo esc, steering;     // For direction (R1/L1)

ControllerPtr myControllers[BP32_MAX_GAMEPADS];

// === Callback: Controller connected ===
void onConnectedController(ControllerPtr ctl) {
    Serial.printf("Controller connected: %s\n", ctl->getModelName().c_str());
    for (int i = 0; i < BP32_MAX_GAMEPADS; i++) {
        if (!myControllers[i]) {
            myControllers[i] = ctl;
            break;
        }
    }
}

// === Callback: Controller disconnected ===
void onDisconnectedController(ControllerPtr ctl) {
    for (int i = 0; i < BP32_MAX_GAMEPADS; i++) {
        if (myControllers[i] == ctl) {
            myControllers[i] = nullptr;
            Serial.println("Controller disconnected");
            break;
        }
    }
}

// === Process gamepad input ===
void processGamepad(ControllerPtr ctl) {
    // --- 1. Handle Throttle trigger (0–1023) ---
    int throttleRaw = ctl->throttle();  // PS4 R2 trigger range: 0–1023
    int throttlePWM = map(throttleRaw, 0, 1023, 1000, 2000);
    throttlePWM = constrain(throttlePWM, 1000, 2000);

    // --- 2. Handle Steering via R1 / L1 buttons ---
    static int steerAngle = 95;  // Center
    if (ctl->r1()) {
        steerAngle = 115;  // Right
    } else if (ctl->l1()) {
        steerAngle = 75; // Left
    } else {
        steerAngle = 95;  // Neutral
    }
    steering.write(steerAngle);
    esc.writeMicroseconds(throttlePWM);

    // --- Debug info ---
    Serial.printf("ThrottleRaw=%4d | PWM=%4d | R1=%d | L1=%d | Steer=%d°\n",
                  throttleRaw, throttlePWM, ctl->r1(), ctl->l1(), steerAngle);
}

// === Process all controllers ===
void processControllers() {
    for (auto ctl : myControllers) {
        if (ctl && ctl->isConnected() && ctl->hasData() && ctl->isGamepad()) {
            processGamepad(ctl);
        }
    }
}

// === Setup ===
void setup() {
    Serial.begin(115200);
    Serial.println("=== Bluepad32: Throttle (0–1023 → 1000–2000) + R1/L1 Steering (75–115) ===");

    BP32.setup(&onConnectedController, &onDisconnectedController);
    BP32.enableVirtualDevice(false);

    esc.attach(escPin);
    steering.attach(servoPin);
    Serial.println("Arming ESC...");
    esc.writeMicroseconds(1000);
    Serial.println("ESC Armed!");
}

// === Loop ===
void loop() {
    bool dataUpdated = BP32.update();
    if (dataUpdated)
        processControllers();

    delay(30);
}
