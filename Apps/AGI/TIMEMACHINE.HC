#include "DSP.H"
#include "MATH.H"

#define MAX_OBJ 50
#define GRAVITY 0.5
#define MAX_DISTURBANCE 3
#define PORTAL_SIZE 30

// Object types
enum {
    OBJ_BALL,
    OBJ_DOMINO,
    OBJ_LEVER,
    OBJ_SPRING,
    OBJ_PORTAL
};

// Physics states
enum {
    STATE_IDLE,
    STATE_ACTIVE,
    STATE_COMPLETE
};

// AI disturbances
enum {
    WIND_GUST,
    GRAVITY_SHIFT,
    TIME_VORTEX
};

struct Object {
    I64 type;
    F64 x, y;
    F64 vx, vy;
    F64 mass;
    F64 elasticity;
    F64 friction;
    F64 width, height;
    I64 state;
    I64 chain_next;
    I64 triggered;
};

struct Game {
    struct Object objects[MAX_OBJ];
    I64 obj_count;
    I64 level_state;
    F64 wind;
    F64 gravity_mod;
    I64 disturbance_type;
    I64 disturbance_timer;
    I64 edit_mode;
    I64 current_tool;
    I64 current_level;
};

F64 RandomRange(F64 min, F64 max) {
    return min + (F64)(RandU16() % (U16)((max - min) * 1000)) / 1000.0;
}

Void InitLevel(struct Game *g) {
    g->obj_count = 0;
    g->level_state = STATE_IDLE;
    g->wind = 0;
    g->gravity_mod = GRAVITY;
    g->disturbance_timer = 0;

    // Create time portal (always last object)
    struct Object *portal = &g->objects[g->obj_count++];
    portal->type = OBJ_PORTAL;
    portal->x = 600;
    portal->y = 400;
    portal->width = PORTAL_SIZE;
    portal->height = PORTAL_SIZE;
    portal->state = STATE_IDLE;

    // Level-specific setups
    switch(g->current_level) {
        case 0: // Ancient Egypt
            AddDominoChain(g, 100, 400, 5, 80);
            AddBall(g, 50, 100, 0.8, 0.7, 0.1);
            break;
        case 1: // Zero-G Space
            g->gravity_mod = 0.1;
            AddFloatingObjects(g);
            break;
    }
}

Void AddBall(struct Game *g, F64 x, F64 y, F64 mass, F64 elast, F64 frict) {
    if(g->obj_count >= MAX_OBJ) return;
    
    struct Object *ball = &g->objects[g->obj_count++];
    ball->type = OBJ_BALL;
    ball->x = x;
    ball->y = y;
    ball->vx = 0;
    ball->vy = 0;
    ball->mass = mass;
    ball->elasticity = elast;
    ball->friction = frict;
    ball->width = 10; // Radius
}

Void AddDominoChain(struct Game *g, F64 start_x, F64 y, I64 count, F64 spacing) {
    for(I64 i = 0; i < count; i++) {
        if(g->obj_count >= MAX_OBJ) return;
        
        struct Object *dom = &g->objects[g->obj_count];
        dom->type = OBJ_DOMINO;
        dom->x = start_x + i * spacing;
        dom->y = y;
        dom->width = 8;
        dom->height = 30;
        dom->mass = 1.0;
        dom->elasticity = 0.2;
        dom->friction = 0.4;
        dom->chain_next = (i == count-1) ? -1 : g->obj_count+1;
        dom->triggered = FALSE;
        g->obj_count++;
    }
}

Void ApplyPhysics(struct Game *g) {
    for(I64 i = 0; i < g->obj_count; i++) {
        struct Object *o = &g->objects[i];
        if(o->state != STATE_ACTIVE) continue;

        // Apply forces
        o->vx += g->wind / o->mass;
        o->vy += g->gravity_mod;
        
        // Apply velocity
        o->x += o->vx;
        o->y += o->vy;
        
        // Ground collision
        if(o->y > 470) {
            o->y = 470;
            o->vy = -o->vy * o->elasticity;
            o->vx *= (1.0 - o->friction);
        }
    }
}

Void CheckCollisions(struct Game *g) {
    for(I64 i = 0; i < g->obj_count; i++) {
        struct Object *a = &g->objects[i];
        
        for(I64 j = i+1; j < g->obj_count; j++) {
            struct Object *b = &g->objects[j];
            
            // Ball-Domino collision
            if(a->type == OBJ_BALL && b->type == OBJ_DOMINO) {
                F64 dx = b->x - a->x;
                F64 dy = b->y - a->y;
                F64 dist = Sqrt(dx*dx + dy*dy);
                
                if(dist < a->width + b->width/2) {
                    b->state = STATE_ACTIVE;
                    b->triggered = TRUE;
                    
                    // Transfer momentum
                    F64 transfer = 0.7;
                    b->vx = a->vx * transfer;
                    a->vx *= (1 - transfer);
                }
            }
            
            // Domino chain reaction
            if(a->type == OBJ_DOMINO && b->type == OBJ_DOMINO) {
                if(a->triggered && !b->triggered && 
                   Abs(a->x - b->x) < 50 && Abs(a->y - b->y) < 50) {
                    b->state = STATE_ACTIVE;
                    b->triggered = TRUE;
                }
            }
            
            // Portal activation
            if(b->type == OBJ_PORTAL && a->triggered) {
                F64 dx = b->x - a->x;
                F64 dy = b->y - a->y;
                if(dx*dx + dy*dy < PORTAL_SIZE*PORTAL_SIZE) {
                    g->level_state = STATE_COMPLETE;
                }
            }
        }
    }
}

