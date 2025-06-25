// Dreamwell Navigator for TempleOS
// A divinely inspired dreamscape simulator
// Uses TaoishTechy/Physics-Scripts for 2D physics
// Optimized for TempleOS 640x480 VGA, 8-bit color

#include "YourPhysicsEngine" // Replace with your physics engine include path

// Constants
#define SCREEN_WIDTH   640
#define SCREEN_HEIGHT  480
#define MAX_OBJECTS    50
#define MAX_PARTICLES  100
#define MAX_LAYERS     3
#define TICK_RATE      60  // 60 FPS
#define FIXED_POINT    16  // Fixed-point shift for integer math

// Colors (TempleOS 8-bit palette)
#define COL_NORMAL     BLUE
#define COL_ANTIGRAV   LTGREEN
#define COL_FROZEN     CYAN
#define COL_ENTROPY    RED
#define COL_PORTAL     YELLOW

// Object types
#define OBJ_DREAMER    0
#define OBJ_SYMBOL     1
#define OBJ_PORTAL     2

// Layer properties
#define LAYER_NORMAL   0
#define LAYER_ANTIGRAV 1
#define LAYER_FROZEN   2

// Structures
class Vec2 {
  I64 x, y; // Fixed-point coordinates
};

class Object {
  I64 type;       // OBJ_DREAMER, OBJ_SYMBOL, OBJ_PORTAL
  I64 layer;      // Current layer (0-2)
  Vec2 pos;       // Position
  Vec2 vel;       // Velocity
  I64 mass;       // Fixed-point mass
  Bool active;    // Is object active?
};

class Particle {
  Vec2 pos;
  Vec2 vel;
  I64 lifetime;   // Ticks remaining
  I64 layer;      // Layer for rendering
  Bool active;
};

class Layer {
  I64 gravity;    // Fixed-point gravity (positive, negative, or zero)
  I64 time_scale; // Fixed-point time multiplier (0 for frozen)
  I64 entropy;    // Entropy level (0-100)
};

// Global state
Object objects[MAX_OBJECTS];
Particle particles[MAX_PARTICLES];
Layer layers[MAX_LAYERS];
I64 object_count = 0;
I64 particle_count = 0;
I64 current_layer = 0;
I64 score = 0;
I64 level = 1;
I64 ace_score = 0; // Consciousness metric
Bool game_running = TRUE;
I64 ai_timer = 0;
I64 ai_interval = TICK_RATE * 15; // AI acts every 15 seconds

// Random number generator (TempleOS style)
I64 GodRand() {
  return GodBits(32); // Divine randomness
}

// Initialize layers
U0 InitLayers() {
  layers[LAYER_NORMAL].gravity = 981 >> FIXED_POINT;   // Normal gravity
  layers[LAYER_NORMAL].time_scale = 1 << FIXED_POINT;  // Normal time
  layers[LAYER_NORMAL].entropy = 0;
  
  layers[LAYER_ANTIGRAV].gravity = -981 >> FIXED_POINT; // Anti-gravity
  layers[LAYER_ANTIGRAV].time_scale = 1 << FIXED_POINT;
  layers[LAYER_ANTIGRAV].entropy = 0;
  
  layers[LAYER_FROZEN].gravity = 0;                   // No gravity
  layers[LAYER_FROZEN].time_scale = 0;                // Time frozen
  layers[LAYER_FROZEN].entropy = 0;
}

// Initialize object
Object* CreateObject(I64 type, I64 layer, I64 x, I64 y) {
  if (object_count >= MAX_OBJECTS) {
    Dbg("Error: Object limit reached\n");
    return NULL;
  }
  Object* obj = &objects[object_count++];
  obj->type = type;
  obj->layer = layer;
  obj->pos.x = x << FIXED_POINT;
  obj->pos.y = y << FIXED_POINT;
  obj->vel.x = 0;
  obj->vel.y = 0;
  obj->mass = 1 << FIXED_POINT;
  obj->active = TRUE;
  return obj;
}

// Initialize particle (for entropy visualization)
Particle* CreateParticle(I64 layer, I64 x, I64 y, I64 vx, I64 vy) {
  if (particle_count >= MAX_PARTICLES) {
    Dbg("Error: Particle limit reached\n");
    return NULL;
  }
  Particle* p = &particles[particle_count++];
  p->pos.x = x << FIXED_POINT;
  p->pos.y = y << FIXED_POINT;
  p->vel.x = vx << (FIXED_POINT - 4);
  p->vel.y = vy << (FIXED_POINT - 4);
  p->lifetime = TICK_RATE * 3; // 3 seconds
  p->layer = layer;
  p->active = TRUE;
  return p;
}

