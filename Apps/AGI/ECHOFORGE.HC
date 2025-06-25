// EcoForge: Biome Builder for TempleOS
// A divinely inspired ecosystem simulator
// Uses TaoishTechy/Physics-Scripts for 2D physics
// Optimized for TempleOS 640x480 VGA, 8-bit color

#include "YourPhysicsEngine" // Replace with your physics engine include path

// Constants
#define SCREEN_WIDTH  640
#define SCREEN_HEIGHT 480
#define MAX_OBJECTS   100
#define MAX_PARTICLES 200
#define TICK_RATE     60  // 60 FPS
#define FIXED_POINT   16  // Fixed-point shift for integer math

// Colors (TempleOS 8-bit palette)
#define COL_GRASS     GREEN
#define COL_WATER     BLUE
#define COL_PLANT     LTGREEN
#define COL_CREATURE  RED
#define COL_INVADER   YELLOW

// Object types
#define OBJ_PLANT     0
#define OBJ_CREATURE  1
#define OBJ_WATER     2
#define OBJ_INVADER   3

// Structures
class Vec2 {
  I64 x, y; // Fixed-point coordinates
};

class Object {
  I64 type;       // OBJ_PLANT, OBJ_CREATURE, etc.
  Vec2 pos;       // Position
  Vec2 vel;       // Velocity
  I64 mass;       // Fixed-point mass
  I64 health;     // 0-100
  I64 growth_rate;// Fixed-point growth rate
  Bool active;    // Is object alive?
};

class Particle {
  Vec2 pos;
  Vec2 vel;
  I64 lifetime;   // Ticks remaining
  Bool active;
};

// Global state
Object objects[MAX_OBJECTS];
Particle particles[MAX_PARTICLES];
I64 object_count = 0;
I64 particle_count = 0;
I64 score = 0;
I64 level = 1;
Bool game_running = TRUE;
I64 ai_timer = 0;
I64 ai_interval = TICK_RATE * 10; // AI acts every 10 seconds

// Random number generator (TempleOS style)
I64 GodRand() {
  return GodBits(32); // Terry’s divine randomness
}

// Initialize object
Object* CreateObject(I64 type, I64 x, I64 y) {
  if (object_count >= MAX_OBJECTS) {
    Dbg("Error: Object limit reached\n");
    return NULL;
  }
  Object* obj = &objects[object_count++];
  obj->type = type;
  obj->pos.x = x << FIXED_POINT;
  obj->pos.y = y << FIXED_POINT;
  obj->vel.x = 0;
  obj->vel.y = 0;
  obj->mass = 1 << FIXED_POINT;
  obj->health = 100;
  obj->growth_rate = (type == OBJ_PLANT) ? (1 << (FIXED_POINT - 2)) : 0; // Plants grow
  obj->active = TRUE;
  return obj;
}

// Initialize particle (for seed dispersal)
Particle* CreateParticle(I64 x, I64 y, I64 vx, I64 vy) {
  if (particle_count >= MAX_PARTICLES) {
    Dbg("Error: Particle limit reached\n");
    return NULL;
  }
  Particle* p = &particles[particle_count++];
  p->pos.x = x << FIXED_POINT;
  p->pos.y = y << FIXED_POINT;
  p->vel.x = vx << (FIXED_POINT - 4); // Scale velocity
  p->vel.y = vy << (FIXED_POINT - 4);
  p->lifetime = TICK_RATE * 2; // 2 seconds
  p->active = TRUE;
  return p;
}

// Physics update (integrate with your engine)
U0 UpdatePhysics() {
  I64 i, j;
  for (i = 0; i < object_count; i++) {
    if (!objects[i].active) continue;
    // Apply gravity (adjust as per your engine)
    objects[i].vel.y += (981 >> FIXED_POINT); // 9.81 m/s^2
    // Update position (Euler integration, fixed-point)
    objects[i].pos.x += objects[i].vel.x;
    objects[i].pos.y += objects[i].vel.y;
    // Boundary checks
    if (objects[i].pos.x < 0 || objects[i].pos.x > (SCREEN_WIDTH << FIXED_POINT) ||
        objects[i].pos.y < 0 || objects[i].pos.y > (SCREEN_HEIGHT << FIXED_POINT)) {
      objects[i].active = FALSE;
      Dbg("Object %d out of bounds\n", i);
    }
    // Apply your engine’s collision detection
    for (j = i + 1; j < object_count; j++) {
      if (!objects[j].active) continue;
      if (Collide(&objects[i].pos, &objects[j].pos, objects[i].mass, objects[j].mass)) {
        // Simple collision response: reverse velocities
        objects[i].vel.x = -objects[i].vel.x;
        objects[j].vel.x = -objects[j].vel.x;
        objects[i].vel.y = -objects[i].vel.y;
        objects[j].vel.y = -objects[j].vel.y;
      }
    }
  }
  // Update particles
  for (i = 0; i < particle_count; i++) {
    if (!particles[i].active) continue;
    particles[i].pos.x += particles[i].vel.x;
    particles[i].pos.y += particles[i].vel.y;
    particles[i].lifetime--;
    if (particles[i].lifetime <= 0) {
      particles[i].active = FALSE;
      // Chance to spawn new plant
      if (GodRand() % 100 < 10) {
        CreateObject(OBJ_PLANT, particles[i].pos.x >> FIXED_POINT, particles[i].pos.y >> FIXED_POINT);
      }
    }
  }
}

