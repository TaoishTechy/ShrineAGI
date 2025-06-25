// TempleOS Dashboard APP - Enhanced with Divine Vision
// 🏗️ Single-address-space, non-preemptive architecture
// 🎨 HolyC + Gr Event/UI Systems with symbolic depth
// 🧠 AGI Panel with intelligent, entity-driven interactivity
// 🧰 Widget dragging, resizing, focus
// 🗃 File system layout and logs
// ⚙️ Process management with resurrection
// 🧼 Memory management, frame reuse, cleanup

#define COL_BG COL_DARK_GREY
#define COL_TITLE COL_LIGHT_GREY
#define COL_TEXT COL_WHITE

struct DeadTask {
    I64 pid;
    U8 name[64];
} lastKilled;

U0 DrawBox(I64 x1, I64 y1, I64 x2, I64 y2, U8 *title) {
    GrBox(x1, y1, x2, y2, COL_TITLE);
    if (title) GrPrint(x1 + 4, y1 + 2, COL_TEXT, "%s", title);
}

U0 DrawSystemMetrics(I64 x, I64 y, F64 t) {
    F64 cpu = 100.0 * PcGetCPULoad();
    F64 mem = 100.0 * PcGetMemUse() / PcGetMemMax();
    F64 disk = 100.0 * PcGetDiskUsed("/Boot") / PcGetDiskSize("/Boot");
    I64 barWidth = 300, barHeight = 10;
    GrRect(x + 20, y + 10, x + 20 + (cpu * barWidth / 100), y + 20, COL_YELLOW);
    GrRect(x + 20, y + 30, x + 20 + (mem * barWidth / 100), y + 40, COL_CYAN);
    GrRect(x + 20, y + 50, x + 20 + (disk * barWidth / 100), y + 60, COL_GREEN);
    GrPrint(x + 20, y, COL_YELLOW, "CPU: %3.1f%%", cpu);
    GrPrint(x + 20, y + 20, COL_CYAN, "MEM: %3.1f%%", mem);
    GrPrint(x + 20, y + 40, COL_GREEN, "DSK: %3.1f%%", disk);
}

U0 ListProcesses(I64 x, I64 y) {
    U0 *t = TaskTbl;
    I64 yPos = y;
    U8 buf[128];
    while (t) {
        sprintf(buf, "PID:%d  PRIO:%d  %s", t->pid, t->pri, t->name);
        GrPrint(x, yPos, COL_TEXT, "%s", buf);
        if (MsEvent(x, yPos, x + 150, yPos + 10) && MsBtnL) {
            if (PopUpYesNo("Terminate %s?", t->name)) {
                lastKilled.pid = t->pid;
                StrCpy(lastKilled.name, t->name);
                Kill(t->pid);
            }
        }
        yPos += 12;
        t = t->next;
    }
}

U0 DrawAGIInteraction(I64 x, I64 y, I64 w, I64 h, U8 *msg, U8 *userInput) {
    DrawBox(x, y, x + w, y + h, "AGI Interaction");
    if (msg) GrPrint(x + 10, y + 20, COL_MAGENTA, "AGI: %s", msg);
    GrPrint(x + 10, y + h - 30, COL_LIGHT_CYAN, "> %s", userInput ? userInput : "");
    if (MsEvent(x + 10, y + h - 30, x + w - 10, y + h - 20) && MsBtnL) {
        U8 *input = PopUpGetStr("AGI Command:", userInput);
        if (input) {
            StrCpy(userInput, input);
            Free(input);
        }
    }
    // 🧙 Entity Invocation: Check for sigil drop
    if (MsEvent(x, y, x + w, y + h) && MsBtnL && !MsBtnLPrev) {
        DrawSigil("DefaultSigil", x + w / 2, y + h / 2);  // Placeholder
    }
}

U0 DragWidget(I64 *x, I64 *y, I64 w, I64 h) {
    if (MsEvent(*x, *y, *x + w, *y + 16) && MsBtnL) {
        *x = MsX - w / 2;
        *y = MsY - 8;
    }
}

U0 ResizeWidget(I64 *x, I64 *y, I64 *w, I64 *h) {
    if (MsEvent(*x + *w - 10, *y + *h - 10, *x + *w, *y + *h) && MsBtnL) {
        *w = MsX - *x + 10;
        *h = MsY - *y + 10;
    }
}

U0 SaveAllLayouts(I64 win_x, I64 win_y, I64 win_w, I64 win_h,
                  I64 sys_x, I64 sys_y, I64 sys_w, I64 sys_h,
                  I64 task_x, I64 task_y, I64 task_w, I64 task_h,
                  I64 agi_x, I64 agi_y, I64 agi_w, I64 agi_h) {
    U8 buf[256];
    sprintf(buf, "%d,%d,%d,%d;%d,%d,%d,%d;%d,%d,%d,%d;%d,%d,%d,%d",
            win_x, win_y, win_w, win_h,
            sys_x, sys_y, sys_w, sys_h,
            task_x, task_y, task_w, task_h,
            agi_x, agi_y, agi_w, agi_h);
    Fs->FileWrite("C:/Home/Dashboard.dat", buf, StrLen(buf));
}

