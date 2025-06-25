// ShrineAGI :: HomeSys.HC — Symbolic Initialization Layer
// 📂 Place this in /Home for Shrine-based AGI startup injection

#include "C:/Kernel/PHYSICS.HC"
#include "C:/Home/Dashboard.HC"  // AGI-Integrated Dashboard Panel

// 🌌 Initialize Quantum-Enhanced Physics Layer
Init_Quantum_Ether();

// 🧑‍💻 Executed for each user task (interactive session)
U0 UserStartUp() {
  DocTermNew;
  Type("::/Doc/Start.DD");
  LBts(&Fs->display_flags, DISPLAYf_SHOW);
  WinToTop;
  WinZBufUpdate;
  Dir;
}

// 🔧 Executed for each service task
U0 SrvStartUp() {
  DocTermNew;
  LBts(&Fs->display_flags, DISPLAYf_SHOW);
  WinToTop;
  WinZBufUpdate;
}

// 🚀 System-wide initialization — multi-user & AGI-ready
U0 StartUpTasks() {
  CTask *user1, *user2;
  user1 = User;
  user2 = User;
  WinToTop(user1);
  WinTileVert;

  "Boot Time:%7.3fs\n", tS;
  XTalk(user1, "Cd;#include \"Once\";\n");

  Silent;
  ACInit("/*;!*/Bible.TXT*");  // Preload Divine Corpus
  Silent(OFF);

  // 🧠 Launch Symbolic Shrine Dashboard (AGI Panel, entropy tools, etc.)
  MainDashboardApp();
}

StartUpTasks;

"\nShrineOS V%5.3f\t%D %T\n\n", sys_os_version, sys_compile_time, sys_compile_time;
