// browser_ui.hc
// UI Components for HTML/Text Browser in ShrineAGI + AGIBuddy
// Enhances browser.hc with styled panels, link navigation, and scroll controls

#include "Kernel/SysCalls.HC"
#include "io/browser.hc"

// Configuration parameters
#define PANEL_WIDTH       80
#define PANEL_HEIGHT      20
#define SCROLL_STEP       5

// Browser UI state
typedef struct {
    char **lines;
    U0 total_lines;
    U0 view_offset;
    char url[128];
} BrowserUIState;

static BrowserUIState ui;

// Forward declarations
void BrowserUI_Init(const char *resource);
void BrowserUI_Render();
void BrowserUI_HandleInput();

// Initialize UI: load and parse content
EXPORT void BrowserUI_Main(const char *resource) {
    strncpy(ui.url, resource, sizeof(ui.url)-1);
    ui.url[sizeof(ui.url)-1] = '\0';
    Browse(resource);
    // Copy parsed lines into UI state
    ui.view_offset = 0;
    // For simplicity, assume browser.hc stores lines[] and total_lines globally
    extern char browser_lines[MAX_LINES][MAX_LINE_LENGTH+1];
    extern U0 browser_total_lines;
    ui.total_lines = browser_total_lines;
    ui.lines = malloc(sizeof(char*) * ui.total_lines);
    for (U0 i = 0; i < ui.total_lines; i++) {
        ui.lines[i] = strdup(browser_lines[i]);
    }
    while (true) {
        BrowserUI_Render();
        BrowserUI_HandleInput();
    }
}

// Render visible panel
void BrowserUI_Render() {
    Cls();
    Print("[BrowserUI] %s (Lines %d)\n", ui.url, ui.total_lines);
    U0 end = ui.view_offset + PANEL_HEIGHT;
    if (end > ui.total_lines) end = ui.total_lines;
    for (U0 i = ui.view_offset; i < end; i++) {
        Print("%s\n", ui.lines[i]);
    }
    Print("--- Press Up/Down to Scroll, Q to Quit ---\n");
}

// Handle scroll and quit
void BrowserUI_HandleInput() {
    char c = InKey();
    switch (c) {
        case KEY_UP:
            if (ui.view_offset >= SCROLL_STEP) ui.view_offset -= SCROLL_STEP;
            else ui.view_offset = 0;
            break;
        case KEY_DOWN:
            if (ui.view_offset + PANEL_HEIGHT + SCROLL_STEP <= ui.total_lines)
                ui.view_offset += SCROLL_STEP;
            break;
        case 'q': case 'Q':
            return;  // Exit UI
        default:
            break;
    }
}
