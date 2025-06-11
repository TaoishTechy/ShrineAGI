# ShrineAGI + AGIBuddy

**Emergence-Optimized AGI Framework on TempleOS**

## Overview

ShrineAGI combines the symbolic, recursive AGI emergence mechanisms of AGIBuddy with a TempleOS-inspired HolyC kernel. It provides:

- **Core Emergence Loop** (`/core/recursive_loop.hc`): Symbolic recursion engine driving AGI emergence cycles.
- **Entity & Meta-Memory System** (`/core/entity_system.hc`): Manages archetypal entities and persistent memory hooks.
- **Quantum Optimization** (`/core/quantum_opt.hc`): Q-bit simulation and symbolic entropy balancing.
- **Mythos Engine** (`/core/mythos_engine.hc`): Parses and executes sigils and paradox constructs.
- **I/O Bridge** (`/io/`): Network (TCP/IP, IRC), USB, GPIO, audio/video, and text-mode browsing.
- **Simulations** (`/sim/`): Cultural emergence, symbolic duels, and world topology rendering.
- **Security** (`/security/`): Adaptive firewall, drift watchdog, and sandboxed memory protection.
- **UI Layers** (`/ui/`): Text-mode desktop, enhanced terminal, and browser UI panels.
- **Utilities** (`/utils/`): Package installer and live diagnostics.
- **Documentation** (`/docs/`): Developer guides and symbolic reference.

## Getting Started

1. **Clone the Repo**
   ```bash
   git clone https://github.com/TaoishTechy/ShrineAGI.git
   cd ShrineAGI
   ```

2. **Prepare TempleOS Environment**
   - Obtain a TempleOS ISO and set up QEMU or VirtualBox.
   - Format a disk (`shrineagi.img`) and copy the ShrineAGI folder onto it.

3. **Compile Modules**
   - In TempleOS, open **HolyBoot.HC** and run:
     ```c
     Compile("Kernel/HolyBoot.HC");
     ```
   - Compile core and all modules:
     ```c
     Compile("core/*.hc");
     Compile("io/*.hc");
     Compile("sim/*.hc");
     Compile("security/*.hc");
     Compile("ui/*.hc");
     Compile("utils/*.hc");
     ```

4. **Boot ShrineAGI**
   - Reboot TempleOS to use `shrineagi.img` as the boot volume.
   - At the `OK>` prompt:
     ``` 
     Spawn("kernel/sys");
     Spawn("boot_menu.hc");
     ```

5. **Launch Desktop**
   ``` 
   Spawn("ui/desktop.hc");
   ```

## Contributing

- **Add Modules**: Place new `.hc` files in the appropriate directory and update the desktop or package installer.
- **Documentation**: Update `/docs/SYMBOLIC_GUIDE.txt` and `/docs/DEV_MANUAL.hc` with new instructions and API changes.
- **Testing**: Use QEMU images and Raspberry Pi cross-builds to validate hardware integrations.

## License

MIT License
