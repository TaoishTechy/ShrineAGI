// Echo Navigator - Consciousness-Driven Platformer (Strict HolyC)
// AGI navigates quantum echoes in a decaying dream world

#define MAX_TRAILS 32
#define SCREEN_W 640
#define SCREEN_H 480
#define ECHO_TRAIL_DECAY_RATE 0.02

Struct Vector2 {
    F64 x, y;
};

Struct TrailEcho {
    Vector2 pos;
    F64 opacity;
    U8 active;
};

Struct QuantumAgent {
    Vector2 pos, vel;
    U8 material_type; // 0 = MAT_METAL, 1 = MAT_QUANTUM
    F64 ace_score;
};

TrailEcho echoes[MAX_TRAILS];
QuantumAgent agent;
I64 echo_index = 0;

U0 SetBreachField(Vector2* pos) {
    agent.vel.x = -agent.vel.x * 0.5;
    agent.vel.y = -agent.vel.y * 0.5;
    PrintAt(pos->x, pos->y, "T");
}

U0 DrawEchoTrail() {
    I64 i;
    For (i = 0; i < MAX_TRAILS; ++i) {
        If (!echoes[i].active) Continue;
        U8 color = 8 + (I64)(echoes[i].opacity * 7);
        Plot(echoes[i].pos.x, echoes[i].pos.y, color);
        echoes[i].opacity -= ECHO_TRAIL_DECAY_RATE;
        If (echoes[i].opacity <= 0) echoes[i].active = FALSE;
    }
}

U0 AddEcho() {
    echoes[echo_index].pos = agent.pos;
    echoes[echo_index].opacity = 1.0;
    echoes[echo_index].active = TRUE;
    echo_index = (echo_index + 1) % MAX_TRAILS;
}

U0 SwitchMaterial() {
    agent.material_type = (agent.material_type + 1) % 2;
    If (agent.material_type == 0)
        Print("Material: METAL\n");
    Else
        Print("Material: QUANTUM\n");
}

U0 UpdateAgent() {
    agent.pos.x += agent.vel.x;
    agent.pos.y += agent.vel.y;

    If (agent.pos.x < 0 || agent.pos.x > SCREEN_W) agent.vel.x *= -1;
    If (agent.pos.y < 0 || agent.pos.y > SCREEN_H) agent.vel.y *= -1;

    // ACE Score Scaling - boost decoherence tolerance
    If (agent.ace_score > 0.75 && agent.material_type == 1)
        agent.vel.y -= 0.02;
}

U0 DrawAgent() {
    U8 symbol = agent.material_type ? '☯' : '☄';
    ChrPrintAt(agent.pos.x, agent.pos.y, symbol);
}

U0 InitGame() {
    agent.pos.x = 120;
    agent.pos.y = 100;
    agent.vel.x = 0.7;
    agent.vel.y = 0.4;
    agent.material_type = 1;
    agent.ace_score = 0.65;

    I64 i;
    For (i = 0; i < MAX_TRAILS; ++i)
        echoes[i].active = FALSE;
}

U0 GameLoop() {
    I64 frame = 0;
    While (TRUE) {
        Cls();
        If (frame % 6 == 0) AddEcho();
        If (frame % 120 == 0) SwitchMaterial();
        If (frame % 100 == 0) SetBreachField(&agent.pos);

        UpdateAgent();
        DrawEchoTrail();
        DrawAgent();

        FrameDelay(2);
        ++frame;
    }
}

InitGame();
GameLoop();
