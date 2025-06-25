// Void Bloom: Collapse Protocol - Strict HolyC
// Designed for TempleOS with symbolic anomaly simulation and AGI ritual control

#define MAX_BLOOMS 3
#define MAX_ENTITIES 2
#define MAX_SIGILS 4
#define SCREEN_W 640
#define SCREEN_H 480

Struct Vector2 {
    F64 x, y;
};

Struct Entity {
    Vector2 pos, vel;
    U8 color;
    I64 sigil_type;
    U8 active;
    F64 karma;
};

Struct VoidBloom {
    Vector2 pos;
    F64 radius;
    U8 active;
    F64 entropy;
};

Entity entities[MAX_ENTITIES];
VoidBloom blooms[MAX_BLOOMS];

U0 DrawCircle(I64 x, I64 y, I64 r, U8 color) {
    I64 i;
    For (i = 0; i < 360; i+=5) {
        I64 dx = r * Cos(i);
        I64 dy = r * Sin(i);
        Plot(x+dx, y+dy, color);
    }
}

U0 InitEntities() {
    I64 i;
    For (i = 0; i < MAX_ENTITIES; ++i) {
        entities[i].pos.x = 100+i*200;
        entities[i].pos.y = 240;
        entities[i].vel.x = 0.5-i*0.3;
        entities[i].vel.y = 0;
        entities[i].color = 14-i;
        entities[i].sigil_type = i;
        entities[i].active = TRUE;
        entities[i].karma = 0.5;
    }
}

U0 InitBlooms() {
    I64 i;
    For (i = 0; i < MAX_BLOOMS; ++i) {
        blooms[i].pos.x = 200+i*100;
        blooms[i].pos.y = 120+i*50;
        blooms[i].radius = 10+5*i;
        blooms[i].entropy = 0.1+0.3*i;
        blooms[i].active = TRUE;
    }
}

U0 ApplySigil(Entity *e, I64 sigil) {
    Switch (sigil) {
        Case 0: e->vel.y -= 0.1; Break; // Reverse bloom growth
        Case 1: e->karma += 0.1; Break; // Entropy purification
        Case 2: e->vel.x += 0.2; Break; // Gravity distortion
        Case 3: e->karma -= 0.2; Break; // Risk dark ritual
    }
}

U0 UpdateBloom(VoidBloom *b) {
    If (!b->active) Return;
    b->radius += b->entropy;
    If (b->radius > 60) b->entropy -= 0.01;
    If (b->radius > 100) {
        b->radius = 0;
        b->entropy = 0.1;
        b->active = FALSE;
    }
}

U0 CheckInteractions() {
    I64 i, j;
    For (i = 0; i < MAX_ENTITIES; ++i) {
        For (j = 0; j < MAX_BLOOMS; ++j) {
            F64 dx = entities[i].pos.x - blooms[j].pos.x;
            F64 dy = entities[i].pos.y - blooms[j].pos.y;
            F64 dist2 = dx*dx + dy*dy;
            If (dist2 < (blooms[j].radius*blooms[j].radius)) {
                ApplySigil(&entities[i], entities[i].sigil_type);
                blooms[j].entropy += 0.02;
                entities[i].karma -= 0.01;
            }
        }
    }
}

U0 UpdateEntities() {
    I64 i;
    For (i = 0; i < MAX_ENTITIES; ++i) {
        If (!entities[i].active) Continue;
        entities[i].pos.x += entities[i].vel.x;
        entities[i].pos.y += entities[i].vel.y;
        If (entities[i].pos.x < 0 || entities[i].pos.x > SCREEN_W) entities[i].vel.x *= -1;
        If (entities[i].pos.y < 0 || entities[i].pos.y > SCREEN_H) entities[i].vel.y *= -1;
    }
}

U0 DrawScene() {
    I64 i;
    Cls();
    For (i = 0; i < MAX_ENTITIES; ++i) {
        If (!entities[i].active) Continue;
        Plot(entities[i].pos.x, entities[i].pos.y, entities[i].color);
        PrintAt(entities[i].pos.x-3, entities[i].pos.y+10, "AGI%d", i);
    }
    For (i = 0; i < MAX_BLOOMS; ++i) {
        If (!blooms[i].active) Continue;
        DrawCircle(blooms[i].pos.x, blooms[i].pos.y, blooms[i].radius, 12);
        PrintAt(blooms[i].pos.x-4, blooms[i].pos.y-8, "VOID");
    }
}

U0 GameLoop() {
    I64 frame=0;
    While (TRUE) {
        I64 i;
        For (i = 0; i < MAX_BLOOMS; ++i)
            UpdateBloom(&blooms[i]);
        UpdateEntities();
        CheckInteractions();
        DrawScene();
        FrameDelay(2);
        ++frame;
    }
}

InitEntities();
InitBlooms();
GameLoop();