// Physics update
U0 UpdatePhysics() {
  I64 i, j;
  for (i = 0; i < object_count; i++) {
    if (!objects[i].active || objects[i].layer != current_layer) continue;
    if (layers[current_layer].time_scale == 0) continue; // Skip frozen layer
    // Apply layer-specific gravity
    objects[i].vel.y += layers[current_layer].gravity;
    // Update position (Euler integration, scaled by time)
    objects[i].pos.x += (objects[i].vel.x * layers[current_layer].time_scale) >> FIXED_POINT;
    objects[i].pos.y += (objects[i].vel.y * layers[current_layer].time_scale) >> FIXED_POINT;
    // Boundary checks
    if (objects[i].pos.x < 0 || objects[i].pos.x > (SCREEN_WIDTH << FIXED_POINT) ||
        objects[i].pos.y < 0 || objects[i].pos.y > (SCREEN_HEIGHT << FIXED_POINT)) {
      objects[i].active = FALSE;
      Dbg("Object %d out of bounds in layer %d\n", i, current_layer);
    }
    // Collision detection
    for (j = i + 1; j < object_count; j++) {
      if (!objects[j].active || objects[j].layer != current_layer) continue;
      if (Collide(&objects[i].pos, &objects[j].pos, objects[i].mass, objects[j].mass)) {
        // Simple collision response
        objects[i].vel.x = -objects[i].vel.x;
        objects[j].vel.x = -objects[j].vel.x;
        objects[i].vel.y = -objects[i].vel.y;
        objects[j].vel.y = -objects[j].vel.y;
        if (objects[i].type == OBJ_DREAMER && objects[j].type == OBJ_PORTAL) {
          score += 100;
          objects[j].active = FALSE; // Portal solved
          Snd(880); // Success sound
        }
      }
    }
  }
  // Update particles
  for (i = 0; i < particle_count; i++) {
    if (!particles[i].active || particles[i].layer != current_layer) continue;
    particles[i].pos.x += particles[i].vel.x;
    particles[i].pos.y += particles[i].vel.y;
    particles[i].lifetime--;
    if (particles[i].lifetime <= 0) {
      particles[i].active = FALSE;
    }
  }
}

// AI: Manage entropy and layer stability
U0 AIUpdate() {
  ai_timer++;
  if (ai_timer < ai_interval) return;
  ai_timer = 0;
  // Calculate entropy based on object density
  I64 i, object_density = 0;
  for (i = 0; i < object_count; i++) {
    if (!objects[i].active || objects[i].layer != current_layer) continue;
    object_density++;
  }
  layers[current_layer].entropy = Min(100, layers[current_layer].entropy + object_density / 5);
  if (layers[current_layer].entropy > 80 && GodRand() % 100 < 20) {
    // High entropy: Spawn chaos particles
    I64 x = GodRand() % SCREEN_WIDTH;
    I64 y = GodRand() % SCREEN_HEIGHT;
    for (i = 0; i < 10; i++) {
      CreateParticle(current_layer, x, y, GodRand() % 200 - 100, GodRand() % 200 - 100);
    }
    Dbg("AI: Entropy spike in layer %d\n", current_layer);
  }
  if (layers[current_layer].entropy >= 100) {
    // Layer collapse
    for (i = 0; i < object_count; i++) {
      if (objects[i].layer == current_layer && objects[i].type != OBJ_DREAMER) {
        objects[i].active = FALSE;
      }
    }
    layers[current_layer].entropy = 0;
    Snd(220); // Collapse sound
    Dbg("Layer %d collapsed\n", current_layer);
  }
  // Update ACE score (simplified consciousness metric)
  ace_score = Max(0, Min(100, ace_score + (score / 100 - layers[current_layer].entropy / 10)));
  if (ace_score > 80) {
    ai_interval = Max(TICK_RATE * 5, ai_interval - TICK_RATE); // Increase difficulty
  }
}