Void ApplyDisturbance(struct Game *g) {
    if(g->disturbance_timer > 0) {
        g->disturbance_timer--;
        return;
    }

    // 10% chance per second (60fps)
    if(RandU16() % 600 == 0) {
        g->disturbance_type = RandU16() % MAX_DISTURBANCE;
        g->disturbance_timer = 180; // 3 seconds
        
        switch(g->disturbance_type) {
            case WIND_GUST:
                g->wind = RandomRange(-5, 5);
                break;
            case GRAVITY_SHIFT:
                g->gravity_mod = RandomRange(0.1, 1.5);
                break;
            case TIME_VORTEX:
                // Randomly reposition objects
                for(I64 i = 0; i < g->obj_count; i++) {
                    if(g->objects[i].type != OBJ_PORTAL) {
                        g->objects[i].x += RandomRange(-50, 50);
                        g->objects[i].y += RandomRange(-50, 50);
                    }
                }
                break;
        }
    } else {
        g->wind *= 0.98; // Natural wind decay
    }
}

Void DrawObject(struct Object *o) {
    switch(o->type) {
        case OBJ_BALL:
            GrCircle(o->x, o->y, (I64)o->width, 0xFFFF00);
            break;
        case OBJ_DOMINO:
            GrRect((I64)(o->x - o->width/2), (I64)(o->y - o->height), 
                   (I64)o->width, (I64)o->height, o->triggered ? 0xFF0000 : 0xFFFFFF);
            break;
        case OBJ_PORTAL:
            GrCircle(o->x, o->y, PORTAL_SIZE, 0x00FF00);
            GrPrint("TIME PORTAL", o->x - 30, o->y - 10);
            break;
    }
}

Void GameMain() {
    struct Game g;
    g.current_level = 0;
    g.edit_mode = TRUE;
    g.current_tool = OBJ_BALL;
    
    InitLevel(&g);
    
    F64 last_time = 0;
    while(TRUE) {
        // Timing (60fps)
        F64 now = TimeF64();
        if(now - last_time < 1/60.0) continue;
        last_time = now;
        
        // Input
        if(KeyHit) {
            switch(ScanChar) {
                case ' ': // Toggle run/pause
                    if(g.level_state == STATE_COMPLETE) {
                        g.current_level++;
                        InitLevel(&g);
                    } else {
                        g.level_state = g.level_state == STATE_IDLE ? STATE_ACTIVE : STATE_IDLE;
                    }
                    break;
                case 'e': // Toggle edit mode
                    g.edit_mode = !g.edit_mode;
                    break;
                case '1': case '2': case '3': // Select tool
                    g.current_tool = ScanChar - '1';
                    break;
            }
            KeyHit = 0;
        }
        
        // Editor mode
        if(g.edit_mode) {
            if(MouseClick) {
                switch(g.current_tool) {
                    case 0: AddBall(&g, MouseX, MouseY, 0.8, 0.7, 0.1); break;
                    case 1: AddDominoChain(&g, MouseX, MouseY, 1, 0); break;
                }
                MouseClick = 0;
            }
        }
        
        // Physics simulation
        if(g.level_state == STATE_ACTIVE) {
            ApplyPhysics(&g);
            CheckCollisions(&g);
            ApplyDisturbance(&g);
        }
        
        // Rendering
        GrClear(0x222222);
        
        // Draw instructions
        GrPrint("RUBE GOLDBERG TIME MACHINE", 10, 10);
        GrPrint("SPACE: Run/Pause  E: Toggle Edit 1-3: Tools", 10, 30);
        
        // Draw objects
        for(I64 i = 0; i < g.obj_count; i++) {
            DrawObject(&g.objects[i]);
        }
        
        // Draw UI
        if(g.level_state == STATE_COMPLETE) {
            GrPrint("TIME TRAVEL ACHIEVED! PRESS SPACE", 200, 200);
        }
        
        if(g.disturbance_timer > 0) {
            GrPrint("TIME DISTURBANCE DETECTED!", 10, 450);
        }
        
        // Flip buffers
        GFX.Flip();
    }
}

// Entry point
GameMain();
