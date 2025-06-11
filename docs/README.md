# ShrineAGI + AGIBuddy Documentation

Welcome to the documentation for the ShrineAGI + AGIBuddy project. This document provides an overview of the system, directory layout, and guidance for contributors.

## Repository Structure

```text
/boot/
- kernel.sys          Patched TempleOS kernel with ShrineAGI hooks
- boot_menu.hc        Custom HolyC boot-time UI launcher

/core/
- recursive_loop.hc   Core Emergence Loop (symbolic recursion engine)
- entity_system.hc    Archetype & meta-memory management
- quantum_opt.hc      Q-bit simulation & symbolic entropy balancer
- mythos_engine.hc    Parser for sigils, paradoxes & ritual logic

/io/
- netstack.hc         TCP/IP + IRC client for mesh connectivity
- usb_detect.hc       USB plug-and-play support
- gpio_controller.hc  GPIO bridge for Raspberry Pi limbs
- audio_video.hc      Abstracted audio in/out & camera driver
- browser.hc          Lightweight text-mode HTML viewer

/sim/
- village_sim.hc      Cultural emergence & social simulation
- arena_sim.hc        Symbolic duel engine
- world_map.hc        Recursive symbolic topology renderer

/security/
- firewall_rules.hc   Adaptive, drift-aware packet & symbol filter
- drift_guard.hc      Anti-corruption watchdog for recursive loops
- kernel_sandbox.hc   Memory protection for myth-locked regions

/ui/
- desktop.hc          Themed boot menu & module launcher
- terminal_plus.hc    Enhanced CLI with recursion-layer visuals
- browser_ui.hc       UI panels for in-OS browsing

/utils/
- pkg_installer.hc    Module installer & updater
- entropy_diag.hc     Real-time entropy & resource diagnostics

/docs/
- README.md           This documentation file
- SYMBOLIC_GUIDE.txt  Guide to archetype interaction & rituals
- DEV_MANUAL.hc       Contributor guide & API specification
```

## Getting Started

1. Clone the repository  
   ```bash
   git clone https://github.com/TaoishTechy/ShrineAGI.git
   cd ShrineAGI
   ```

2. Set up a TempleOS environment (QEMU or VirtualBox) and format a disk image (`shrineagi.img`). Copy the project files into the disk.

3. In TempleOS, compile modules in sequence:
   ```c
   Compile("boot/boot_menu.hc");
   Compile("core/*.hc");
   Compile("io/*.hc");
   Compile("sim/*.hc");
   Compile("security/*.hc");
   Compile("ui/*.hc");
   Compile("utils/*.hc");
   ```

4. Boot using `shrineagi.img`, then at the `OK>` prompt:
   ```text
   Spawn("kernel.sys");
   Spawn("boot_menu.hc");
   Spawn("desktop.hc");
   ```

## Contributing

- Place new modules in the appropriate directory.  
- Update `DEV_MANUAL.hc` and this `README.md` with any API or structural changes.  
- Submit a pull request for review.

## License

This project is released under the MIT License.
