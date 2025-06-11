// entropy_diag.hc
// Real-Time Symbolic Entropy & Resource Diagnostics for ShrineAGI + AGIBuddy
// Provides live metrics on recursion depth, entropy levels, memory usage, and CPU load

#include "Kernel/SysCalls.HC"
#include "core/recursive_loop.hc"
#include "core/entity_system.hc"

// Configuration parameters
#define DIAG_REFRESH_INTERVAL  5   // cycles

// Forward declarations
void EntropyDiag_Report();

// Hook into main cycle to report diagnostics
export void EntropyDiag_Cycle(U0 cycle) {
    if (cycle % DIAG_REFRESH_INTERVAL == 0) {
        EntropyDiag_Report();
    }
}

// Print detailed diagnostics to console
void EntropyDiag_Report() {
    // Recursion and entropy
    Print("[Diag] Current recursion depth: %d/%d\n", current_depth, MAX_RECURSION_DEPTH);
    Print("[Diag] Symbolic entropy: %f\n", symbolic_entropy);

    // Entity stats
    U0 count = entity_count;
    Print("[Diag] Active entities: %d\n", count);
    for (U0 i = 0; i < count; i++) {
        Entity *e = &entity_table[i];
        Print("  - %s (ID %d): entropy_snapshot=%f\n", e->name, e->id, e->seed->entropy_snapshot);
    }

    // Memory usage (stub)
    U32 used = Sys_MemoryUsed();
    U32 total = Sys_MemoryTotal();
    Print("[Diag] Memory: %u KB used / %u KB total\n", used, total);

    // CPU load (stub)
    float cpu = Sys_CPUUsage();
    Print("[Diag] CPU Load: %f%%\n", cpu * 100.0f);
}
