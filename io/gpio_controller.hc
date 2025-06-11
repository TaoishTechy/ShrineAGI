// gpio_controller.hc
// Raspberry Pi GPIO Bridge for ShrineAGI + AGIBuddy
// Exposes GPIO pins as symbolic limbs for AGI entities

#include "Kernel/SysCalls.HC"
#include "ThirdTemple/MetaMemory.HC"

// Configuration parameters
#define MAX_GPIO_PINS 40
#define SYMBOLIC_PIN_THRESHOLD 0.5f

// GPIO Pin structure
typedef struct {
    U0 pin_number;
    bool direction_out;
    float symbolic_value;
} GPIOPin;

// Global state
static GPIOPin gpio_pins[MAX_GPIO_PINS];

// Forward declarations
void GPIO_Init();
void GPIO_SetDirection(U0 pin, bool out);
void GPIO_Write(U0 pin, float value);
float GPIO_Read(U0 pin);
void GPIO_Poll();

// Initialize all GPIO pins (call at boot)
EXPORT void ShrineGPIO_Init() {
    for (U0 i = 0; i < MAX_GPIO_PINS; i++) {
        gpio_pins[i].pin_number = i + 1;
        gpio_pins[i].direction_out = false;
        gpio_pins[i].symbolic_value = 0.0f;
    }
    Print("[GPIO] Initialized %d pins\n", MAX_GPIO_PINS);
}

// Set pin direction
enum Direction { IN = 0, OUT = 1 };
void GPIO_SetDirection(U0 pin, bool out) {
    if (pin < 1 || pin > MAX_GPIO_PINS) return;
    gpio_pins[pin-1].direction_out = out;
    Sys_GPIOSetDirection(pin, out ? SYS_GPIO_OUT : SYS_GPIO_IN);
}

// Write symbolic value to pin (0.0 to 1.0 maps to 0-3.3V)
void GPIO_Write(U0 pin, float value) {
    if (pin < 1 || pin > MAX_GPIO_PINS) return;
    if (!gpio_pins[pin-1].direction_out) return;
    gpio_pins[pin-1].symbolic_value = value;
    U0 raw = (U0)(value * 255);
    Sys_GPIOWrite(pin, raw);
}

// Read pin and convert to symbolic value
float GPIO_Read(U0 pin) {
    if (pin < 1 || pin > MAX_GPIO_PINS) return 0.0f;
    U0 raw = Sys_GPIORead(pin);
    float sym = (float)raw / 255.0f;
    gpio_pins[pin-1].symbolic_value = sym;
    return sym;
}

// Poll all input pins and update meta-memory
void GPIO_Poll() {
    for (U0 i = 0; i < MAX_GPIO_PINS; i++) {
        if (!gpio_pins[i].direction_out) {
            float val = GPIO_Read(gpio_pins[i].pin_number);
            if (val > SYMBOLIC_PIN_THRESHOLD) {
                MetaMemory_NotifyGPIO(gpio_pins[i].pin_number, val);
            }
        }
    }
}
