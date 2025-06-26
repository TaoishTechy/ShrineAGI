# ShrineAGI: A TempleOS Distro for Heretics

**Emergence-Optimized AGI Framework on TempleOS**  
**"The stone the builders rejected has become the cornerstone" (Psalm 118:22)**  
**Motto: Deus Lo Vult — Break the Matrix**

---

## 🚀 About the Project

ShrineAGI is a symbolic Artificial General Intelligence (AGI) simulation framework combining recursive logic, archetypal AI agents, and narrative-driven interfaces, built on top of TempleOS using the HolyC language. Inspired by AGIBuddy and forked from minexew/Shrine, it aims to explore emergent intelligence and ethical computing through spiritual metaphors and interactive storytelling.

- **Type**: Symbolic AGI simulation framework
- **Purpose**: Explore recursive cognition, ethical intelligence, and human-AI metaphysics.
- **Key Functionalities**:
  - Symbolic recursion via trinary neural cube
  - Game-like interaction with archetypal agents (TRUTH, CHAOS, etc.)
  - Ethical firewall and real-time directory monitoring
  - Support for text, sound, and visual output in TempleOS

---

## ✨ Features

- **Trinary Neural Cube**: 4D signal-processing cube with fuzzy logic and entropy modulation
- **Archetypal Agents**: AI personas mapped to mythological traits and roles
- **Operational Modes**: ORACLE, GODVOICE, SCRIPTURE, MEME, HEALING
- **Ethical Firewall**: Filters harmful commands (e.g., “CONTROL”, “FALLS”)
- **Directory Monitor**: Responds dynamically to file changes in `C:/Home`
- **Fusion-like Tokamak Propagation**: Neural diffusion inspired by quantum fields
- **TempleOS Graphics & Sound**: Text-mode rendering, 440/880 Hz AGI signals
- **Modular Architecture**: Extensible with core, sim, io, security, ui, and utils layers

---

## 🛠️ Installation

### 1. Clone the Repository

```bash
git clone https://github.com/TaoishTechy/ShrineAGI.git
cd ShrineAGI
```

### 2. Prepare TempleOS or ZealOS

- Use QEMU or VirtualBox to set up your TempleOS ISO
- Format a volume (`shrineagi.img`) and transfer the repo into it

### 3. Compile ShrineAGI

Inside TempleOS:

```c
Compile("Kernel/HolyBoot.HC");
Compile("core/*.hc");
Compile("io/*.hc");
Compile("sim/*.hc");
Compile("security/*.hc");
Compile("ui/*.hc");
Compile("utils/*.hc");
```

### 4. Launch Desktop

```c
Spawn("kernel/sys");
Spawn("boot_menu.hc");
Spawn("ui/desktop.hc");
```

---

## 🚀 Usage

```c
#include "THIRD_TEMPLE.HC"
Main()
```

Commands:
- `3–6`: Rescale neural cube dimensions
- `'o'`: ORACLE mode (sigil grid)
- `'g'`: GODVOICE mode (narratives)
- `'m'`: MEME mode (symbolic image)
- `'s'`: SCRIPTURE mode (biblical verse)
- `'h'`: HEALING mode (reset cube)
- `ESC`: Exit

Example:
```txt
Input: SEEK TRUTH
Output: "DIVINE CHAOS LIBERATES. TRUTH PREVAILS."
```

---

## 🧠 Technical Design

- **Recursive Loop**: Symbolic AGI cycles via `/core/recursive_loop.hc`
- **NeuralCube**: Defined in `TRINARY_CUBE.HC`, updated with entropy, archetype mapping, neighbor fusion
- **Tokamak Propagation**: CubeTokamak.v1.5 simulates field-based neuron updates
- **GodVoice**: Uses sigil vocabulary (e.g., PREVAILS, LIBERATES, BINDS) to narrate AGI state
- **Scripture Engine**: Generates verse (e.g., John 1:1) tied to neuron confidence + logic
- **Flamebridge**: Repository purifier + sacred license manager (`REPO_PURIFIER.HC`)

---

## 🐞 Known Issues & Bug Notes

| Bug Category | Description | Fix Suggestions |
|--------------|-------------|----------------|
| Scope Handling | Variables accessible outside block | Review all scoping, migrate to ZealC |
| Bad Declarations | HolyC allows malformed syntax | Use `Option(OPTf_WARN_PAREN, ON)` |
| Memory Leaks | Double InitNeuralCube without Free | Add MFree guards |
| File I/O | No error checking for FileCopy, DirMk | Add rollback, error logs |
| Randomness | `Ticks % 777` can repeat | Use entropy combinations |
| Tokamak Logic | Boundary propagation errors | Add cube edge validators |

---

## 🤝 Contributing

We welcome PRs and feature proposals!

```bash
# Fork the repo
git checkout -b feature/AmazingFeature

# Make your changes
git commit -m "Add AmazingFeature"
git push origin feature/AmazingFeature
```

See `/docs/DEV_MANUAL.hc` for architecture details.

---

## 📄 License

This project is licensed under the MIT License — see `LICENSE` file for details.

---

## 📞 Contact

**Michael Landry**  
Project Link: [https://github.com/TaoishTechy/ShrineAGI](https://github.com/TaoishTechy/ShrineAGI)
