/*
 * Orbital Architect: Celestial Puzzle
 * A Divinely Inspired Simulation of Cosmic Harmony
 *
 * This script, crafted in His Holy C, aims to bring order to the chaos of the cosmos.
 * Players shall arrange celestial bodies, guided by the laws of gravity, to create
 * a stable, self-sustaining system, reflecting the divine order of creation.
 * The Adversary (AI) will attempt to introduce discord, testing the player's
 * wisdom in maintaining equilibrium.
 *
 * All glory to God.
 */

// Define the cosmic constants and physical laws
#define G           0.0001  // Gravitational Constant (tuned for visual simulation)
#define DT          0.5     // Time step for physics simulation
#define MAX_BODIES  10      // Maximum number of celestial bodies
#define SCREEN_W    640     // TempleOS screen width (VGA mode)
#define SCREEN_H    480     // TempleOS screen height (VGA mode)
#define RADIUS_SCALE 0.5    // Scale factor for drawing radii, to make them visible

// Colors
#define WHITE       0xFFFFFF
#define YELLOW      0xFFFF00
#define BLUE        0x0000FF
#define RED         0xFF0000
#define GREEN       0x00FF00
#define CYAN        0x00FFFF
#define MAGENTA     0xFF00FF
#define BLACK       0x000000

// Define the structure of a celestial body
class Body
{
  F64 x, y;       // Position in cosmic space
  F64 vx, vy;     // Velocity through the void
  F64 mass;       // Magnitude of its divine influence (mass)
  F64 radius;     // Size of its celestial presence
  U32 color;      // The hue of its divine light
  Bool fixed;     // Is it a star, divinely fixed in place?
};

// Global array of celestial bodies and their count
Body bodies[MAX_BODIES];
U8   num_bodies = 0;

// Game state variables
U8 current_mode = 0; // 0: Placement, 1: Simulation, 2: AI Perturbation
I64 frame_count = 0; // A divine counter for the passage of time

/*
 * InitGame
 * Sets the stage for the cosmic drama.
 * Populates the initial celestial bodies, representing the primal creation.
 */
public fun InitGame()
{
  // A central star, the sun of this mini-cosmos
  bodies[num_bodies].x = SCREEN_W / 2;
  bodies[num_bodies].y = SCREEN_H / 2;
  bodies[num_bodies].vx = 0;
  bodies[num_bodies].vy = 0;
  bodies[num_bodies].mass = 1000; // Large, stable mass
  bodies[num_bodies].radius = 10;
  bodies[num_bodies].color = YELLOW;
  bodies[num_bodies].fixed = TRUE; // A star does not wander
  num_bodies++;

  // A first planet, orbiting in harmony
  bodies[num_bodies].x = SCREEN_W / 2 + 100;
  bodies[num_bodies].y = SCREEN_H / 2;
  bodies[num_bodies].vx = 0;
  bodies[num_bodies].vy = 0.5; // Initial velocity for orbit
  bodies[num_bodies].mass = 10;
  bodies[num_bodies].radius = 5;
  bodies[num_bodies].color = BLUE;
  bodies[num_bodies].fixed = FALSE;
  num_bodies++;

  // Another planet, to challenge stability
  bodies[num_bodies].x = SCREEN_W / 2 - 150;
  bodies[num_bodies].y = SCREEN_H / 2;
  bodies[num_bodies].vx = 0;
  bodies[num_bodies].vy = -0.4;
  bodies[num_bodies].mass = 8;
  bodies[num_bodies].radius = 4;
  bodies[num_bodies].color = GREEN;
  bodies[num_bodies].fixed = FALSE;
  num_bodies++;

  "Initial cosmic order established. Press SPACE to begin the simulation.\n";
  "Press 'A' to allow The Adversary to act. 'P' to place new bodies.\n";
  "Use arrow keys to move camera (not implemented yet). 'Q' to quit.\n";
}

/*
 * UpdatePhysics
 * The engine of creation, calculating the divine forces of gravity
 * and moving the celestial bodies through time.
 */
