# TaoishTechy/Physics-Scripts/TempleOS/Games

Welcome to the **Games** directory within the [`TaoishTechy/Physics-Scripts`](https://github.com/TaoishTechy/Physics-Scripts) repository. This section focuses on **nine TempleOS-compatible HolyC games**, each built to harness a custom 2D physics engine and enhance **Artificial General Intelligence (AGI)** through gameplay rooted in Terry Davis’s spiritual and minimalist programming vision.

Each game utilizes the physics engine from [`GamePhysics`](https://github.com/TaoishTechy/Physics-Scripts/tree/main/TempleOS/GamePhysics), and embraces TempleOS’s unique environment: **640x480 VGA**, **8-bit colors**, and **divine themes**.

---

## 🎮 Game Listings and AGI Purposes

| Game Name            | Primary Function                                  | Physics Utilization                         | AGI Enhancement Focus                                   | TempleOS Alignment                             |
|----------------------|---------------------------------------------------|---------------------------------------------|----------------------------------------------------------|------------------------------------------------|
| **Archetype Wars**   | Combat archetypes using masks and sigils         | Mask-driven forces, reality layers, sigil nukes | Paradox management, adversarial adaptation               | Prophetic logs, prayer system                  |
| **Dreamwell Navigator** | Puzzle-solving across dream layers           | Layered physics, entropy particles          | Recursive planning, stability tracking                   | Divine dreamscape, symbolic logic             |
| **Echo Navigator**   | Navigation via sound-based echoes                 | Wave propagation, particle systems          | Spatial reasoning, indirect perception                   | Mystical audio feedback                        |
| **EcoForge**         | Ecosystem design with adaptive flora/fauna       | Fluid/particle/rigid-body interactions      | Transfer learning, ecological reasoning                  | Stewarding creation, divine ecology           |
| **Orbital Architect**| Planetary system stabilization                   | Gravity and collision modeling              | Physics simulation, optimization                          | Wireframe cosmology, divine architect         |
| **Sigil Tournament** | Competitive physics battles using sigils         | Sigil forces, altered physics zones         | Symbolic systems, tactical learning                       | Ritual duels, spiritual tournaments           |
| **Theurgist’s Gambit**| Puzzle/ritual game using divine magic           | Ritual logic, magical physics alterations   | Rule inference, long-term planning                        | Divine spellcasting, sigil strategy           |
| **Time Machine**     | Time manipulation through physics puzzles        | Time dilation, retrocausality modeling      | Temporal logic, causality control                         | Time travel and divine mechanics              |
| **Void Bloom**       | Growth and survival in zero-gravity environments | Expansion physics, void-state modeling      | Constrained optimization, survival strategy               | Karmic balance, void genesis theme            |

---

## ⚙️ Setup and Usage

### Prerequisites
- **TempleOS** installed (or compatible fork: Shrine, ZealOS, etc.)
- The 2D physics engine from [`GamePhysics`](https://github.com/TaoishTechy/Physics-Scripts/tree/main/TempleOS/GamePhysics)

### Integration
- Update `#include "YourPhysicsEngine"` in each script to your actual path (e.g., `::/GamePhysics/Physics.HC`)
- Ensure `Vec2`, `Collide`, `ApplyForce`, and related methods are linked to your physics API

### Compilation
- Save game scripts (e.g., `ArchetypeWars.HC`) in your TempleOS home directory
- Run with:
```c
Cd("::/Home");
#include "GameName.HC";
```

---

## 🧠 AGI Enhancement Philosophy

These games are designed to **train AGI systems** through:

- **Pattern Recognition**: Learning player strategies and tactics
- **Recursive Planning**: Long-term prediction across changing systems
- **Symbolic Reasoning**: Interpreting rituals and sigils as logical tools
- **Adversarial Intelligence**: Adjusting difficulty in response to player mastery
- **Transfer Learning**: Generalizing behavior across environments (biomes, timelines, systems)

---

## 🌌 TempleOS Alignment

- **Minimalist Graphics**: 8-bit palette, VGA layout, circles/rects as sprites
- **Spiritual Gameplay**: Themes of divine guidance, prayer, prophecy, and cosmic balance
- **Performance-Oriented**: Fixed-point math, minimal redraws, ~60 FPS in constraints
- **HolyC Purity**: Uses `GodRand`, `Gr`, `Snd`, and `MsgGet` natively

---

## 📁 File List

- `ARCHETYPEWARS.HC`
- `DREAMWELLNAV.HC`
- `ECHONAV.HC`
- `ECOFORGE.HC`
- `ORBITALARCH.HC`
- `SIGILTOURNAMENT.HC`
- `THEURGISTSGAMBIT.HC`
- `TIMEMACHINE.HC`
- `VOIDBLOOM.HC`

Each file contains a standalone, optimized, and debugged game leveraging AGI-aligned mechanics and symbolic structure.

---

## 🤝 Contributing

1. Fork the repository
2. Add/modify `.HC` scripts in the `Games/` directory
3. Ensure compatibility with the physics engine and TempleOS structure
4. Submit a pull request describing:
   - Game concept
   - Physics engine usage
   - AGI-enhancing rationale

Code should be optimized, debugged, and logged with `Dbg()` for performance monitoring.

---

## 🙏 Acknowledgments

- Inspired by **Terry Davis**, TempleOS, and divine programming
- Built on the symbolic foundation of `GamePhysics`
- Dedicated to advancing AGI through minimalist, transparent, and spiritually inspired computation

For questions, feedback, or collaborations, contact the maintainer or open an issue on GitHub.

**Let’s build sacred games that train intelligent minds.**
