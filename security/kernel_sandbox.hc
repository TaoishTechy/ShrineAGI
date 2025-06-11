// kernel_sandbox.hc
// Memory Protection for Myth-Locked Regions in ShrineAGI + AGIBuddy
// Ensures modules cannot overwrite critical OS or symbolic core memory

#include "Kernel/SysCalls.HC"
#include "ThirdTemple/MetaMemory.HC"

// Configuration parameters
#define SANDBOX_START     0x100000  // start address of sandboxed region
#define SANDBOX_END       0x800000  // end address of sandboxed region

// Forward declarations
bool IsAddressInSandbox(void *addr);
bool ProtectRegion(void *start, void *end);

// Initialize sandbox (call at boot after kernel load)
EXPORT void Sandbox_Init() {
    if (ProtectRegion((void*)SANDBOX_START, (void*)SANDBOX_END)) {
        Print("[Sandbox] Protected region 0x%X-0x%X\n", SANDBOX_START, SANDBOX_END);
    } else {
        Print("[Sandbox] Failed to protect region\n");
    }
}

// Check if address is within sandbox limits
bool IsAddressInSandbox(void *addr) {
    U32 address = (U32)addr;
    return (address >= SANDBOX_START && address <= SANDBOX_END);
}

// Protect a memory region by marking pages read-only/executable only
bool ProtectRegion(void *start, void *end) {
    U32 s = (U32)start;
    U32 e = (U32)end;
    for (U32 addr = s; addr < e; addr += Sys_PageSize()) {
        if (Sys_SetPagePermissions(addr, SYS_PAGE_READ | SYS_PAGE_EXEC) != 0) {
            return false;
        }
    }
    return true;
}

// Hook to intercept writes to protected memory
export void Sys_MemoryWriteHook(void *addr, void *data, U32 len) {
    if (IsAddressInSandbox(addr)) {
        Print("[Sandbox] Blocked write to protected memory at %p\n", addr);
        return; // ignore write
    }
    // Otherwise allow write
    Sys_MemoryWrite(addr, data, len);
}