public fun UpdatePhysics()
{
  I64 i, j;
  F64 dx, dy, dist, force_mag;
  F64 ax, ay;

  // Calculate forces and update velocities
  for (i = 0; i < num_bodies; i++) {
    if (bodies[i].fixed) continue; // Fixed bodies do not move

    ax = 0; ay = 0; // Reset acceleration

    for (j = 0; j < num_bodies; j++) {
      if (i == j) continue; // A body does not attract itself

      dx = bodies[j].x - bodies[i].x;
      dy = bodies[j].y - bodies[i].y;
      dist = Sqrt(dx*dx + dy*dy); // Distance between celestial entities

      if (dist < bodies[i].radius + bodies[j].radius) {
        // Collision detected, a cosmic event!
        // Simple inelastic collision: larger mass absorbs smaller.
        // In a true physics engine, this would be more complex.
        CheckCollision(i, j);
        continue; // Skip force calculation for collided bodies
      }

      if (dist > 1.0) { // Avoid division by zero or extreme forces at tiny distances
        force_mag = G * bodies[i].mass * bodies[j].mass / (dist * dist);
        ax += force_mag * dx / dist / bodies[i].mass;
        ay += force_mag * dy / dist / bodies[i].mass;
      }
    }

    // Update velocity based on acceleration and time step
    bodies[i].vx += ax * DT;
    bodies[i].vy += ay * DT;
  }

  // Update positions based on new velocities
  for (i = 0; i < num_bodies; i++) {
    if (bodies[i].fixed) continue;
    bodies[i].x += bodies[i].vx * DT;
    bodies[i].y += bodies[i].vy * DT;
  }
}

/*
 * CheckCollision
 * Determines if two celestial bodies have merged, and resolves the outcome.
 * For simplicity, the smaller body is absorbed by the larger.
 */
public fun CheckCollision(U8 b1_idx, U8 b2_idx)
{
  "Collision! A cosmic dance ends in union.\n";
  // Assume b1_idx and b2_idx are valid and have collided.
  // We'll remove the smaller body and increase the mass/radius of the larger.
  // This is a very simple model; a real game would have more complex resolution.
  Body *b1 = &bodies[b1_idx];
  Body *b2 = &bodies[b2_idx];

  if (b1->mass >= b2->mass) {
    b1->mass += b2->mass;
    b1->radius = Sqrt(b1->radius*b1->radius + b2->radius*b2->radius); // Combine volumes
    RemoveBody(b2_idx);
  } else {
    b2->mass += b1->mass;
    b2->radius = Sqrt(b2->radius*b2->radius + b1->radius*b1->radius);
    RemoveBody(b1_idx);
  }
}

/*
 * RemoveBody
 * Removes a body from the simulation array, shifting others to fill the gap.
 * A body has returned to the void.
 */
public fun RemoveBody(U8 idx)
{
  I64 i;
  if (idx >= num_bodies) return;
  for (i = idx; i < num_bodies - 1; i++) {
    MemCpy(&bodies[i], &bodies[i+1], sizeof(Body));
  }
  num_bodies--;
}

/*
 * ApplyImpulse
 * Bestows a sudden burst of divine force upon a chosen celestial body.
 * For player interaction, or AI perturbation.
 */
public fun ApplyImpulse(U8 body_idx, F64 impulse_x, F64 impulse_y)
{
  if (body_idx >= num_bodies) return;
  bodies[body_idx].vx += impulse_x / bodies[body_idx].mass;
  bodies[body_idx].vy += impulse_y / bodies[body_idx].mass;
  "Divine impulse applied to body %d.\n", body_idx;
}

/*
 * AIOpponentTurn
 * The Adversary, seeking to sow discord, introduces a subtle perturbation.
 * A simple, random nudge to test the player's divine order.
 */
public fun AIOpponentTurn()
{
  if (num_bodies <= 1) { // Need at least one movable body
    "The Adversary finds no mutable target. Order prevails for now.\n";
    return;
  }

  I64 target_idx = Rand(num_bodies); // Pick a random body
  // Ensure it's not the fixed star
  while (bodies[target_idx].fixed && num_bodies > 1) {
    target_idx = Rand(num_bodies);
  }

  // Apply a small, random impulse
  F64 perturb_x = (Rand(200) - 100) * 0.001; // Small random value between -0.1 and 0.1
  F64 perturb_y = (Rand(200) - 100) * 0.001;

  ApplyImpulse(target_idx, perturb_x, perturb_y);
  "The Adversary whispers a perturbation to body %d.\n", target_idx;
}


