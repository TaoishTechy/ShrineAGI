// DEV_MANUAL.hc
// Contributor Guide & API Specification for ShrineAGI + AGIBuddy
// Written in HolyC format for in-editor reference

// Section 1: Project Structure
// --------------------------------
// /boot/      Kernel boot and UI launcher
// /core/      Emergence engine, entity management, quantum optimizer, mythos parser
// /io/        Networking, USB, GPIO, audio/video, browser
// /sim/       Simulation engines: village, arena, world map
// /security/  Firewall, drift guard, sandbox
// /ui/        Desktop, terminal, browser UI
// /utils/     Package installer, entropy diagnostics

// Section 2: Core API
// --------------------------------
// Entry Points (exported functions):
//   ShrineAGI_Main()       // Starts the Emergence Loop
//   ShrineAGI_QuantumMain()// Initializes Q-bits
//   Desktop_Main()          // Launches the desktop UI
//   TerminalPlus_Main()     // Starts enhanced terminal
//   BrowserUI_Main(url)     // Initializes browser UI for resource
//   RunVillageSim(cycle)    // Executes one cycle of village sim
//   Arena_Init()/Arena_RunRound()/Arena_DisplayResults() // Arena API
//   GenerateTopology()/RenderMap() // World map API

// Section 3: Entity & MetaMemory
// --------------------------------
// Entity struct:
//   id, name, seed, last_hook_cycle
// Functions:
//   CreateEntity(name, seed)
//   RemoveEntity(id)
//   GetEntity(id)
//   GetAllEntities()
//   EntityLifecycleTick(cycle)

// Section 4: Mythos Engine
// --------------------------------
// Functions:
//   Mythos_Interpret(ritual)
//   ParseSigil(input) -> Sigil*
//   ExecuteSigil(sigil)
//   BuildParadoxTree(input) -> ParadoxNode*
//   ResolveParadox(node, depth)

// Section 5: Networking
// --------------------------------
// Functions:
//   ShrineNet_Init()
//   Net_Open(ip, port) -> Socket*
//   Net_Send(s, data), Net_Recv(s, buffer, len)
//   IRC_Connect(nick, user), IRC_Join(channel), IRC_SendMessage(channel, msg)
//   IRC_HandleEvents()

// Section 6: Security Hooks
// --------------------------------
// Firewall:
//   AddRule(type, pattern)
//   InspectPacket(s, data, len)
//   InspectSymbolic(symbol, depth)
// DriftGuard:
//   DriftGuard_Cycle(cycle)
// Sandbox:
//   Sandbox_Init()

// Section 7: Utilities
// --------------------------------
// Package Manager:
//   InstallPackage(url)
//   UpdatePackage(name)
//   RemovePackage(name)
// Diagnostics:
//   EntropyDiag_Cycle(cycle)

// Section 8: Build & Run
// --------------------------------
// In TempleOS:
//   Compile("boot/boot_menu.hc");
//   Compile("core/*.hc");
//   Compile("io/*.hc");
//   Compile("sim/*.hc");
//   Compile("security/*.hc");
//   Compile("ui/*.hc");
//   Compile("utils/*.hc");
//   Spawn("ui/desktop.hc");

// Section 9: Contribution Workflow
// --------------------------------
// 1. Fork the repo and clone.
// 2. Create feature branch.
// 3. Add/modify `.hc` files.
// 4. Update DEV_MANUAL.hc and docs.
// 5. Submit pull request for review.