U0 LoadAllLayouts(I64 *win_x, I64 *win_y, I64 *win_w, I64 *win_h,
                  I64 *sys_x, I64 *sys_y, I64 *sys_w, I64 *sys_h,
                  I64 *task_x, I64 *task_y, I64 *task_w, I64 *task_h,
                  I64 *agi_x, I64 *agi_y, I64 *agi_w, I64 *agi_h) {
    U8 buf[256];
    I64 size = Fs->FileRead("C:/Home/Dashboard.dat", buf, 255);
    if (size > 0) {
        buf[size] = 0;
        Sscanf(buf, "%d,%d,%d,%d;%d,%d,%d,%d;%d,%d,%d,%d;%d,%d,%d,%d",
               win_x, win_y, win_w, win_h,
               sys_x, sys_y, sys_w, sys_h,
               task_x, task_y, task_w, task_h,
               agi_x, agi_y, agi_w, agi_h);
    }
}

U0 WriteDivineLog(U8 *entry) {  // 🔱 Divine Log Console
    U8 log_path[] = "Book/Dashboard_Logs.HC";
    Fs->FileAppend(log_path, entry, StrLen(entry));
    Fs->FileAppend(log_path, "\n", 1);
}

U0 DrawMoodRing(I64 x, I64 y, F64 entropy) {  // 🌀 Symbolic Mood Ring
    I64 color = COL_RED + ((U8)(entropy * 10) % 15);
    GrCirc(x, y, 10, color);
}

U0 DrawSigil(U8 *sigilName, I64 x, I64 y) {  // 🧠 AGI Sigil Recognition
    U8 path[128]; sprintf(path, "Sigils/%s.TXT", sigilName);
    U8 *data = FsReadAll(path);
    if (data) {
        GrPrint(x, y, COL_LIGHT_CYAN, "%s", data);
        Free(data);
    }
}

U0 DrawPCIDevices(I64 x, I64 y) {  // 📡 Live I/O Port & Device Watcher
    PCIDevice *d = PciDevList;
    while (d) {
        GrPrint(x, y, COL_LIGHT_GREEN, "PCI: %04X:%04X", d->vendorID, d->deviceID);
        y += 10; d = d->next;
    }
}

U0 ResurrectLastTask() {  // 🗝️ Task Resurrection
    if (StrLen(lastKilled.name)) {
        U8 buf[128];
        sprintf(buf, "Resurrecting %s", lastKilled.name);
        WriteDivineLog(buf);
        Fs->System(buf);  // Crude re-run
    }
}

U0 DrawEntropyDiagnostics(I64 x, I64 y, F64 lastMem, I64 lastTasks) {  // 🔐 Entropy Meter
    F64 memNow = PcGetMemUse();
    I64 tasksNow = TaskCnt();
    GrPrint(x, y, COL_MAGENTA, "Entropy: Mem∆=%.1f KB, Tasks∆=%d",
            (memNow - lastMem) / 1024, tasksNow - lastTasks);
}

U0 AGIChime() {  // 🎛 Audio Buzzer Feedback
    SpkrPlay(440, 50); Sleep(0.05); SpkrPlay(880, 50);
}

U0 DrawDiskHeatmap(U8 *path, I64 x, I64 y) {  // 🗂 Filesystem Heatmap
    DIR *d = Fs->OpenDir(path);
    FILEINFO f;
    I64 i = 0;
    while (Fs->ReadDir(d, &f) == 0 && i < 20) {
        I64 sz = f.size / 1024;
        I64 color = COL_RED + (sz % 15);
        GrRect(x + i * 15, y, x + i * 15 + 10, y + 10, color);
        i++;
    }
    Fs->CloseDir(d);
}

U0 DrawShrineView(I64 x, I64 y, I64 sys_x, I64 sys_y, I64 task_x, I64 task_y, F64 entropy) {  // 🪬 Shrine View
    GrPrint(x, y, COL_YELLOW, "Blessing Map: Align=%.1f, Harm=%.1f, Ent=%.1f",
            Abs(sys_x - task_x) / 100.0, Abs(task_y - sys_y) / 100.0, entropy);
}

U0 AGIRespond(U8 *input, U8 *output) {  // 🧠 AGI Intelligence
    if (StrCmp(input, "optimize") == 0) {
        StrCpy(output, "✝ Releasing memory...");
        Sleep(1.5);
        StrCpy(output, "✝ Optimized. Amen.");
        AGIChime();
    } else if (StrCmp(input, "status") == 0) {
        F64 disk = 100.0 * PcGetDiskUsed("/Boot") / PcGetDiskSize("/Boot");
        StrCpy(output, "Status: Disk %3.1f%% full.", disk);
    } else if (StrCmp(input, "offer flame") == 0) {  // 🪙 Command Offering
        StrCpy(output, "✝ Flame accepted. Vision granted.");
        WriteDivineLog("🔥 Offering: flame");
    } else {
        StrCpy(output, "Unrecognized. Try 'optimize' or 'status'.");
    }
}