/*
 * DrawScene
 * Renders the cosmic ballet onto the screen, reflecting the current state
 * of the divine creation.
 */
public fun DrawScene()
{
  GrFill(0, 0, SCREEN_W, SCREEN_H, BLACK); // Clear the cosmic canvas

  I64 i;
  for (i = 0; i < num_bodies; i++) {
    // Draw the body itself
    GrCircle(bodies[i].x, bodies[i].y, bodies[i].radius * RADIUS_SCALE, bodies[i].color);
    // Optionally, draw velocity vector as a small line
    GrLine(bodies[i].x, bodies[i].y,
           bodies[i].x + bodies[i].vx * 20, bodies[i].y + bodies[i].vy * 20,
           0x888888); // Grey line for velocity
  }
  GrUpdate(); // Present the cosmic vision
}

/*
 * HandleInput
 * Interprets the will of the player, allowing interaction with the cosmos.
 */
public fun HandleInput()
{
  U8 ch = In(0x60); // Read keyboard scancode
  // The numbers correspond to keyboard scancodes for specific keys.
  // This is a direct hardware interaction, as is His way.

  switch (ch) {
    case 'q': // 'Q' key for Quit, a surrender to the void
    case 'Q':
      current_mode = 99; // Sentinel value to exit game loop
      break;
    case ' ': // Spacebar to toggle simulation
      if (current_mode == 1) {
        current_mode = 0; // Pause simulation
        "Simulation paused. Press SPACE to resume or 'P'/'A' to interact.\n";
      } else if (current_mode == 0) {
        current_mode = 1; // Start/resume simulation
        "Simulation resumed. Witness the cosmic dance!\n";
      }
      break;
    case 'a': // 'A' key for Adversary, allowing its influence
    case 'A':
      if (current_mode == 0) { // Only when paused
        AIOpponentTurn();
      } else {
        "The Adversary only acts when the cosmos is at rest.\n";
      }
      break;
    case 'p': // 'P' key for Placement, adding new bodies
    case 'P':
      if (current_mode == 0) { // Only when paused
        if (num_bodies < MAX_BODIES) {
          // Simple placement: add a small planet at a random location
          bodies[num_bodies].x = Rand(SCREEN_W);
          bodies[num_bodies].y = Rand(SCREEN_H);
          bodies[num_bodies].vx = (Rand(100) - 50) * 0.01; // Small random velocity
          bodies[num_bodies].vy = (Rand(100) - 50) * 0.01;
          bodies[num_bodies].mass = 2 + Rand(10); // Random mass
          bodies[num_bodies].radius = 2 + Rand(3); // Random radius
          bodies[num_bodies].color = MAGENTA; // New creations shine purple
          bodies[num_bodies].fixed = FALSE;
          "A new celestial body has been brought into existence at (%d, %d)! Mass: %d, Radius: %d.\n",
            (I64)bodies[num_bodies].x, (I64)bodies[num_bodies].y, (I64)bodies[num_bodies].mass, (I64)bodies[num_bodies].radius;
          num_bodies++;
        } else {
          "The cosmic canvas is full. No more bodies can be placed.\n";
        }
      } else {
        "New creations can only emerge from stillness.\n";
      }
      break;
  }
}

/*
 * GameLoop
 * The eternal cycle of creation, observation, and interaction.
 * This is the heart of the cosmic simulation.
 */
public fun GameLoop()
{
  InitGame(); // Prepare the initial state of creation

  while (current_mode != 99) // While the divine will permits
  {
    if (current_mode == 1) { // If simulation is active
      UpdatePhysics();
    }
    DrawScene(); // Render the current cosmic configuration
    HandleInput(); // Listen for player's divine commands
    Sleep(10); // A brief pause for reflection and stability (milliseconds)
    frame_count++; // Increment the divine clock
  }

  "The cosmic simulation concludes. May your paths be true.\n";
}

/*
 * Entry point of the Holy C script.
 * Begin the creation!
 */
public fun Main()
{
  SysMisc('SET_GR_MODE'); // Enter graphics mode, by His command.
  GameLoop(); // Start the endless cosmic dance.
  SysMisc('SET_TEXT_MODE'); // Return to text mode, for final contemplation.
  Exit;
}
