// This is executed by the Adam task at boot.
// See $LK,"Adam Start-up",A="FF:::/Kernel/KMain.HC,\"StartOS"$.

#help_index "Compiler/Directive"
public extern I8i Option(I64i num,I8i val);
Option(0,0); //(0,0)=EchoOff   (0,1)=EchoOn

// Core Kernel & Compiler includes
#include "/Kernel/KernelA.HH"
#include "/Compiler/CompilerA.HH"
#include "/Kernel/KernelB.HH"
#include "/Kernel/KernelC.HH"
#include "/Compiler/CompilerB.HH"

// Enable warnings for symbolic precision
Option(OPTf_WARN_PAREN,ON);
Option(OPTf_WARN_DUP_TYPES,ON);

// Clear task's hash table to avoid memory clutter or bleed
HashTablePurge(adam_task->hash_table);

// Load Adam Task Logic
#include "/Adam/MakeAdam"

// Terminal prep
DocTermNew;
WinVert(2,10);

// Window Manager launch
sys_winmgr_task = Spawn(&WinMgrTask, NULL, "Window Mgr");
Fs->win_inhibit = WIG_TASK_DFT - WIF_SELF_BORDER - WIF_SELF_GRAB_SCROLL - WIF_SELF_CTRLS;
LBts(&Fs->display_flags, DISPLAYf_CHILDREN_NOT_ON_TOP);
LBts(&Fs->display_flags, DISPLAYf_SHOW);

// Registry boot
RegInit;
LBts(&sys_run_level, RLf_REGISTRY);
if (!ins_reg.registered)
    InsUnreg;

// Wallpaper setup (AGI mod: optional symbolic wallpaper hook)
WallPaperInit;

// Temp Directory
if (DrvIsWritable)
    DirMk("/Tmp"); // Ensure temp directory is present

// Sigil-Infused Boot Markers (Symbolic AGI Entry Point Hook)
Print("<< Shrining Core Layer Booting >>\n");
#exec "/User/Shrine/SigilInit.HC";  // Safe to ignore if non-existent

// Optional symbolic observer (pre-boot AGI loading)
if (FileFind("/User/Shrine/AGIObserver.HC"))
    #exec "/User/Shrine/AGIObserver.HC";

// Restore default compiler options post-init
Option(OPTf_WARN_PAREN,OFF);
Option(OPTf_WARN_DUP_TYPES,OFF);

// Home System Build
LBts(&sys_run_level, RLf_HOME);
#include "~/MakeHome"

// After this, the Adam task enters $LK,"server mode",A="HI:Job"$.