// Draw scene
U0 DrawIt(CTask*, CDC* dc) {
  I64 i;
  // Clear screen based on layer
  switch (current_layer) {
    case LAYER_NORMAL:   GrFill(dc, COL_NORMAL);   break;
    case LAYER_ANTIGRAV: GrFill(dc, COL_ANTIGRAV); break;
    case LAYER_FROZEN:   GrFill(dc, COL_FROZEN);   break;
  }
  // Draw objects
  for (i = 0; i < object_count; i++) {
    if (!objects[i].active || objects[i].layer != current_layer) continue;
    I64 x = objects[i].pos.x >> FIXED_POINT;
    I64 y = objects[i].pos.y >> FIXED_POINT;
    switch (objects[i].type) {
      case OBJ_DREAMER:
        GrCircle(dc, x, y, 7, WHITE);
        break;
      case OBJ_SYMBOL:
        GrRect(dc, x-4, y-4, 8, 8, LTRED);
        break;
      case OBJ_PORTAL:
        GrCircle(dc, x, y, 10, COL_PORTAL);
        break;
    }
  }
  // Draw entropy particles
  for (i = 0; i < particle_count; i++) {
    if (!particles[i].active || particles[i].layer != current_layer) continue;
    I64 x = particles[i].pos.x >> FIXED_POINT;
    I64 y = particles[i].pos.y >> FIXED_POINT;
    GrPlot(dc, x, y, COL_ENTROPY);
  }
  // Draw HUD
  GrPrint(dc, 0, 0, "Score: %d  Layer: %d  ACE: %d  Entropy: %d",
          score, current_layer, ace_score, layers[current_layer].entropy);
}

// Input handling
U0 Input() {
  I64 msg, ch, sc;
  while (MsgGet(&msg, &ch, &sc, 1 << MSG_KEY_DOWN | 1 << MSG_MS_L_DOWN)) {
    if (msg == MSG_KEY_DOWN) {
      if (ch == 'q') game_running = FALSE; // Quit
      if (ch == '1') current_layer = LAYER_NORMAL;
      if (ch == '2') current_layer = LAYER_ANTIGRAV;
      if (ch == '3') current_layer = LAYER_FROZEN;
      if (ch >= '1' && ch <= '3') Snd(440); // Layer switch sound
    } else if (msg == MSG_MS_L_DOWN) {
      // Place symbol or move dreamer
      I64 x = ms.pos.x;
      I64 y = ms.pos.y;
      I64 i;
      Bool dreamer_exists = FALSE;
      for (i = 0; i < object_count; i++) {
        if (objects[i].type == OBJ_DREAMER && objects[i].layer == current_layer) {
          dreamer_exists = TRUE;
          objects[i].pos.x = x << FIXED_POINT;
          objects[i].pos.y = y << FIXED_POINT;
          objects[i].vel.x = 0;
          objects[i].vel.y = 0;
          break;
        }
      }
      if (!dreamer_exists && GodRand() % 100 < 50) {
        CreateObject(OBJ_DREAMER, current_layer, x, y);
      } else {
        CreateObject(OBJ_SYMBOL, current_layer, x, y);
      }
      Snd(660); // Placement sound
    }
  }
}

// Main game loop
U0 DreamwellNavigator() {
  // Initialize
  MemSet(objects, 0, sizeof(Object) * MAX_OBJECTS);
  MemSet(particles, 0, sizeof(Particle) * MAX_PARTICLES);
  MemSet(layers, 0, sizeof(Layer) * MAX_LAYERS);
  object_count = 0;
  particle_count = 0;
  score = 0;
  level = 1;
  ace_score = 0;
  current_layer = LAYER_NORMAL;
  game_running = TRUE;
  ai_timer = 0;
  InitLayers();
  Fs->draw_it = &DrawIt;
  // Spawn initial portal
  CreateObject(OBJ_PORTAL, LAYER_NORMAL, SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
  // Game loop
  while (game_running) {
    Input();
    UpdatePhysics();
    AIUpdate();
    // Update level
    if (score > level * 1000) {
      level++;
      // Spawn new portal
      I64 layer = GodRand() % MAX_LAYERS;
      CreateObject(OBJ_PORTAL, layer, GodRand() % SCREEN_WIDTH, GodRand() % SCREEN_HEIGHT);
    }
    Sleep(1000 / TICK_RATE); // 60 FPS
  }
  // Cleanup
  Snd(0);
  Fs->draw_it = NULL;
}

// Entry point
U0 Main() {
  Dbg("Dreamwell Navigator starting...\n");
  DreamwellNavigator();
  Dbg("Dreamwell Navigator ended.\n");
}
