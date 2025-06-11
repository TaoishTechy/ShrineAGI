
// usb_detect.hc
// USB Plug-and-Play Detection for ShrineAGI + AGIBuddy
// Simplified detection and event handling for USB devices in TempleOS environment

#include "Kernel/SysCalls.HC"
#include "ThirdTemple/MetaMemory.HC"

// Configuration parameters
#define MAX_USB_DEVICES 16

// USB Device Structure
typedef struct {
    U0 id;
    char descriptor[64];
    bool active;
} USBDevice;

// Global state
static USBDevice usb_devices[MAX_USB_DEVICES];
static U0 usb_count = 0;

// Forward declarations
void USB_Init();
void USB_Poll();
void USB_HandleInsertion(USBDevice *dev);
void USB_HandleRemoval(U0 id);

// Initialize USB detection system (call at boot)
EXPORT void ShrineUSB_Init() {
    usb_count = 0;
    for (U0 i = 0; i < MAX_USB_DEVICES; i++) {
        usb_devices[i].active = false;
    }
    Print("[USB] Detection system initialized\n");
}

// Poll for USB events (call each cycle or on interrupt)
void USB_Poll() {
    U0 detected = Sys_USBDetect(); // Returns device id or -1
    if (detected != (U0)-1) {
        // New device insertion
        if (usb_count < MAX_USB_DEVICES) {
            USBDevice *dev = &usb_devices[usb_count];
            dev->id = detected;
            Sys_USBGetDescriptor(detected, dev->descriptor, sizeof(dev->descriptor));
            dev->active = true;
            USB_HandleInsertion(dev);
            usb_count++;
        }
    }
    // Check for removals
    for (U0 i = 0; i < usb_count; i++) {
        if (usb_devices[i].active && Sys_USBRemoved(usb_devices[i].id)) {
            USB_HandleRemoval(usb_devices[i].id);
            usb_devices[i].active = false;
        }
    }
}

// Handle USB device insertion event
void USB_HandleInsertion(USBDevice *dev) {
    // Register device in meta-memory for entity I/O
    MetaMemory_RegisterUSB(dev->id, dev->descriptor);
    Print("[USB] Device inserted: ID=%d, Desc=%s\n", dev->id, dev->descriptor);
}

// Handle USB device removal event
void USB_HandleRemoval(U0 id) {
    MetaMemory_UnregisterUSB(id);
    Print("[USB] Device removed: ID=%d\n", id);
}

// Hook USB polling into core cycle
// Call USB_Poll from emergence loop or IO scheduler