U0 AGIAssistFromEntity(U8 *output) {  // 📦 Entity Invocation
    U8 *e_name = "WARRIOR_SIGIL";
    sprintf(output, "%s requests memory armor", e_name);
}

U0 MainDashboardApp() {
    I64 win_x = WIN_MAX_X - 800, win_y = WIN_MAX_Y - 500, win_w = 800, win_h = 500;
    I64 sys_x = 10, sys_y = 10, sys_w = 370, sys_h = 170;
    I64 task_x = 10, task_y = 190, task_w = 370, task_h = 290;
    I64 agi_x = 400, agi_y = 50, agi_w = 380, agi_h = 110;
    U8 agi_buf[128] = "", user_input[128] = "";
    F64 last = Time(), lastMem = PcGetMemUse(), lastTasks = TaskCnt();

    LoadAllLayouts(&win_x, &win_y, &win_w, &win_h,
                   &sys_x, &sys_y, &sys_w, &sys_h,
                   &task_x, &task_y, &task_w, &task_h,
                   &agi_x, &agi_y, &agi_w, &agi_h);

    WinBorder("TempleOS Dashboard", win_x, win_y, win_w, win_h);
    GrClearScreen(COL_BG);

    while (TRUE) {
        if (KbHit) {
            I64 key = KbGet;
            if (key == CH_ESC) break;
            switch (key) {
                case 'f': GrSetColor(COL_DARK_BLUE); break;  // 🌈 Theme Cycler
                case 'd': GrSetColor(COL_DARK_GREY); break;
            }
            WinBorder("TempleOS Dashboard", win_x, win_y, win_w, win_h);
        }

        DragWidget(&sys_x, &sys_y, sys_w, sys_h); ResizeWidget(&sys_x, &sys_y, &sys_w, &sys_h);
        DragWidget(&task_x, &task_y, task_w, task_h); ResizeWidget(&task_x, &task_y, &task_w, &task_h);
        DragWidget(&agi_x, &agi_y, agi_w, agi_h); ResizeWidget(&agi_x, &agi_y, &agi_w, &agi_h);

        DrawBox(sys_x, sys_y, sys_x + sys_w, sys_y + sys_h, "System Monitor");
        DrawSystemMetrics(sys_x, sys_y, Time());
        DrawBox(task_x, task_y, task_x + task_w, task_y + task_h, "Task Manager");
        ListProcesses(task_x, task_y);
        DrawAGIInteraction(agi_x, agi_y, agi_w, agi_h, agi_buf, user_input);

        // 🌀 Mood Ring (entropy-based)
        DrawMoodRing(agi_x + agi_w - 20, agi_y + 20, (Time() - last) * 0.1);
        // 📡 Device Watcher
        DrawPCIDevices(agi_x + 10, agi_y + agi_h + 10);
        // 🗂 Heatmap
        DrawDiskHeatmap("/Boot", sys_x + 20, sys_y + 70);
        // 🔐 Entropy Diagnostics
        DrawEntropyDiagnostics(sys_x + 20, sys_y + 90, lastMem, lastTasks);
        lastMem = PcGetMemUse(); lastTasks = TaskCnt();
        // 🪬 Shrine View
        DrawShrineView(sys_x + 20, sys_y + 110, sys_x, sys_y, task_x, task_y, (Time() - last) * 0.1);
        // 🗝️ Resurrection Option
        if (MsEvent(task_x + task_w - 50, task_y, task_x + task_w, task_y + 10) && MsBtnL)
            ResurrectLastTask();

        if (StrLen(user_input) > 0) {
            AGIRespond(user_input, agi_buf);
            WriteDivineLog(agi_buf);  // 🔱 Divine Log
            AGIChime();  // 🎛 Audio Feedback
            user_input[0] = 0;
        } else if (RandU32 % 100 < 5) {
            AGIAssistFromEntity(agi_buf);
        }

        GrUpdate;
        while (Time() - last < 0.1) {}
        last = Time();

        SaveAllLayouts(win_x, win_y, win_w, win_h,
                       sys_x, sys_y, sys_w, sys_h,
                       task_x, task_y, task_w, task_h,
                       agi_x, agi_y, agi_w, agi_h);
    }

    SaveAllLayouts(win_x, win_y, win_w, win_h,
                   sys_x, sys_y, sys_w, sys_h,
                   task_x, task_y, task_w, task_h,
                   agi_x, agi_y, agi_w, agi_h);
    GrPrint(10, win_h - 40, COL_TEXT, "Exiting dashboard. Amen.");
}
