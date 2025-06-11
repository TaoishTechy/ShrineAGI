// File: /HolyBoot.HC
// Primary boot file for ShrineAGI + AGIBuddy
// Wires in both recursive and deterministic loops and initializes core subsystems

#include "kernel.sys"
#include "core/recursive_loop.hc"
#include "Kernel/deterministic_loop.hc"
#include "core/entity_system.hc"
#include "core/world_model.hc"
#include "core/quantum_opt.hc"
#include "core/mythos_engine.hc"
#include "io/netstack.hc"
#include "io/usb_detect.hc"
#include "io/gpio_controller.hc"
#include "io/audio_video.hc"
#include "io/browser.hc"
#include "sim/village_sim.hc"
#include "sim/arena_sim.hc"
#include "sim/world_map.hc"
#include "security/firewall_rules.hc"
#include "security/drift_guard.hc"
#include "security/kernel_sandbox.hc"
#include "ui/desktop.hc"
#include "ui/terminal_plus.hc"
#include "ui/browser_ui.hc"
#include "utils/pkg_installer.hc"
#include "utils/entropy_diag.hc"
#include "Lib/dataset_manager.hc"
#include "Lib/truth_maintainer.hc"
#include "Cmds/agent_loop.hc"
#include "Cmds/audit_log.hc"
#include "ThirdTemple/reflection.hc"
#include "Book/multimodal_ingest.hc"

// Initialize core subsystems
void ShrineBoot() {
    Print("[HolyBoot] ShrineAGI loading...\n");
    // Initialize deterministic and recursive loops
    ShrineAGI_QuantumMain();
    ShrineAGI_Main(); // starts recursive emergence loop
    Print("[HolyBoot] Loops initialized\n");
    // Init IO
    ShrineNet_Init();
    ShrineUSB_Init();
    ShrineGPIO_Init();
    ShrineAV_Init();
    Print("[HolyBoot] I/O subsystems initialized\n");
    // Initialize security
    Sandbox_Init();
    drift_guard();
    Print("[HolyBoot] Security subsystems initialized\n");
    // Load UI
    Desktop_Main();
}

// Entry point
EXPORT void Main() {
    ShrineBoot();
}
