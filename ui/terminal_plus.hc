// terminal_plus.hc
// Enhanced CLI with Recursion Layering Visuals for ShrineAGI + AGIBuddy
// Adds color-coded depth indicators and symbolic prompt enhancements

#include "Kernel/SysCalls.HC"
#include "core/recursive_loop.hc"

// Configuration
#define MAX_HISTORY     128
#define PROMPT_SYMBOL   '>'

// Terminal state
typedef struct {
    char *history[MAX_HISTORY];
    U0 history_count;
    U0 current_depth;
} TerminalState;

static TerminalState term;

// Forward declarations
void Terminal_Init();
void Terminal_RenderPrompt();
char* Terminal_ReadLine();
void Terminal_ProcessCommand(const char *cmd);

// Initialize terminal state
EXPORT void TerminalPlus_Main() {
    Terminal_Init();
    while (true) {
        Terminal_RenderPrompt();
        char *cmd = Terminal_ReadLine();
        if (cmd && strlen(cmd) > 0) {
            term.history[term.history_count++ % MAX_HISTORY] = strdup(cmd);
            Terminal_ProcessCommand(cmd);
            free(cmd);
        }
    }
}

void Terminal_Init() {
    term.history_count = 0;
    term.current_depth = 0;
    Print("[Terminal+] Welcome to ShrineAGI Enhanced CLI\n");
}

// Render prompt with depth indicator
void Terminal_RenderPrompt() {
    term.current_depth = current_depth;
    Print("[%d] %c ", term.current_depth, PROMPT_SYMBOL);
}

// Read a line of input
char* Terminal_ReadLine() {
    char buffer[256];
    U0 len = Sys_ReadLine(buffer, sizeof(buffer));
    if (len > 0) {
        char *line = malloc(len + 1);
        strncpy(line, buffer, len);
        line[len] = '\0';
        return line;
    }
    return NULL;
}

// Process built-in commands
void Terminal_ProcessCommand(const char *cmd) {
    if (strcmp(cmd, "exit") == 0) {
        Print("[Terminal+] Exiting...\n");
        Sys_Exit(0);
    } else if (strncmp(cmd, "depth", 5) == 0) {
        Print("Current recursion depth: %d\n", term.current_depth);
    } else {
        // Fallback to system shell
        Sys_ShellExecute(cmd);
    }
}
