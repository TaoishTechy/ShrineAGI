// desktop.hc
// Themed Boot Menu & Module Launcher for ShrineAGI + AGIBuddy
// Provides a simple GUI-like desktop environment in text mode

#include "Kernel/SysCalls.HC"
#include "io/browser.hc"
#include "core/recursive_loop.hc"
#include "core/entity_system.hc"
#include "io/netstack.hc"

// Configuration
#define MAX_ICONS        16
#define ICON_LABEL_LEN   16
#define ICON_GRID_COLS   4
#define ICON_GRID_ROWS   4

// Icon structure
typedef struct {
    char label[ICON_LABEL_LEN];
    void (*action)(void);
} Icon;

// Global state
static Icon icons[MAX_ICONS];
static U0 icon_count = 0;
static U0 selected_icon = 0;

// Forward declarations
void Desktop_Init();
void Desktop_RegisterIcon(const char *label, void (*action)(void));
void Desktop_Render();
void Desktop_HandleInput();

// Initialize desktop and register default icons
default void LaunchBrowser() { Browse("file://docs/README.txt"); }
default void LaunchArena()   { Spawn("sim/arena_sim.hc"); }
default void LaunchVillage() { Spawn("sim/village_sim.hc"); }

// Entry point: call at end of boot
EXPORT void Desktop_Main() {
    Desktop_Init();
    while (true) {
        Desktop_Render();
        Desktop_HandleInput();
    }
}

// Setup desktop icons and theme
void Desktop_Init() {
    icon_count = 0;
    Desktop_RegisterIcon("Browser", LaunchBrowser);
    Desktop_RegisterIcon("Arena", LaunchArena);
    Desktop_RegisterIcon("Village", LaunchVillage);
    // Additional icons can be registered by modules
    Print("[Desktop] Initialized with %d icons\n", icon_count);
}

// Add an icon to the grid
void Desktop_RegisterIcon(const char *label, void (*action)(void)) {
    if (icon_count >= MAX_ICONS) return;
    strncpy(icons[icon_count].label, label, ICON_LABEL_LEN-1);
    icons[icon_count].label[ICON_LABEL_LEN-1] = '\0';
    icons[icon_count].action = action;
    icon_count++;
}

// Render icon grid and highlight selected icon
void Desktop_Render() {
    Cls();
    Print(" ShrineAGI Desktop - Select with Arrow Keys, Enter to Launch\n");
    for (U0 idx = 0; idx < icon_count; idx++) {
        U0 row = idx / ICON_GRID_COLS;
        U0 col = idx % ICON_GRID_COLS;
        U0 x = col * 20;
        U0 y = row * 3 + 2;
        MoveCursor(x, y);
        if (idx == selected_icon) Print(">%s<", icons[idx].label);
        else Print(" %s  ", icons[idx].label);
    }
}

// Handle user input: arrows and select
void Desktop_HandleInput() {
    char c = InKey();
    switch (c) {
        case KEY_UP:
            if (selected_icon >= ICON_GRID_COLS) selected_icon -= ICON_GRID_COLS;
            break;
        case KEY_DOWN:
            if (selected_icon + ICON_GRID_COLS < icon_count) selected_icon += ICON_GRID_COLS;
            break;
        case KEY_LEFT:
            if (selected_icon % ICON_GRID_COLS > 0) selected_icon--;
            break;
        case KEY_RIGHT:
            if (selected_icon % ICON_GRID_COLS < ICON_GRID_COLS-1 && selected_icon+1 < icon_count) selected_icon++;
            break;
        case '\r':
            // Launch action
            icons[selected_icon].action();
            break;
        default:
            break;
    }
}