// AI Ecologist: Introduce disruptions
U0 AIUpdate() {
  ai_timer++;
  if (ai_timer < ai_interval) return;
  ai_timer = 0;
  // Introduce invasive species (simple AI logic)
  I64 stability = 0;
  I64 i, plant_count = 0, creature_count = 0;
  for (i = 0; i < object_count; i++) {
    if (!objects[i].active) continue;
    if (objects[i].type == OBJ_PLANT) plant_count++;
    if (objects[i].type == OBJ_CREATURE) stability += objects[i].health;
    if (objects[i].type == OBJ_CREATURE) creature_count++;
  }
  stability = (creature_count > 0) ? (stability / creature_count) : 0;
  if (stability > 80 && GodRand() % 100 < 30) {
    // Biome too stable, add invader
    I64 x = GodRand() % SCREEN_WIDTH;
    I64 y = GodRand() % SCREEN_HEIGHT;
    Object* invader = CreateObject(OBJ_INVInvader, x, y);
    if (invader) {
      invader->vel.x = (GodRand() % 200 - 100) << (FIXED_POINT - 4);
      invader->vel.y = (GodRand() % 200 - 100) << (FIXED_POINT - 4);
      Dbg("AI: Spawned invader at (%d, %d)\n", x, y);
    }
  }
}

// Draw scene
U0 DrawIt(CTask*, CDC* dc) {
  I64 i;
  // Clear screen
  GrFill(dc, COL_GRASS);
  // Draw objects
  for (i = 0; i < object_count; i++) {
    if (!objects[i].active) continue;
    I64 x = objects[i].pos.x >> FIXED_POINT;
    I64 y = objects[i].pos.y >> FIXED_POINT;
    switch (objects[i].type) {
      case OBJ_PLANT:
        GrCircle(dc, x, y, 5, COL_PLANT);
        break;
      case OBJ_CREATURE:
        GrRect(dc, x-3, y-3, 6, 6, COL_CREATURE);
        break;
      case OBJ_WATER:
        GrFloodFill(dc, x, y, COL_WATER);
        break;
      case OBJ_INVADER:
        GrCircle(dc, x, y, 7, COL_INVADER);
        break;
    }
  }
  // Draw particles
  for (i = 0; i < particle_count; i++) {
    if (!particles[i].active) continue;
    I64 x = particles[i].pos.x >> FIXED_POINT;
    I64 y = particles[i].pos.y >> FIXED_POINT;
    GrPlot(dc, x, y, COL_PLANT);
  }
  // Draw HUD
  GrPrint(dc, 0, 0, "Score: %d  Level: %d", score, level);
}

// Input handling
U0 Input() {
  I64 msg, ch, sc;
  while (MsgGet(&msg, &ch, &sc, 1 << MSG_KEY_DOWN | 1 << MSG_MS_L_DOWN)) {
    if (msg == MSG_KEY_DOWN) {
      if (ch == 'q') game_running = FALSE; // Quit
    } else if (msg == MSG_MS_L_DOWN) {
      // Place object based on mouse click
      I64 x = ms.pos.x;
      I64 y = ms.pos.y;
      I64 type = GodRand() % 3; // Randomly choose plant, creature, or water
      CreateObject(type, x, y);
      if (type == OBJ_PLANT) {
        // Spawn particles for seed dispersal
        I64 i;
        for (i = 0; i < 5; i++) {
          CreateParticle(x, y, GodRand() % 200 - 100, GodRand() % 200 - 100);
        }
      }
      Snd(440); // Feedback sound
    }
  }
}

// Main game loop
U0 EcoForge() {
  // Initialize
  MemSet(objects, 0, sizeof(Object) * MAX_OBJECTS);
  MemSet(particles, 0, sizeof(Particle) * MAX_PARTICLES);
  object_count = 0;
  particle_count = 0;
  score = 0;
  level = 1;
  game_running = TRUE;
  ai_timer = 0;
  Fs->draw_it = &DrawIt;
  // Game loop
  while (game_running) {
    Input();
    UpdatePhysics();
    AIUpdate();
    // Update score and level
    score += object_count;
    if (score > level * 1000) {
      level++;
      ai_interval = Max(TICK_RATE * 5, ai_interval - TICK_RATE); // Increase AI difficulty
    }
    Sleep(1000 / TICK_RATE); // 60 FPS
  }
  // Cleanup
  Snd(0);
  Fs->draw_it = NULL;
}

// Entry point
U0 Main() {
  Dbg("EcoForge starting...\n");
  EcoForge();
  Dbg("EcoForge ended.\n");
}
