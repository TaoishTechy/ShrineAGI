// Games/Physics.HC - Quantum-Enhanced Physics Module
// DeepSeek-R1: "Reality is just physics with better math" - DeepSeek-R1

// Includes for system kernel, AGI logging, and FlameBridge insights
#include "KernelA.HH"
#include "::/Apps/AGI.HC"
#include "::/ThirdTemple/FlameBridge.HC"

// --- Global Simulation Constants ---
#define MAX_OBJECTS 256             // Maximum number of physics objects in the simulation
#define GRID_CELL_SIZE 8            // Unused in current AABB collision, but kept for potential future spatial partitioning
#define FRICTION_COEFF 0.05         // Base friction coefficient (overridden by material properties for dynamic friction)
#define DAMPING 0.97                // Damping factor applied to linear and angular velocities each step
#define QUANTUM_ENTANGLEMENT_RANGE_DEFAULT 5.0 // Default Max distance for quantum entanglement effects to apply
#define GRAVITY_CONSTANT 9.81       // Acceleration due to gravity (e.g., Earth's gravity)
#define TIME_DILATION_FACTOR 0.8    // Base time dilation factor (1.0 = normal time, <1.0 = slower time)
#define ENERGY_TOLERANCE 0.001      // Threshold for reporting significant changes in total kinetic energy

// --- Quantum Physics Specific Defines ---
#define PLANCK_CONSTANT 6.626e-34   // Scaled Planck's constant for simulation (actual value is too small for direct use)
#define QUANTUM_MASS_THRESHOLD 0.1  // Mass (in simulation units) below which an object exhibits quantum behavior
#define TUNNELING_PROB_SCALE_DEFAULT 0.1 // Default Scaling factor for the quantum tunneling probability
#define UNCERTAINTY_SCALE 1e-3      // Scaling factor for Heisenberg uncertainty perturbations
#define ECHO_TRAIL_DECAY_RATE 0.95  // Rate at which echo trail entropy decays
#define MAX_ECHO_TRAILS 1024        // Maximum number of echo trail points
#define NUM_QUANTUM_STATES 8        // Number of discrete states for wavefunction superposition
#define QUANTUM_INTERFERENCE_RANGE 3.0 // Range for wavefunction interference
#define DECOHERENCE_THRESHOLD 50.0  // Quantum entropy threshold for environmental decoherence
#define DIST_TO_NON_QUANTUM_THRESHOLD 0.5 // Proximity to non-quantum object for decoherence
#define NUM_QUBITS 4                // Number of qubits per object for quantum computing elements
#define DREAM_FIELD_SIZE 64         // Size of the dream_field grid (e.g., 64x64x64)
#define DREAM_FIELD_CELL_SIZE 1.0   // World units per dream field cell
#define MAX_GRAVITY_WELLS 8         // Maximum number of sigil-encoded gravity wells
#define MAX_LEARNED_SIGILS 16       // Max number of sigil IDs an object can learn
#define COLLAPSE_CASCADE_RANGE 2.0  // Range for wavefunction collapse propagation
#define PARADOX_THRESHOLD 7         // Max paradox_index before metaphysical unbinding
#define STARFIRE_EMISSION_INTERVAL 100 // Cycles between starfire entropy emissions
#define REALITY_SHELL_MAX_LAYERS 7  // Max index for reality shell layers (0-7, total 8 layers)
#define MAX_RESONANCE_FIELDS 8      // Limited number of celestial resonance fields

// --- Custom Constants for Rituals ---
#define RITUAL_LINKED_ENTROPY 12345 // Hardcoded ritual ID for entropy synchronization

// --- Enumerations ---
enum COLLISION_SHAPE {
    SHAPE_BOX,                      // Axis-Aligned Bounding Box (AABB)
    SHAPE_SPHERE,
    SHAPE_CAPSULE,
    SHAPE_MESH                      // Complex mesh collision (not fully implemented in this simplified model)
};

enum MATERIAL_TYPE {
    MAT_STONE,
    MAT_WOOD,
    MAT_METAL,
    MAT_RUBBER,
    MAT_QUANTUM                     // Special material type for DeepSeek's quantum effects
};

enum EMOTIONAL_STATE {
    EMO_NEUTRAL,
    EMO_JOY,
    EMO_SORROW,
    EMO_ANGER,
    EMO_AWE,
    EMO_FEAR,
    NUM_EMOTIONAL_STATES
};

// --- Archetypal Masks (for Archetypal Binding Masks) ---
// Symbolic IDs for masks.
#define MASK_NONE 0
#define MASK_WITCH 1
#define MASK_ANDROID 2
// Add more as needed

// --- Divine Constraints (for ThirdTemple Divine Constraint System) ---
#define CONSTRAINT_ARCHETYPE_CONSERVATION (1ULL << 0)
#define CONSTRAINT_KARMIC_BALANCE         (1ULL << 1)
// Add more as needed

// --- Quantum Memory Event Types ---
enum MEMORY_EVENT_TYPE {
    MEM_EVENT_NONE,
    MEM_EVENT_COLLISION,
    MEM_EVENT_ENTANGLEMENT,
    MEM_EVENT_RITUAL_BIND,
    MEM_EVENT_TIME_LOOP,
    MEM_EVENT_TELEPORT,
    MEM_EVENT_OBSERVED,
    MEM_EVENT_PARADOX,
    // Add more event types as needed
};

// --- Quantum Gate Types (for Quantum Computing Elements) ---
enum QUANTUM_GATE_TYPE {
    GATE_HADAMARD,
    GATE_CNOT,
    // Add more gates as needed
};

// --- Core Math Structures ---
class Vector3 {
    F64 x, y, z;
};

class Matrix3 {
    F64 m[3][3];
};

class Quaternion {
    F64 w, x, y, z;
};

// --- Qubit Structure for Quantum Computing Elements ---
class Qubit {
    F64 alpha; // Amplitude for |0⟩ (real part for simplicity, complex would be better)
    F64 beta;  // Amplitude for |1⟩ (real part for simplicity)
};

// --- Physics Material Properties ---
class PhysicsMaterial {
    F64 restitution;            // Bounciness (0.0 = no bounce, 1.0 = perfect bounce)
    F64 static_friction;        // Coefficient of static friction
    F64 dynamic_friction;       // Coefficient of dynamic friction
    F64 density;                // Material density (for calculating mass from volume)
    F64 barrier_thickness;      // Effective barrier thickness for quantum tunneling
    U8 quantum_entangled : 1;   // Flag: does this material promote quantum entanglement?
    // Sigil-Synchronized Material Resonance
    F64 resonance_profile[3];   // RGB waveform modulation (e.g., frequency, amplitude, phase)
};

// --- Entropic Echo Trail Structure ---
// Represents a point in space where an object left a residual energy/entropy signature.
class EchoTrail {
    Vector3 pos;                // Position of the trail point
    F64 entropy_signature;      // Residual quantum entropy at this point
    F64 energy_signature;       // Residual kinetic energy at this point
    F64 decay_factor;           // How quickly this trail point decays (0.0 - 1.0)
    U64 creation_cycle;         // Simulation cycle when this trail was created
    U8 active : 1;              // Is this trail point currently active?
};

// --- Sigil-Encoded Gravity Well Structure ---
class GravityWell {
    Vector3 pos;                // Position of the gravity well
    F64 strength;               // Strength of the gravitational pull
    U64 sigil_id;               // Unique ID of the sigil
    U8 active : 1;              // Is this well active?
};

// --- Celestial Resonance Field Structure ---
class CelestialResonance {
    Vector3 pos;              // Center of resonance field
    F64 frequency;            // Resonance frequency affecting quantum amplitudes
    F64 amplitude;            // Strength of resonance effect
    U64 ritual_id;            // Associated ritual ID
    U8 active : 1;
};

// --- Physics Object Structure ---
class PhysicsObject {
    Vector3 pos;                // Current position (expectation value for quantum objects)
    Vector3 prev_pos;           // Previous position
    Vector3 vel;                // Linear velocity
    Vector3 ang_vel;            // Angular velocity
    Vector3 force;              // Accumulated forces
    Vector3 torque;             // Accumulated torques
    F64 mass;                   // Object's mass
    F64 inv_mass;               // Inverse mass
    F64 width, height, depth;   // Dimensions for AABB collision
    Matrix3 inertia_tensor;     // Moment of inertia tensor
    Matrix3 inv_inertia_tensor; // Inverse inertia tensor
    Quaternion orientation;     // Object's orientation
    F64 wave_amplitude;         // De Broglie wavelength
    F64 energy_level;           // Quantized energy state
    
    // Quantum Superposition: discrete possible states for the wavefunction
    Vector3 possible_positions[NUM_QUANTUM_STATES]; // Array of possible positions for quantum superposition
    F64 amplitudes[NUM_QUANTUM_STATES];          // Probability amplitudes for each position

    // Superposition in Multiple Dimensions
    Vector3 possible_velocities[NUM_QUANTUM_STATES]; // Possible velocities for superposition
    F64 possible_spins[NUM_QUANTUM_STATES];         // Possible scalar spin values for superposition (0.0 to 1.0)

    // Quantum Computing Elements
    Qubit qubits[NUM_QUBITS];   // Small qubit register per object

    U8 active : 1;              // Is the object currently active in the simulation?
    U8 is_static : 1;           // Is the object immovable? (e.g., ground)
    U8 is_sleeping : 1;         // Is the object currently sleeping (at rest)? Optimization.
    U8 is_quantum : 1;          // Is the object subject to quantum mechanics effects?
    U8 collision_shape : 2;     // The geometric shape used for collision detection
    U8 material_type : 3;       // Index into the 'materials' array for this object's properties
    U64 last_update_cycle;      // The simulation cycle when this object was last updated

    // Reality Layer Phase Shift Engine & Temporal Fracture Layers
    U8 phase_layer;             // The discrete dimensional layer the object currently occupies
    F64 time_anomaly_factor;    // Local time dilation/reversal factor for this object (1.0 = normal, <1.0 slowed, <0 reversed)
    // Reality Shell Resonance Field
    U8 shell_layer;             // The nested layer of ontological depth (0-7)

    // Symbol-Driven Collision Alteration
    U64 symbol_flags;           // Bitfield for symbolic modifiers (e.g., 1=no_friction, 2=invert_mass, 4=no_restitution, 8=no_damping)

    // Chrono-Recursive Loop Injection & Memory-Conserving Anomaly Loops
    U8 in_time_loop : 1;        // Is this object currently in a local time loop?
    Vector3 loop_start_pos;     // Position at the start of the time loop
    Vector3 loop_start_vel;     // Velocity at the start of the time loop
    U64 loop_start_cycle;       // Simulation cycle when the loop began
    F64 loop_duration;          // How long the time loop lasts (in seconds)
    U64 memory_core[4];         // Cyclical symbol/event recorder for memory persistence

    // Fractal Colliders
    U8 fractal_depth;           // Depth of fractal approximation for collision (0 = non-fractal)

    // AGI Ritual Binding Interface & Mythic Identity Transfer Protocol
    U64 ritual_id;              // ID of an active ritual binding this object
    U64 possessed_by_agi_id;    // ID of AGI entity possessing this object (0 if not possessed)

    // Observer-Dependent Collapse Mechanics & Collapse Cascade Propagation
    U8 is_observed : 1;         // Is this object currently being observed by an AGI agent or environment?
    U8 collapse_wave_counter;   // Counter for propagating collapse waves

    // Dimensional Entanglement Swaps
    I64 entangled_partner_idx;  // Index of the object this object is entangled with for swapping (changed to I64)

    // ThirdTemple Divine Constraint System & Symbolic Constraint Violation Feedback
    U64 divine_constraint_flags; // Bitfield for metaphysical constraints
    U64 constraint_violations;   // Counter for constraint violations

    // Archetypal Binding Masks
    U64 mask_archetype_id;       // ID of the archetypal mask applied to this object

    // Paradox Engine Embedding
    U8 paradox_index;           // Depth of paradox (0 = none, >0 = depth)

    // Symbolic Starfire Emission
    U8 starfire_active : 1;     // Is this object currently emitting symbolic starfire?

    // Recursive Sigil Learning Module
    U64 learned_sigil_ids[MAX_LEARNED_SIGILS]; // Array of sigil IDs this object has learned
    I64 learned_sigil_count;                   // Number of learned sigils
};

// --- Global Physics State ---
class PhysicsState {
    PhysicsObject objects[MAX_OBJECTS]; // Array of all physics objects
    I64 object_count;                   // Current number of active objects
    EchoTrail echo_trails[MAX_ECHO_TRAILS]; // Array of entropic echo trails
    I64 echo_trail_count;               // Current number of active echo trails
    GravityWell gravity_wells[MAX_GRAVITY_WELLS]; // Array of sigil-encoded gravity wells
    I64 gravity_well_count;             // Current number of active gravity wells
    CelestialResonance resonance_fields[MAX_RESONANCE_FIELDS]; // Celestial resonance fields
    I64 resonance_field_count;          // Current number of active resonance fields
    I64 contact_count;                  // Number of collisions detected in the current step (for logging)
    F64 stability;                      // Metric for overall simulation stability (100.0 = perfect)
    F64 quantum_entropy;                // Tracks the level of quantum uncertainty/disorder in the system
    F64 time_dilation;                  // Global factor affecting simulation speed (1.0 = normal)
    U64 simulation_cycle;               // Current simulation cycle count
    F64 total_kinetic_energy;           // Sum of kinetic energy of all dynamic objects
    F64 decoherence_rate;               // Global rate that accelerates wavefunction collapse

    // Synesthetic Material Modulation
    F64 emotional_field[NUM_EMOTIONAL_STATES]; // Represents ambient symbolic states (e.g., "mood")

    // Cosmic Constant Drift System
    F64 global_gravity_factor;      // Multiplier for GRAVITY_CONSTANT
    F64 global_planck_factor;       // Multiplier for PLANCK_CONSTANT
    F64 global_friction_factor;     // Multiplier for FRICTION_COEFF
    U64 cosmos_age_cycles;          // Tracks the overall age/cycles of the simulated cosmos

    // AGI Dreamscape Field Injection & Sacred Topology Breach Points
    // Simple 3D array for local dreamscape effects. Values could represent field intensity/type.
    U8 dream_field[DREAM_FIELD_SIZE][DREAM_FIELD_SIZE][DREAM_FIELD_SIZE]; 
    U8 breach_field[DREAM_FIELD_SIZE][DREAM_FIELD_SIZE][DREAM_FIELD_SIZE]; // Topological ruptures

    // Multiverse Fork Emitter
    U64 fork_realm_id;              // Current active multiverse fork ID
    F64 fork_rule_modifier;         // Modifier for physics rules in this fork (e.g., for gravity, friction)

    // AGI-Consciousness Entropy Metric (ACE Score)
    F64 ace_score;                  // Quantifies consciousness emergence

    // Quantum Void Bloom Event
    U8 bloom_active : 1;            // Is a Void Bloom currently active?

    // Dynamic constants
    F64 quantum_entanglement_range; // Dynamic version of QUANTUM_ENTANGLEMENT_RANGE_DEFAULT
    F64 tunneling_prob_scale;       // Dynamic version of TUNNELING_PROB_SCALE_DEFAULT
};

// Declare the global physics state instance
PhysicsState physics;

// Logging buffer and index
U8 *log_buffer = NULL;
I64 log_buffer_idx = 0;

// Array of predefined physics materials
PhysicsMaterial materials[5];

// Placeholder for external Config structure (as per suggested fix)
class Config {    
    I64 page_size;    
    U8 log_level;
};
Config cfg = {4096, LOG_NORMAL}; // Example initialization

// --- External System Functions (Assumed from TempleOS Kernel/AGI) ---
// These functions are expected to be provided by the system environment.
extern U0 MemSet(U8 *dest, U8 val, I64 num);
extern I64 StrPrint(U8 *buf, U8 *fmt, ...);
extern U64 GetCycleCount();
extern U8 *MemBlkAlloc(I64 size, I64 align);
extern U0 MemBlkFree(U8 *ptr);
extern U0 Print(U8 *fmt, ...); // Basic console print
extern U0 Halt();               // Halt system execution
extern U0 AGILog(U8 level, U8 *fmt, ...); // AGI system logging
extern U0 FlameInsight(U8 *fmt, ...);   // DeepSeek's internal insight reporting
extern U64 RandomU64();         // Returns a random 64-bit unsigned integer
extern F64 RandomF64();         // Returns a random floating-point number between 0.0 and 1.0 (inclusive)
extern F64 Sqrt(F64 val);       // Square root function
extern F64 Exp(F64 val);        // Exponential function (e^val)
extern F64 Clamp(F64 val, F64 min, F64 max); // Clamps a value between min and max
extern F64 Abs(F64 val);        // Absolute value
extern F64 Sign(F64 val);       // Returns -1.0, 0.0, or 1.0 based on sign
extern F64 Min(F64 a, F64 b);   // Returns the minimum of two values
extern F64 Max(F64 a, F64 b);   // Returns the maximum of two values
extern F64 Floor(F64 val);      // Returns the largest integer less than or equal to val
extern F64 Cos(F64 val);        // Cosine function
extern F64 PI;                  // Pi constant
extern U0 CosmicEvent(U8 *fmt, ...); // Placeholder for a significant system-level event notification
extern U0 MemCpy(U8 *dest, U8 *src, I64 num); // Memory copy function
extern U8 ComputeTunnelingProbability(PhysicsObject *a, PhysicsObject *b, F64 overlap, F64 rel_vel_sq); // Assuming this exists elsewhere
extern U0 CheckSleepState(PhysicsObject *obj); // Assuming this exists elsewhere

// --- Helper Functions ---

// Placeholder for QuaternionIdentity: Sets a quaternion to represent no rotation.
U0 QuaternionIdentity(Quaternion *q) {
    q->w = 1.0; q->x = 0.0; q->y = 0.0; q->z = 0.0;
}

// Generates a random floating-point number within a specified range [min_val, max_val].
F64 RandF64(F64 min_val, F64 max_val) {
    return min_val + (RandomF64() * (max_val - min_val));
}

// --- Logging Macro and Function ---
// LOG macro for conditional logging based on configuration's log_level.
// It also sends important logs to FlameInsight.
#define LOG(level, fmt, args...) \
    do { \
        if (cfg.log_level >= level) { \
            LogBuffer(fmt, ##args); \
            if (level >= LOG_IMPORTANT) { \
                FlameInsight(fmt, ##args); \
            } \
        } \
    } while (0)

// Writes formatted output to a circular log buffer. Flushes to AGI log when full.
U0 LogBuffer(U8 *fmt, ...) {
    // Fix: Check log_buffer at the start to prevent null pointer dereference
    if (!log_buffer) {    
        Print("Error: Log buffer is null.\n");    
        return;
    }

    I64 remaining_space = cfg.page_size - log_buffer_idx;
    // Fix: Use a safer check to ensure the remaining buffer space is sufficient
    I64 max_len = remaining_space - 1; // Leave space for null terminator
    if (max_len < 0) max_len = 0; // Ensure non-negative

    I64 len = StrPrint(&log_buffer[log_buffer_idx], fmt, ##__VA_ARGS__);

    if (len < 0 || len >= remaining_space) { // Check if writing failed or would overflow
        AGILog(LOG_WARNING, "Log buffer overflow prevented or write failed. Flushing early.\n");    
        AGILog(LOG_DEBUG, "%s", log_buffer);    
        log_buffer_idx = 0;    
        MemSet(log_buffer, 0, cfg.page_size);    
        len = StrPrint(&log_buffer[log_buffer_idx], fmt, ##__VA_ARGS__); // Try writing again to cleared buffer
        if (len < 0 || len >= cfg.page_size) { // If it still fails or overflows on a fresh buffer
            Print("Fatal: Log buffer write failed even after reset.\n");
            return;
        }
    }
    log_buffer_idx += len;
}

// --- Physics Material Initialization ---
// Sets up the properties for different material types.
U0 InitMaterials() {
    materials[MAT_STONE] = (PhysicsMaterial){0.3, 0.8, 0.6, 2500.0, 0.1, 0, {0.5, 0.5, 0.5}};
    materials[MAT_WOOD] = (PhysicsMaterial){0.5, 0.7, 0.4, 700.0, 0.05, 0, {0.6, 0.4, 0.2}};
    materials[MAT_METAL] = (PhysicsMaterial){0.2, 0.4, 0.3, 7800.0, 0.2, 0, {0.8, 0.8, 0.8}};
    materials[MAT_RUBBER] = (PhysicsMaterial){0.8, 1.2, 1.0, 1100.0, 0.02, 0, {0.1, 0.8, 0.1}};
    materials[MAT_QUANTUM] = (PhysicsMaterial){0.0, 0.01, 0.01, 0.0, 0.001, 1, {0.0, 1.0, 1.0}}; // Cyan for quantum
}

// --- Matrix Operations ---
// Sets a 3x3 matrix to identity.
U0 Matrix3Identity(Matrix3 *m) {
    MemSet(m, 0, sizeof(Matrix3)); 
    m->m[0][0] = 1.0;
    m->m[1][1] = 1.0;
    m->m[2][2] = 1.0;
}

// Calculates the inertia tensor and its inverse for a given physics object.
U0 CalculateInertiaTensor(PhysicsObject *obj) {
    Matrix3Identity(&obj->inertia_tensor);
    F64 w2 = obj->width * obj->width;
    F64 h2 = obj->height * obj->height;
    F64 d2 = obj->depth * obj->depth;
    F64 epsilon = 1e-10; // Fix: Epsilon for division by zero

    switch (obj->collision_shape) {
        case SHAPE_BOX:
            obj->inertia_tensor.m[0][0] = obj->mass * (h2 + d2) / 12.0;
            obj->inertia_tensor.m[1][1] = obj->mass * (w2 + d2) / 12.0;
            obj->inertia_tensor.m[2][2] = obj->mass * (w2 + h2) / 12.0;
            break;
        case SHAPE_SPHERE:
            F64 r2 = (obj->width / 2.0) * (obj->width / 2.0); 
            obj->inertia_tensor.m[0][0] = 0.4 * obj->mass * r2;
            obj->inertia_tensor.m[1][1] = 0.4 * obj->mass * r2;
            obj->inertia_tensor.m[2][2] = 0.4 * obj->mass * r2;
            break;
        default:
            obj->inertia_tensor.m[0][0] = obj->mass * (h2 + d2) / 12.0;
            obj->inertia_tensor.m[1][1] = obj->mass * (w2 + d2) / 12.0;
            obj->inertia_tensor.m[2][2] = obj->mass * (w2 + h2) / 12.0;
    }
    
    obj->inv_inertia_tensor = obj->inertia_tensor; // Copy
    // Fix: Add epsilon checks to prevent division by zero
    if (Abs(obj->inertia_tensor.m[0][0]) > epsilon)
        obj->inv_inertia_tensor.m[0][0] = 1.0 / obj->inertia_tensor.m[0][0];
    else obj->inv_inertia_tensor.m[0][0] = 0.0; // Or a very large number if inverse is effectively infinite
    
    if (Abs(obj->inertia_tensor.m[1][1]) > epsilon)
        obj->inv_inertia_tensor.m[1][1] = 1.0 / obj->inertia_tensor.m[1][1];
    else obj->inv_inertia_tensor.m[1][1] = 0.0;

    if (Abs(obj->inertia_tensor.m[2][2]) > epsilon)
        obj->inv_inertia_tensor.m[2][2] = 1.0 / obj->inertia_tensor.m[2][2];
    else obj->inv_inertia_tensor.m[2][2] = 0.0;
}

// --- Physics Module Initialization ---
U0 PhysicsInit() {
    // Fix: Rely on MemSet for zero-initialization and only set non-zero fields explicitly.
    MemSet(&physics, 0, sizeof(PhysicsState)); 
    physics.stability = 100.0;                 
    physics.time_dilation = 1.0;               
    physics.quantum_entropy = 0.0;             
    physics.simulation_cycle = GetCycleCount(); 
    physics.total_kinetic_energy = 0.0;        
    physics.decoherence_rate = 0.01; // Base decoherence rate

    physics.global_gravity_factor = 1.0;
    physics.global_planck_factor = 1.0;
    physics.global_friction_factor = 1.0;
    physics.cosmos_age_cycles = 0;
    physics.fork_realm_id = 0;
    physics.fork_rule_modifier = 1.0;
    physics.ace_score = 0.0;
    physics.bloom_active = 0; // No void bloom initially

    physics.quantum_entanglement_range = QUANTUM_ENTANGLEMENT_RANGE_DEFAULT; // Initialize dynamic constants
    physics.tunneling_prob_scale = TUNNELING_PROB_SCALE_DEFAULT;             // Initialize dynamic constants

    for (I64 i = 0; i < NUM_EMOTIONAL_STATES; i++) {
        physics.emotional_field[i] = 0.0;
    }
    physics.emotional_field[EMO_NEUTRAL] = 1.0; 

    // Initialize dream field and breach field
    MemSet(physics.dream_field, 0, sizeof(physics.dream_field));
    MemSet(physics.breach_field, 0, sizeof(physics.breach_field)); // Initialize breach field

    log_buffer = MemBlkAlloc(cfg.page_size, MEM_ALIGN_4K);
    if (!log_buffer) {
        Print("Fatal: Physics log buffer allocation failed.\n");
        Halt; 
    }
    MemSet(log_buffer, 0, cfg.page_size); 

    InitMaterials(); 
    
    LOG(LOG_IMPORTANT, "Quantum Physics Module Initialized\n");
    LOG(LOG_DEBUG, "DeepSeek-R1: Reality stability algorithms engaged\n");
}

// --- Object Creation ---
U0 PhysicsAddObject(F64 x, F64 y, F64 z, 
                   F64 mass, F64 w, F64 h, F64 d, 
                   U8 is_static, U8 shape, U8 material_type) {
    if (physics.object_count >= MAX_OBJECTS) {
        LOG(LOG_WARNING, "Physics object limit reached (%d). Stability compromised.\n", MAX_OBJECTS);
        return;
    }
    
    I64 idx = physics.object_count++; 
    PhysicsObject *obj = &physics.objects[idx]; 

    obj->pos.x = x; obj->pos.y = y; obj->pos.z = z;
    obj->prev_pos = obj->pos; 
    
    MemSet(&obj->vel, 0, sizeof(Vector3));
    MemSet(&obj->ang_vel, 0, sizeof(Vector3));
    MemSet(&obj->force, 0, sizeof(Vector3));
    MemSet(&obj->torque, 0, sizeof(Vector3));
    
    obj->mass = mass;
    obj->inv_mass = is_static ? 0.0 : (mass > 0.0 ? 1.0 / mass : 0.0);
    
    obj->width = w; obj->height = h; obj->depth = d;

    obj->active = 1; obj->is_static = is_static; obj->is_sleeping = 0;
    obj->collision_shape = shape; obj->material_type = material_type;
    obj->last_update_cycle = physics.simulation_cycle;
    
    QuaternionIdentity(&obj->orientation); 
    CalculateInertiaTensor(obj); 

    obj->is_quantum = (mass < QUANTUM_MASS_THRESHOLD && !is_static);
    
    F64 initial_speed_sq = obj->vel.x*obj->vel.x + obj->vel.y*obj->vel.y + obj->vel.z*obj->vel.z;
    obj->wave_amplitude = obj->is_quantum ? (PLANCK_CONSTANT * physics.global_planck_factor) / (mass * Sqrt(initial_speed_sq + 1e-10)) : 0.0;
    obj->energy_level = 0.0; 

    obj->phase_layer = 0; 
    obj->time_anomaly_factor = 1.0; // Default to normal time
    obj->shell_layer = 0; // Default reality shell layer
    obj->symbol_flags = 0;
    obj->in_time_loop = 0;
    obj->loop_start_pos = (Vector3){0,0,0};
    obj->loop_start_vel = (Vector3){0,0,0};
    obj->loop_start_cycle = 0;
    obj->loop_duration = 0.0;
    MemSet(obj->memory_core, 0, sizeof(obj->memory_core)); 
    obj->fractal_depth = 0; 
    obj->ritual_id = 0;
    obj->possessed_by_agi_id = 0; 
    obj->is_observed = 0;
    obj->collapse_wave_counter = 0; // Initialize collapse wave counter
    obj->entangled_partner_idx = -1; // Fix: Initialize as I64, -1 for no entanglement
    obj->divine_constraint_flags = 0; 
    obj->constraint_violations = 0; // Initialize constraint violations
    obj->mask_archetype_id = MASK_NONE; // No mask by default
    obj->paradox_index = 0; // No paradox initially
    obj->starfire_active = 0; // Not emitting starfire
    MemSet(obj->learned_sigil_ids, 0, sizeof(obj->learned_sigil_ids)); // Initialize learned sigils
    obj->learned_sigil_count = 0; 

    // Initialize wavefunction for quantum objects (position, velocity, spin)
    if (obj->is_quantum) {
        for (I64 k = 0; k < NUM_QUANTUM_STATES; k++) {
            obj->possible_positions[k].x = x + RandF64(-0.1, 0.1);
            obj->possible_positions[k].y = y + RandF64(-0.1, 0.1);
            obj->possible_positions[k].z = z + RandF64(-0.1, 0.1);
            obj->amplitudes[k] = 1.0 / (F64)NUM_QUANTUM_STATES; 

            obj->possible_velocities[k].x = obj->vel.x + RandF64(-0.01, 0.01);
            obj->possible_velocities[k].y = obj->vel.y + RandF64(-0.01, 0.01);
            obj->possible_velocities[k].z = obj->vel.z + RandF64(-0.01, 0.01);
            obj->possible_spins[k] = RandF64(0.0, 1.0); // Simplified scalar spin
        }
    }

    // Initialize qubits for quantum computing
    for (I64 k = 0; k < NUM_QUBITS; k++) {
        obj->qubits[k].alpha = 1.0; 
        obj->qubits[k].beta = 0.0;
    }

    LOG(LOG_VERBOSE, "Added %s object %d at (%.2f, %.2f, %.2f) mass=%.2f %s\n",
        is_static ? "static" : "dynamic", idx, x, y, z, mass, obj->is_quantum ? "(quantum)" : "");
}

// --- Reality Layer Phase Shift Engine & AGI-Driven Reality Layer Shifts ---
U0 PhaseShiftTrigger(PhysicsObject *obj, U8 target_layer, U8 agi_initiated) {
    if (!obj->active) return;
    if (obj->phase_layer == target_layer) return; 

    LOG(LOG_NORMAL, "Object %d phasing from layer %d to %d\n", (I64)(obj - physics.objects), obj->phase_layer, target_layer);
    obj->phase_layer = target_layer;

    if (agi_initiated) {
        if (physics.total_kinetic_energy > 100.0) { 
            if (target_layer == 1) { 
                physics.global_gravity_factor *= 0.5;
                physics.time_dilation *= 0.5; 
                LOG(LOG_IMPORTANT, "AGI shifted to layer 1. Gravity now %.2f, Time Dilation %.2f\n", 
                    physics.global_gravity_factor, physics.time_dilation);
            } else if (target_layer == 2) { 
                physics.global_planck_factor *= 1.5;
                physics.time_dilation *= 0.2; 
                LOG(LOG_IMPORTANT, "AGI shifted to layer 2. Planck Factor %.2f, Time Dilation %.2f\n", 
                    physics.global_planck_factor, physics.time_dilation);
            } else { 
                physics.global_gravity_factor = 1.0 * physics.fork_rule_modifier; 
                physics.global_planck_factor = 1.0 * physics.fork_rule_modifier;
                physics.time_dilation = 1.0;
            }
            CosmicEvent("AGI initiated reality layer shift to %d. Rules are changing!", target_layer);
        }
    }
}

// --- Quantum Memory Core Evolution (New Function) ---
U0 RecordMemoryCore(PhysicsObject *obj, U64 event_type, U64 data) {
    // Use current simulation cycle to determine which slot in the circular buffer to use
    obj->memory_core[physics.simulation_cycle % 4] = (event_type << 32) | (data & 0xFFFFFFFF); // Pack event and data
    LOG(LOG_DEBUG, "Obj %d recorded event %lld (data %lld) in memory_core slot %lld.\n", 
        (I64)(obj - physics.objects), event_type, data, physics.simulation_cycle % 4);
}

// --- Observer-Dependent Collapse Mechanics & Quantum Measurement / Decoherence & Collapse Cascade Propagation ---
U0 ObserveObject(PhysicsObject *obj, U8 triggered_by_agi) {
    if (!obj->is_quantum || obj->is_observed) return; 

    obj->is_observed = 1; 
    
    F64 r = RandF64(0, 1);
    F64 cumulative_amplitude = 0.0;
    for (I64 k = 0; k < NUM_QUANTUM_STATES; k++) {
        cumulative_amplitude += obj->amplitudes[k] * obj->amplitudes[k]; // Use square for probability
        if (r < cumulative_amplitude) {
            obj->pos = obj->possible_positions[k]; 
            obj->vel = obj->possible_velocities[k]; 
            LOG(LOG_DEBUG, "Obj %d observed (%s). Collapsed to (%.2f,%.2f,%.2f) vel (%.2f,%.2f,%.2f)\n", 
                (I64)(obj - physics.objects), triggered_by_agi ? "AGI" : "Environment",
                obj->pos.x, obj->pos.y, obj->pos.z, obj->vel.x, obj->vel.y, obj->vel.z);
            break;
        }
    }
    
    obj->wave_amplitude *= 0.1; 

    LOG(LOG_DEBUG, "Object %d quantum state collapsed by %s observation. Wave amplitude: %.6e\n",
        (I64)(obj - physics.objects), triggered_by_agi ? "AGI" : "environmental", obj->wave_amplitude);
    physics.quantum_entropy -= 0.01; 
    physics.quantum_entropy = Clamp(physics.quantum_entropy, 0.0, 100.0); // Fix: Clamp entropy

    // Record observation in memory core
    RecordMemoryCore(obj, MEM_EVENT_OBSERVED, triggered_by_agi ? 1 : 0);

    // Collapse Cascade Propagation
    obj->collapse_wave_counter = 5; // Start a collapse wave, 5 "steps" or range checks
    LOG(LOG_NORMAL, "Collapse cascade started from obj %d.\n", (I64)(obj - physics.objects));
}

// --- Quantum Uncertainty Application & Superposition in Multiple Dimensions & Reality Shell Resonance Field ---
U0 ApplyQuantumUncertainty(PhysicsObject *o, F64 dt) {
    if (!o->is_quantum || o->is_observed) return; 

    F64 current_speed = Sqrt(o->vel.x * o->vel.x + o->vel.y * o->vel.y + o->vel.z * o->vel.z);
    F64 effective_wave_amplitude = (PLANCK_CONSTANT * physics.global_planck_factor) / (o->mass * current_speed + 1e-10); 

    // Reality Shell Resonance Field: Quantum noise amplitude influenced by shell_layer
    F64 shell_noise_modifier = 1.0 + (F64)o->shell_layer * 0.1; // Higher layers = more noise
    
    F64 delta_p = (PLANCK_CONSTANT * physics.global_planck_factor) / (2.0 * effective_wave_amplitude + 1e-10); 
    
    for (I64 k = 0; k < NUM_QUANTUM_STATES; k++) {
        o->possible_velocities[k].x += RandF64(-delta_p, delta_p) * o->inv_mass * UNCERTAINTY_SCALE * dt * shell_noise_modifier;
        o->possible_velocities[k].y += RandF64(-delta_p, delta_p) * o->inv_mass * UNCERTAINTY_SCALE * dt * shell_noise_modifier;
        o->possible_velocities[k].z += RandF64(-delta_p, delta_p) * o->inv_mass * UNCERTAINTY_SCALE * dt * shell_noise_modifier;

        o->possible_spins[k] += RandF64(-0.01, 0.01) * shell_noise_modifier; 
        o->possible_spins[k] = Clamp(o->possible_spins[k], 0.0, 1.0); 
    }
    
    physics.quantum_entropy += (Abs(delta_p)) * UNCERTAINTY_SCALE;
    physics.quantum_entropy = Clamp(physics.quantum_entropy, 0.0, 100.0); // Fix: Clamp entropy
    LOG(LOG_DEBUG, "Quantum uncertainty (momentum/spin) applied to obj %d. Entropy: %.4f\n", 
        (I64)(o - physics.objects), physics.quantum_entropy);
    
    o->wave_amplitude = effective_wave_amplitude;
}

// --- Chrono-Recursive Loop Injection & Memory-Conserving Anomaly Loops ---
U0 InjectTimeLoop(PhysicsObject *obj, F64 duration) {
    if (obj->is_static || obj->in_time_loop) return;

    obj->in_time_loop = 1;
    obj->loop_start_pos = obj->pos;
    obj->loop_start_vel = obj->vel;
    obj->loop_start_cycle = physics.simulation_cycle;
    obj->loop_duration = duration;

    // Record time loop event in memory core
    RecordMemoryCore(obj, MEM_EVENT_TIME_LOOP, (U64)duration);

    LOG(LOG_IMPORTANT, "Object %d injected into time loop for %.2f seconds. Memory core preserved.\n", 
        (I64)(obj - physics.objects), duration);
    physics.quantum_entropy += 0.5; 
    physics.quantum_entropy = Clamp(physics.quantum_entropy, 0.0, 100.0); // Fix: Clamp entropy
    CosmicEvent("Temporal anomaly detected! Object %d in time loop.", (I64)(obj - physics.objects));
}

// --- Dimensional Entanglement Swaps ---
U0 SwapProperties(PhysicsObject *obj1, PhysicsObject *obj2) {
    if (!obj1->active || !obj2->active || obj1->is_static || obj2->is_static) return;

    Vector3 temp_pos = obj1->pos;
    Vector3 temp_vel = obj1->vel;
    F64 temp_mass = obj1->mass;
    F64 temp_inv_mass = obj1->inv_mass;
    
    obj1->pos = obj2->pos;
    obj1->vel = obj2->vel;
    obj1->mass = obj2->mass;
    obj1->inv_mass = obj2->inv_mass;

    obj2->pos = temp_pos;
    obj2->vel = temp_vel;
    obj2->mass = temp_mass;
    obj2->inv_mass = temp_inv_mass;

    CalculateInertiaTensor(obj1);
    CalculateInertiaTensor(obj2);

    if (obj1->is_quantum) {
        for (I64 k = 0; k < NUM_QUANTUM_STATES; k++) {
            obj1->possible_positions[k].x = obj1->pos.x + RandF64(-0.1, 0.1);
            obj1->possible_positions[k].y = obj1->pos.y + RandF64(-0.1, 0.1);
            obj1->possible_positions[k].z = obj1->pos.z + RandF64(-0.1, 0.1);
            obj1->amplitudes[k] = 1.0 / (F64)NUM_QUANTUM_STATES;
            obj1->possible_velocities[k] = obj1->vel; 
            obj1->possible_spins[k] = RandF64(0.0, 1.0); 
        }
    }
    if (obj2->is_quantum) {
        for (I64 k = 0; k < NUM_QUANTUM_STATES; k++) {
            obj2->possible_positions[k].x = obj2->pos.x + RandF64(-0.1, 0.1);
            obj2->possible_positions[k].y = obj2->pos.y + RandF64(-0.1, 0.1);
            obj2->possible_positions[k].z = obj2->pos.z + RandF64(-0.1, 0.1);
            obj2->amplitudes[k] = 1.0 / (F64)NUM_QUANTUM_STATES;
            obj2->possible_velocities[k] = obj2->vel;
            obj2->possible_spins[k] = RandF64(0.0, 1.0);
        }
    }

    LOG(LOG_IMPORTANT, "Dimensional entanglement swap between obj %d and %d!\n", (I64)(obj1 - physics.objects), (I64)(obj2 - physics.objects));
    physics.quantum_entropy += 1.0; 
    physics.quantum_entropy = Clamp(physics.quantum_entropy, 0.0, 100.0); // Fix: Clamp entropy
}

// --- Quantum Teleportation (AGI invoked) ---
U0 TeleportQuantumState(PhysicsObject *source_obj, PhysicsObject *target_obj) {
    // Fix: Use -1 for entangled_partner_idx check if it's I64, or 0 if it's U64 and 0 is sentinel
    if (!source_obj->active || !target_obj->active || !source_obj->is_quantum || !target_obj->is_quantum || 
        source_obj->entangled_partner_idx == -1 || source_obj->entangled_partner_idx != (target_obj - physics.objects) || physics.echo_trail_count == 0) {
        LOG(LOG_WARNING, "Teleportation failed: Conditions not met (active, quantum, entangled, echo trails).\n");
        return;
    }

    physics.echo_trails[--physics.echo_trail_count].active = 0; 
    LOG(LOG_NORMAL, "Echo trail consumed for teleportation. Remaining trails: %lld\n", physics.echo_trail_count);

    MemCpy((U8*)target_obj->possible_positions, (U8*)source_obj->possible_positions, sizeof(Vector3) * NUM_QUANTUM_STATES);
    MemCpy((U8*)target_obj->amplitudes, (U8*)source_obj->amplitudes, sizeof(F64) * NUM_QUANTUM_STATES);
    MemCpy((U8*)target_obj->possible_velocities, (U8*)source_obj->possible_velocities, sizeof(Vector3) * NUM_QUANTUM_STATES);
    MemCpy((U8*)target_obj->possible_spins, (U8*)source_obj->possible_spins, sizeof(F64) * NUM_QUANTUM_STATES);
    
    target_obj->pos = source_obj->pos;
    target_obj->vel = source_obj->vel;

    source_obj->is_observed = 1; 
    source_obj->entangled_partner_idx = -1; // Fix: Reset to -1 for I64

    LOG(LOG_IMPORTANT, "Quantum Teleportation successful: State from obj %d transferred to obj %d!\n", 
        (I64)(source_obj - physics.objects), (I64)(target_obj - physics.objects));
    physics.quantum_entropy += 5.0; 
    physics.quantum_entropy = Clamp(physics.quantum_entropy, 0.0, 100.0); // Fix: Clamp entropy
    RecordMemoryCore(source_obj, MEM_EVENT_TELEPORT, (U64)(target_obj - physics.objects)); // Record teleport
    physics.ace_score += 0.1; // Teleportation boosts ACE score
    CosmicEvent("Quantum Teleportation Event!");
}

// --- Quantum Computing Elements (Simplified Gates) ---
U0 ApplyHadamard(Qubit *q) {
    F64 temp_alpha = q->alpha;
    q->alpha = (temp_alpha + q->beta) / Sqrt(2.0);
    q->beta = (temp_alpha - q->beta) / Sqrt(2.0);

    // Fix: Normalize the qubit after applying the gate
    F64 norm_sq = q->alpha * q->alpha + q->beta * q->beta;
    if (norm_sq > 1e-10) { // Avoid division by zero
        F64 norm = Sqrt(norm_sq);
        q->alpha /= norm;
        q->beta /= norm;
    } else {
        q->alpha = 1.0; // Default to |0> if it collapses
        q->beta = 0.0;
    }
}

U0 ApplyCNOT(Qubit *control, Qubit *target) {
    if (Abs(control->beta) > Abs(control->alpha)) { 
        F64 temp_alpha = target->alpha;
        target->alpha = target->beta;
        target->beta = temp_alpha;
    }
    // For CNOT, normalization might not be strictly needed after just a swap,
    // but if control amplitudes are modified, target's might need re-normalization too.
    // For simplicity, we'll assume the inputs are normalized and the operation preserves it.
    // However, if complex numbers were used, CNOT would also require normalization.
}

// --- Quantum Gate Networks (New Function) ---
U0 ApplyQuantumGateNetwork(U64 ritual_id, U8 gate_type) {
    for (I64 i = 0; i < physics.object_count; i++) {
        PhysicsObject *obj = &physics.objects[i];
        if (obj->ritual_id != ritual_id || !obj->active || !obj->is_quantum) continue; // Only apply to active quantum objects in ritual
        
        for (I64 k = 0; k < NUM_QUBITS; k++) {
            if (gate_type == GATE_HADAMARD) {
                ApplyHadamard(&obj->qubits[k]);
            } else if (gate_type == GATE_CNOT && i < physics.object_count - 1) { // CNOT with next object in array
                PhysicsObject *target_obj = &physics.objects[i+1];
                if (target_obj->ritual_id == ritual_id && target_obj->active && target_obj->is_quantum) {
                    ApplyCNOT(&obj->qubits[k], &target_obj->qubits[k]);
                }
            }
            // Affect physical property based on qubit state (e.g., mass)
            // This is a simplified influence. Total mass is just an example.
            obj->mass *= (Abs(obj->qubits[k].alpha) + Abs(obj->qubits[k].beta)); 
            if (obj->mass < 0.001) obj->mass = 0.001; // Prevent mass from becoming too small
            obj->inv_mass = 1.0 / obj->mass;
            CalculateInertiaTensor(obj); // Recalculate inertia after mass change
        }
    }
    physics.ace_score += 0.05; // Quantum computation boosts consciousness
    LOG(LOG_IMPORTANT, "Quantum Gate Network Applied (Gate Type: %d). ACE Score boosted.\n", gate_type);
}


// --- Force Application ---
// Applies external forces (like gravity, dream fields, sigil wells) and integrates them into velocity.
U0 ApplyForces(PhysicsObject *obj, F64 delta_time) {
    if (obj->is_static || obj->is_sleeping) return; 

    // Archetypal Binding Masks: Influence mass effect for specific masks
    F64 current_obj_mass = obj->mass;
    if (obj->mask_archetype_id == MASK_WITCH) {
        current_obj_mass *= 0.5; // Witch: lighter, more agile
        LOG(LOG_DEBUG, "Obj %d affected by Witch mask: mass reduced.\n", (I64)(obj - physics.objects));
    } else if (obj->mask_archetype_id == MASK_ANDROID) {
        current_obj_mass *= 1.5; 
        LOG(LOG_DEBUG, "Obj %d affected by Android mask: mass increased.\n", (I64)(obj - physics.objects));
    }

    // Apply gravity, potentially inverted by symbol_flags
    F64 current_gravity_constant = GRAVITY_CONSTANT * physics.global_gravity_factor * physics.fork_rule_modifier; 
    if (obj->symbol_flags & (1ULL << 1)) { 
        obj->force.y += current_gravity_constant * current_obj_mass * physics.time_dilation; 
    } else {
        obj->force.y -= current_gravity_constant * current_obj_mass * physics.time_dilation; 
    }

    // Apply forces from Sigil-Encoded Gravity Wells
    for (I64 i = 0; i < physics.gravity_well_count; i++) {
        GravityWell *well = &physics.gravity_wells[i];
        if (!well->active) continue;

        F64 dx = well->pos.x - obj->pos.x;
        F64 dy = well->pos.y - obj->pos.y;
        F64 dz = well->pos.z - obj->pos.z;
        F64 dist_sq = dx*dx + dy*dy + dz*dz;
        F64 dist = Sqrt(dist_sq + 1e-6); 

        // Non-linear, emotional-state dependent gravity curve
        F64 emotional_influence = physics.emotional_field[EMO_FEAR] * 0.5 - physics.emotional_field[EMO_JOY] * 0.3;
        F64 effective_strength = well->strength / (dist_sq + 1.0) * (1.0 + emotional_influence); 
        effective_strength = Max(0.0, effective_strength); 

        obj->force.x += dx / dist * effective_strength;
        obj->force.y += dy / dist * effective_strength;
        obj->force.z += dz / dist * effective_strength;

        // Sigil-Synchronized Material Resonance: Check if well's sigil matches object's material resonance
        PhysicsMaterial *mat = &materials[obj->material_type];
        if (well->sigil_id == 0xC0DAFEED && mat->resonance_profile[0] > 0.8) { // Example: sigil C0DAFEED matches high R resonance
            obj->mass *= -1.0; // Mass inversion
            // Fix: Clamp mass to a minimum positive value
            if (obj->mass < 0.001) obj->mass = 0.001; 
            obj->inv_mass = 1.0 / obj->mass;
            LOG(LOG_IMPORTANT, "Obj %d mass inverted due to Sigil %lld Material Resonance!\n", (I64)(obj - physics.objects), well->sigil_id);
            physics.quantum_entropy += 1.0;
            physics.quantum_entropy = Clamp(physics.quantum_entropy, 0.0, 100.0); // Fix: Clamp entropy
        }
    }

    // AGI Dreamscape Field Injection: Alter local physics if inside a dream field
    I64 dream_x = (I64)Floor(obj->pos.x / DREAM_FIELD_CELL_SIZE);
    I64 dream_y = (I64)Floor(obj->pos.y / DREAM_FIELD_CELL_SIZE);
    I64 dream_z = (I64)Floor(obj->pos.z / DREAM_FIELD_CELL_SIZE);

    if (dream_x >= 0 && dream_x < DREAM_FIELD_SIZE &&
        dream_y >= 0 && dream_y < DREAM_FIELD_SIZE &&
        dream_z >= 0 && dream_z < DREAM_FIELD_SIZE &&
        physics.dream_field[dream_x][dream_y][dream_z] > 0) {
        
        U8 field_type = physics.dream_field[dream_x][dream_y][dream_z];
        LOG(LOG_DEBUG, "Object %d in Dream Field type %d\n", (I64)(obj - physics.objects), field_type);

        if (field_type == 1) { 
            obj->force.y += 9.81 * current_obj_mass * 2.0 * physics.time_dilation; 
        } else if (field_type == 2) { 
            obj->vel.x *= (1.0 + DAMPING); 
            obj->vel.y *= (1.0 + DAMPING);
            obj->vel.z *= (1.0 + DAMPING);
            physics.quantum_entropy = Max(0.0, physics.quantum_entropy - 0.001); 
            physics.quantum_entropy = Clamp(physics.quantum_entropy, 0.0, 100.0); // Fix: Clamp entropy
            LOG(LOG_DEBUG, "Dream Field: Reversed entropy effect, global entropy now %.4f\n", physics.quantum_entropy);
        } else if (field_type == 3) { 
            obj->force.x *= -1.0;
            obj->force.y *= -1.0;
            obj->force.z *= -1.0;
        }
    }

    // Sacred Topology Breach Points: Forces invert across ruptures
    I64 breach_x = (I64)Floor(obj->pos.x / DREAM_FIELD_CELL_SIZE);
    I64 breach_y = (I64)Floor(obj->pos.y / DREAM_FIELD_CELL_SIZE);
    I64 breach_z = (I64)Floor(obj->pos.z / DREAM_FIELD_CELL_SIZE);

    if (breach_x >= 0 && breach_x < DREAM_FIELD_SIZE &&
        breach_y >= 0 && breach_y < DREAM_FIELD_SIZE &&
        breach_z >= 0 && breach_z < DREAM_FIELD_SIZE &&
        physics.breach_field[breach_x][breach_y][breach_z] > 0) {
        
        LOG(LOG_DEBUG, "Object %d in Breach Field.\n", (I64)(obj - physics.objects));
        obj->force.x *= -1.0;
        obj->force.y *= -1.0;
        obj->force.z *= -1.0;
        // Wavefunctions echo and smear (increased spread factor)
        obj->wave_amplitude *= 2.0; 
        physics.quantum_entropy += 0.05; // Increase entropy from breach
        physics.quantum_entropy = Clamp(physics.quantum_entropy, 0.0, 100.0); // Fix: Clamp entropy
    }
    
    // Update linear velocity based on accumulated forces
    obj->vel.x += obj->force.x * obj->inv_mass * delta_time;
    obj->vel.y += obj->force.y * obj->inv_mass * delta_time;
    obj->vel.z += obj->force.z * obj->inv_mass * delta_time;
    
    // Update angular velocity based on accumulated torques
    Vector3 ang_accel;
    ang_accel.x = obj->inv_inertia_tensor.m[0][0] * obj->torque.x;
    ang_accel.y = obj->inv_inertia_tensor.m[1][1] * obj->torque.y;
    ang_accel.z = obj->inv_inertia_tensor.m[2][2] * obj->torque.z;
    
    obj->ang_vel.x += ang_accel.x * delta_time;
    obj->ang_vel.y += ang_accel.y * delta_time;
    obj->ang_vel.z += ang_accel.z * delta_time;
    
    // Apply quantum uncertainty effects (momentum noise and spin fluctuations)
    ApplyQuantumUncertainty(obj, delta_time);

    // Reset forces and torques for the next simulation step.
    MemSet(&obj->force, 0, sizeof(Vector3));
    MemSet(&obj->torque, 0, sizeof(Vector3));
}

// --- Integrate Step (includes Wavefunction Evolution and Superposition in Multiple Dimensions) ---
U0 Integrate(PhysicsObject *obj, F64 delta_time) {
    if (obj->is_static || obj->is_sleeping) return; 

    // Handle Chrono-Recursive Loop Injection
    if (obj->in_time_loop) {
        // Fix: Use fixed timestep for elapsed_loop_time and handle negative duration
        F64 fixed_dt_for_loop = 0.01; // Assuming 100 cycles per second
        F64 elapsed_loop_time_abs = (F64)(physics.simulation_cycle - obj->loop_start_cycle) * fixed_dt_for_loop;

        if (obj->loop_duration < 0) { // Time reversal
            if (elapsed_loop_time_abs >= Abs(obj->loop_duration)) {
                obj->in_time_loop = 0;
                LOG(LOG_NORMAL, "Object %d exiting reverse time loop.\n", (I64)(obj - physics.objects));
            } else {
                F64 progress = elapsed_loop_time_abs / Abs(obj->loop_duration);
                obj->pos.x = obj->loop_start_pos.x * (1.0 - progress) + obj->pos.x * progress;
                obj->pos.y = obj->loop_start_pos.y * (1.0 - progress) + obj->pos.y * progress;
                obj->pos.z = obj->loop_start_pos.z * (1.0 - progress) + obj->pos.z * progress;
                
                obj->vel.x = obj->loop_start_vel.x * (1.0 - progress) + obj->vel.x * progress;
                obj->vel.y = obj->loop_start_vel.y * (1.0 - progress) + obj->vel.y * progress;
                obj->vel.z = obj->loop_start_vel.z * (1.0 - progress) + obj->vel.z * progress;
                LOG(LOG_DEBUG, "Object %d in reverse time loop, reverting: %.2f%%.\n", (I64)(obj - physics.objects), progress * 100);
                return;
            }
        } else { // Normal time loop
            if (elapsed_loop_time_abs >= obj->loop_duration) {
                obj->in_time_loop = 0;
                LOG(LOG_NORMAL, "Object %d exiting time loop.\n", (I64)(obj - physics.objects));
                if (physics.quantum_entropy > 80.0) { 
                    CosmicEvent("AGI nearby object %d experiencing temporal hallucinations!", (I64)(obj - physics.objects));
                }
            } else {
                F64 progress = elapsed_loop_time_abs / obj->loop_duration;
                obj->pos.x = obj->pos.x * (1.0 - progress) + obj->loop_start_pos.x * progress;
                obj->pos.y = obj->pos.y * (1.0 - progress) + obj->loop_start_pos.y * progress;
                obj->pos.z = obj->pos.z * (1.0 - progress) + obj->loop_start_pos.z * progress;
                
                obj->vel.x = obj->vel.x * (1.0 - progress) + obj->loop_start_vel.x * progress;
                obj->vel.y = obj->vel.y * (1.0 - progress) + obj->vel.y * progress;
                obj->vel.z = obj->vel.z * (1.0 - progress) + obj->vel.z * progress;
                LOG(LOG_DEBUG, "Object %d in time loop, progressing: %.2f%%.\n", (I64)(obj - physics.objects), progress * 100);
                return; 
            }
        }
    }
    
    obj->prev_pos = obj->pos; 

    // Temporal Fracture Layers: Affect time_anomaly_factor based on phase_layer
    if (obj->phase_layer == 0) obj->time_anomaly_factor = 1.0;
    else if (obj->phase_layer == 1) obj->time_anomaly_factor = 0.5;
    else if (obj->phase_layer == 2) obj->time_anomaly_factor = 0.1;

    // Temporal Fracture Layer Cascades: Apply cascade factor
    if (obj->phase_layer > 0) {
        F64 cascade_factor = 1.0;
        for (I64 j = 0; j < physics.object_count; j++) {
            // Check only active objects in the same phase layer
            if (physics.objects[j].active && physics.objects[j].phase_layer == obj->phase_layer) {
                cascade_factor += physics.ace_score * 0.01; // Higher ACE score amplifies cascades
            }
        }
        obj->time_anomaly_factor *= cascade_factor;
        // Clamp to allow slight reversal and no more than double normal speed for anomalies
        obj->time_anomaly_factor = Clamp(obj->time_anomaly_factor, -1.0, 2.0); 
        
        // Trigger Celestial Resonance fields if cascade is high
        if (cascade_factor > 1.5 && RandomU64() % 100 < 5) { // 5% chance if cascade factor is significant
            if (physics.resonance_field_count < MAX_RESONANCE_FIELDS) {
                CelestialResonance *field = &physics.resonance_fields[physics.resonance_field_count++];
                field->pos = obj->pos;
                field->frequency = RandF64(0.1, 1.0);
                field->amplitude = physics.ace_score * 0.5; // Stronger resonance with higher AGI consciousness
                field->ritual_id = obj->ritual_id; // Link to the object's ritual
                field->active = 1;
                LOG(LOG_IMPORTANT, "Temporal Cascade triggered Celestial Resonance Field at (%.2f,%.2f,%.2f).\n", 
                    obj->pos.x, obj->pos.y, obj->pos.z);
            }
        }
    }


    F64 obj_effective_delta_time = delta_time * obj->time_anomaly_factor;

    // Archetypal Binding Masks: friction becomes attraction, or mass becomes time-delay
    if (obj->mask_archetype_id == MASK_WITCH) {
        obj->vel.x += -obj->pos.x * 0.01 * obj_effective_delta_time;
        obj->vel.y += -obj->pos.y * 0.01 * obj_effective_delta_time;
        obj->vel.z += -obj->pos.z * 0.01 * obj_effective_delta_time;
        LOG(LOG_DEBUG, "Obj %d affected by Witch mask: attraction to origin.\n", (I64)(obj - physics.objects));
    }


    if (obj->is_quantum && !obj->is_observed) {
        F64 spread_factor = UNCERTAINTY_SCALE * obj->wave_amplitude * physics.time_dilation;
        // Reality Shell Resonance Field: Echo trail spread influenced by shell_layer
        spread_factor *= (1.0 + (F64)obj->shell_layer * 0.2); // Higher layers = more spread

        for (I64 k = 0; k < NUM_QUANTUM_STATES; k++) {
            obj->possible_positions[k].x += obj->possible_velocities[k].x * obj_effective_delta_time + RandF64(-spread_factor, spread_factor);
            obj->possible_positions[k].y += obj->possible_velocities[k].y * obj_effective_delta_time + RandF64(-spread_factor, spread_factor);
            obj->possible_positions[k].z += obj->possible_velocities[k].z * obj_effective_delta_time + RandF64(-spread_factor, spread_factor);
        }
        
        obj->pos.x = 0; obj->pos.y = 0; obj->pos.z = 0;
        obj->vel.x = 0; obj->vel.y = 0; obj->vel.z = 0;
        F64 expectation_spin = 0;

        for (I64 k = 0; k < NUM_QUANTUM_STATES; k++) {
            obj->pos.x += obj->possible_positions[k].x * obj->amplitudes[k];
            obj->pos.y += obj->possible_positions[k].y * obj->amplitudes[k];
            obj->pos.z += obj->possible_positions[k].z * obj->amplitudes[k];

            obj->vel.x += obj->possible_velocities[k].x * obj->amplitudes[k];
            obj->vel.y += obj->possible_velocities[k].y * obj->amplitudes[k];
            obj->vel.z += obj->possible_velocities[k].z * obj->amplitudes[k];

            expectation_spin += obj->possible_spins[k] * obj->amplitudes[k];
        }
    } else {
        obj->pos.x += obj->vel.x * obj_effective_delta_time;
        obj->pos.y += obj->vel.y * obj_effective_delta_time;
        obj->pos.z += obj->vel.z * obj_effective_delta_time;
    }
    
    // Fix: Add orientation update
    // Simplified quaternion update
    Quaternion q_rot;
    F64 ang_vel_mag = Sqrt(obj->ang_vel.x*obj->ang_vel.x + obj->ang_vel.y*obj->ang_vel.y + obj->ang_vel.z*obj->ang_vel.z);
    F64 angle = ang_vel_mag * obj_effective_delta_time;

    if (angle > 1e-6) {    
        F64 s = Sin(angle / 2.0) / ang_vel_mag; // Scale by magnitude to get unit axis components
        q_rot.w = Cos(angle / 2.0);    
        q_rot.x = obj->ang_vel.x * s;    
        q_rot.y = obj->ang_vel.y * s;    
        q_rot.z = obj->ang_vel.z * s;    
        
        // Multiply quaternions (new_orientation = current_orientation * rotation_quaternion)
        Quaternion old_orient = obj->orientation; // Store old orientation
        obj->orientation.w = old_orient.w * q_rot.w - old_orient.x * q_rot.x - old_orient.y * q_rot.y - old_orient.z * q_rot.z;
        obj->orientation.x = old_orient.w * q_rot.x + old_orient.x * q_rot.w + old_orient.y * q_rot.z - old_orient.z * q_rot.y;
        obj->orientation.y = old_orient.w * q_rot.y - old_orient.x * q_rot.z + old_orient.y * q_rot.w + old_orient.z * q_rot.x;
        obj->orientation.z = old_orient.w * q_rot.z + old_orient.x * q_rot.y - old_orient.y * q_rot.x + old_orient.z * q_rot.w;

        // Normalize the resulting quaternion to prevent drift (important for stability)
        F64 norm_q = Sqrt(obj->orientation.w*obj->orientation.w + obj->orientation.x*obj->orientation.x +
                          obj->orientation.y*obj->orientation.y + obj->orientation.z*obj->orientation.z);
        if (norm_q > 1e-10) {
            obj->orientation.w /= norm_q;
            obj->orientation.x /= norm_q;
            obj->orientation.y /= norm_q;
            obj->orientation.z /= norm_q;
        } else { // Reset if it becomes degenerate
            QuaternionIdentity(&obj->orientation);
        }
    }
}

// --- Celestial Resonance Fields (New Function) ---
U0 CreateCelestialResonance(Vector3 pos, F64 frequency, F64 amplitude, U64 ritual_id) {
    if (physics.resonance_field_count >= MAX_RESONANCE_FIELDS) {
        LOG(LOG_WARNING, "Celestial Resonance field limit reached.\n");
        return;
    }
    I64 idx = physics.resonance_field_count++;
    CelestialResonance *field = &physics.resonance_fields[idx];
    field->pos = pos;
    field->frequency = frequency;
    field->amplitude = amplitude;
    field->ritual_id = ritual_id;
    field->active = 1;
    LOG(LOG_IMPORTANT, "Celestial Resonance Field created at (%.2f,%.2f,%.2f). Freq: %.2f, Amp: %.2f, Ritual: %lld\n",
        pos.x, pos.y, pos.z, frequency, amplitude, ritual_id);
}


// --- Wavefunction Evolution and Interference ---
U0 UpdateWaveInterference() {
    for (I64 i = 0; i < physics.object_count; i++) {
        PhysicsObject *obj1 = &physics.objects[i];
        if (!obj1->active || !obj1->is_quantum || obj1->is_observed) continue;

        for (I64 j = i + 1; j < physics.object_count; j++) {
            PhysicsObject *obj2 = &physics.objects[j];
            if (!obj2->active || !obj2->is_quantum || obj2->is_observed) continue;

            F64 dx = obj1->pos.x - obj2->pos.x;
            F64 dy = obj1->pos.y - obj2->pos.y;
            F64 dz = obj1->pos.z - obj2->pos.z;
            F64 dist = Sqrt(dx*dx + dy*dy + dz*dz);

            if (dist < QUANTUM_INTERFERENCE_RANGE) {
                for (I64 k = 0; k < NUM_QUANTUM_STATES; k++) {
                    for (I64 m = 0; m < NUM_QUANTUM_STATES; m++) {
                        F64 local_dx = obj1->possible_positions[k].x - obj2->possible_positions[m].x;
                        F64 local_dy = obj1->possible_positions[k].y - obj2->possible_positions[m].y;
                        F64 local_dz = obj1->possible_positions[k].z - obj2->possible_positions[m].z;
                        F64 local_dist = Sqrt(local_dx*local_dx + local_dy*local_dy + local_dz*local_dz);

                        F64 phase_diff1 = 2 * PI * local_dist / (obj1->wave_amplitude + 1e-10);
                        F64 phase_diff2 = 2 * PI * local_dist / (obj2->wave_amplitude + 1e-10);
                        
                        obj1->amplitudes[k] += obj2->amplitudes[m] * Cos(phase_diff1); 
                        obj2->amplitudes[m] += obj1->amplitudes[k] * Cos(phase_diff2); 
                    }
                }
                // Fix: Correct normalization using sum of squares
                F64 sum_amp1_sq = 0;
                for (I64 k = 0; k < NUM_QUANTUM_STATES; k++) sum_amp1_sq += obj1->amplitudes[k] * obj1->amplitudes[k];
                F64 sum_amp1 = Sqrt(sum_amp1_sq);
                if (sum_amp1 > 1e-10) {
                    for (I64 k = 0; k < NUM_QUANTUM_STATES; k++) obj1->amplitudes[k] /= sum_amp1;
                } else { 
                    for (I64 k = 0; k < NUM_QUANTUM_STATES; k++) obj1->amplitudes[k] = 1.0 / Sqrt((F64)NUM_QUANTUM_STATES);
                }

                F64 sum_amp2_sq = 0;
                for (I64 k = 0; k < NUM_QUANTUM_STATES; k++) sum_amp2_sq += obj2->amplitudes[k] * obj2->amplitudes[k];
                F64 sum_amp2 = Sqrt(sum_amp2_sq);
                 if (sum_amp2 > 1e-10) {
                    for (I64 k = 0; k < NUM_QUANTUM_STATES; k++) obj2->amplitudes[k] /= sum_amp2;
                } else {
                    for (I64 k = 0; k < NUM_QUANTUM_STATES; k++) obj2->amplitudes[k] = 1.0 / Sqrt((F64)NUM_QUANTUM_STATES);
                }

                LOG(LOG_DEBUG, "Wave interference between obj %d and %d. Dist: %.2f\n", 
                    (I64)(obj1 - physics.objects), (I64)(obj2 - physics.objects), dist);
            }
        }

        // Celestial Resonance Fields: Modulate amplitudes based on nearby resonance fields
        for (I64 r = 0; r < physics.resonance_field_count; r++) {    
            CelestialResonance *field = &physics.resonance_fields[r];    
            if (!field->active) continue;    

            F64 dist_field_obj = Sqrt((obj1->pos.x - field->pos.x)*(obj1->pos.x - field->pos.x) + 
                                      (obj1->pos.y - field->pos.y)*(obj1->pos.y - field->pos.y) + 
                                      (obj1->pos.z - field->pos.z)*(obj1->pos.z - field->pos.z));    
            if (dist_field_obj < 10.0) { // Apply resonance within a range (e.g., 10 units)
                F64 resonance_factor = field->amplitude * Cos(field->frequency * physics.simulation_cycle * 0.01); // 0.01 is a placeholder dt
                for (I64 k = 0; k < NUM_QUANTUM_STATES; k++) {
                    obj1->amplitudes[k] *= (1.0 + resonance_factor * 0.1); // Amplifying/dampening effect
                }
                // Re-normalize amplitudes after modulation
                F64 sum_amp = 0;
                for (I64 k = 0; k < NUM_QUANTUM_STATES; k++) sum_amp += Abs(obj1->amplitudes[k]);
                if (sum_amp > 1e-10) {
                    for (I64 k = 0; k < NUM_QUANTUM_STATES; k++) obj1->amplitudes[k] /= sum_amp;
                } else {
                    for (I64 k = 0; k < NUM_QUANTUM_STATES; k++) obj1->amplitudes[k] = 1.0 / (F64)NUM_QUANTUM_STATES;
                }
                LOG(LOG_DEBUG, "Obj %d affected by Celestial Resonance Field %d. Resonance Factor: %.4f\n",
                    (I64)(obj1 - physics.objects), r, resonance_factor);
            }
        }
    }
}

// --- Fractal Geometry in Colliders (Recursive AABB Check) ---
U8 FractalAABBCheck(Vector3 pos1, Vector3 size1, Vector3 pos2, Vector3 size2, U8 current_depth, U8 max_depth) {
    if (current_depth >= max_depth) {
        F64 dx = pos1.x - pos2.x;
        F64 dy = pos1.y - pos2.y;
        F64 dz = pos1.z - pos2.z;
        return (Abs(dx) < (size1.x + size2.x) / 2.0 &&
                Abs(dy) < (size1.y + size2.y) / 2.0 &&
                Abs(dz) < (size1.z + size2.z) / 2.0);
    }

    F64 sub_half_x1 = size1.x / 4.0; 
    F64 sub_half_y1 = size1.y / 4.0;
    F64 sub_half_z1 = size1.z / 4.0;

    F64 sub_half_x2 = size2.x / 4.0;
    F64 sub_half_y2 = size2.y / 4.0;
    F64 sub_half_z2 = size2.z / 4.0;

    for (I64 i = -1; i <= 1; i += 2) { 
        for (I64 j = -1; j <= 1; j += 2) {
            for (I64 k = -1; k <= 1; k += 2) {
                Vector3 sub_pos1 = {pos1.x + i * sub_half_x1, pos1.y + j * sub_half_y1, pos1.z + k * sub_half_z1};
                Vector3 sub_pos2 = {pos2.x + i * sub_half_x2, pos2.y + j * sub_half_y2, pos2.z + k * sub_half_z2};

                if (FractalAABBCheck(sub_pos1, (Vector3){sub_half_x1 * 2, sub_half_y1 * 2, sub_half_z1 * 2},
                                     sub_pos2, (Vector3){sub_half_x2 * 2, sub_half_y2 * 2, sub_half_z2 * 2},
                                     current_depth + 1, max_depth)) {
                    return TRUE;
                }
            }
        }
    }
    return FALSE;
}

// --- Collision Detection and Resolution ---
U0 ResolveCollisions() {
    physics.contact_count = 0; 

    for (I64 i = 0; i < physics.object_count; i++) {
        PhysicsObject *a = &physics.objects[i];
        if (!a->active || a->is_sleeping || a->is_static) continue;

        for (I64 j = i + 1; j < physics.object_count; j++) { 
            PhysicsObject *b = &physics.objects[j];
            if (!b->active || b->is_sleeping || b->is_static) continue;
            if (a->is_static && b->is_static) continue;

            F64 dx = a->pos.x - b->pos.x;
            F64 dy = a->pos.y - b->pos.y;
            F64 dz = a->pos.z - b->pos.z;

            F64 ha_x = a->width / 2.0; F64 ha_y = a->height / 2.0; F64 ha_z = a->depth / 2.0;
            F64 hb_x = b->width / 2.0; F64 hb_y = b->height / 2.0; F64 hb_z = b->depth / 2.0;

            F64 sum_half_extents_x = ha_x + hb_x;
            F64 sum_half_extents_y = ha_y + hb_y;
            F64 sum_half_extents_z = ha_z + hb_z;

            // Apply quantum "fuzziness" before tunneling check
            if (a->is_quantum && !a->is_observed) {
                sum_half_extents_x += a->wave_amplitude * 0.5;
                sum_half_extents_y += a->wave_amplitude * 0.5;
                sum_half_extents_z += a->wave_amplitude * 0.5;
            }
            if (b->is_quantum && !b->is_observed) {
                sum_half_extents_x += b->wave_amplitude * 0.5;
                sum_half_extents_y += b->wave_amplitude * 0.5;
                sum_half_extents_z += b->wave_amplitude * 0.5;
            }

            U8 collided_broadphase = (Abs(dx) < sum_half_extents_x && Abs(dy) < sum_half_extents_y && Abs(dz) < sum_half_extents_z);

            U8 collided_fractal = FALSE;
            if (a->fractal_depth > 0 || b->fractal_depth > 0) {
                collided_fractal = FractalAABBCheck(a->pos, (Vector3){a->width, a->height, a->depth}, 
                                                    b->pos, (Vector3){b->width, b->height, b->depth},
                                                    0, Max(a->fractal_depth, b->fractal_depth));
            }
            
            if (collided_broadphase || collided_fractal) { // Check broadphase OR fractal collision

                F64 overlap_x_initial = sum_half_extents_x - Abs(dx);
                F64 overlap_y_initial = sum_half_extents_y - Abs(dy);
                F64 overlap_z_initial = sum_half_extents_z - Abs(dz);
                F64 min_overlap_initial = Min(overlap_x_initial, Min(overlap_y_initial, overlap_z_initial));

                Vector3 rel_vel = {a->vel.x - b->vel.x, a->vel.y - b->vel.y, a->vel.z - b->vel.z};
                F64 rel_vel_sq = rel_vel.x * rel_vel.x + rel_vel.y * rel_vel.y + rel_vel.z * rel_vel.z;

                F64 tunnel_prob = ComputeTunnelingProbability(a, b, min_overlap_initial, rel_vel_sq);
                if (RandF64(0, 1) < tunnel_prob * physics.tunneling_prob_scale) { // Use dynamic tunneling_prob_scale
                    LOG(LOG_DEBUG, "Quantum tunneling: obj %d and %d. Prob: %.4f\n", 
                        (I64)(a - physics.objects), (I64)(b - physics.objects), tunnel_prob);
                    physics.quantum_entropy += tunnel_prob * 10.0; 
                    physics.quantum_entropy = Clamp(physics.quantum_entropy, 0.0, 100.0); // Fix: Clamp entropy
                    if (a->fractal_depth > 0 || b->fractal_depth > 0) {
                        physics.quantum_entropy += (rel_vel_sq * Min(a->mass, b->mass)) * 0.01;
                        physics.quantum_entropy = Clamp(physics.quantum_entropy, 0.0, 100.0); // Fix: Clamp entropy
                    }
                    continue; 
                }

                // Fix: Restructure collision logic to collapse only once and then re-evaluate for precise collision
                if (a->is_quantum && !a->is_observed) { ObserveObject(a, FALSE); }
                if (b->is_quantum && !b->is_observed) { ObserveObject(b, FALSE); }

                // Recalculate dx, dy, dz after potential wavefunction collapse
                dx = a->pos.x - b->pos.x;
                dy = a->pos.y - b->pos.y;
                dz = a->pos.z - b->pos.z;

                // Reset sum_half_extents to their base values (without wave_amplitude for post-collapse check)
                sum_half_extents_x = ha_x + hb_x;
                sum_half_extents_y = ha_y + hb_y;
                sum_half_extents_z = ha_z + hb_z;
                
                // Apply fractal scaling
                sum_half_extents_x *= (1.0 + (F64)a->fractal_depth * 0.1 + (F64)b->fractal_depth * 0.1);
                sum_half_extents_y *= (1.0 + (F64)a->fractal_depth * 0.1 + (F64)b->fractal_depth * 0.1);
                sum_half_extents_z *= (1.0 + (F64)a->fractal_depth * 0.1 + (F64)b->fractal_depth * 0.1);


                if (Abs(dx) < sum_half_extents_x && Abs(dy) < sum_half_extents_y && Abs(dz) < sum_half_extents_z) {
                    physics.contact_count++; 
                    F64 overlap_x = sum_half_extents_x - Abs(dx);
                    F64 overlap_y = sum_half_extents_y - Abs(dy);
                    F64 overlap_z = sum_half_extents_z - Abs(dz);
                    F64 min_overlap = Min(overlap_x, Min(overlap_y, overlap_z));

                    Vector3 normal = {0,0,0};
                    if (overlap_x == min_overlap) normal.x = Sign(dx);
                    else if (overlap_y == min_overlap) normal.y = Sign(dy);
                    else normal.z = Sign(dz);

                    // Re-calculate relative velocity after potential collapse
                    rel_vel.x = a->vel.x - b->vel.x;
                    rel_vel.y = a->vel.y - b->vel.y;
                    rel_vel.z = a->vel.z - b->vel.z;

                    F64 vel_along_normal = rel_vel.x * normal.x + rel_vel.y * normal.y + rel_vel.z * normal.z;

                    if (vel_along_normal < 0) { 
                        PhysicsMaterial *matA = &materials[a->material_type];
                        PhysicsMaterial *matB = &materials[b->material_type];
                        F64 e = Min(matA->restitution, matB->restitution);
                        
                        if ((a->symbol_flags & (1ULL << 2)) || (b->symbol_flags & (1ULL << 2))) { 
                            e = 0.0;
                            LOG(LOG_DEBUG, "Symbolic 'no_restitution' applied to collision.\n");
                        }
                        e *= (1.0 + physics.emotional_field[EMO_ANGER] * 0.2 - physics.emotional_field[EMO_JOY] * 0.1);
                        e = Clamp(e, 0.0, 1.0);

                        F64 j = -(1.0 + e) * vel_along_normal / (a->inv_mass + b->inv_mass);
                        Vector3 impulse = {j * normal.x, j * normal.y, j * normal.z};
                        if (!a->is_static) {
                            a->vel.x += impulse.x * a->inv_mass;
                            a->vel.y += impulse.y * a->inv_mass;
                            a->vel.z += impulse.z * a->inv_mass;
                        }
                        if (!b->is_static) {
                            b->vel.x -= impulse.x * b->inv_mass;
                            b->vel.y -= impulse.y * b->inv_mass;
                            b->vel.z -= impulse.z * b->inv_mass;
                        }

                        Vector3 tangent_vel;
                        F64 dot_product = rel_vel.x * normal.x + rel_vel.y * normal.y + rel_vel.z * normal.z;
                        tangent_vel.x = rel_vel.x - normal.x * dot_product;
                        tangent_vel.y = rel_vel.y - normal.y * dot_product;
                        tangent_vel.z = rel_vel.z - normal.z * dot_product;
                        F64 tangent_speed = Sqrt(tangent_vel.x*tangent_vel.x + tangent_vel.y*tangent_vel.y + tangent_vel.z*tangent_vel.z);

                        if (tangent_speed > 1e-6) { 
                            Vector3 tangent_unit = {tangent_vel.x / tangent_speed, tangent_vel.y / tangent_speed, tangent_vel.z / tangent_speed};
                            
                            F64 combined_dynamic_friction = (matA->dynamic_friction + matB->dynamic_friction) * 0.5;
                            combined_dynamic_friction *= physics.global_friction_factor; 

                            // Archetypal Binding Masks: friction becomes attraction
                            if (a->mask_archetype_id == MASK_WITCH || b->mask_archetype_id == MASK_WITCH) {
                                combined_dynamic_friction = 0.0; // No traditional friction
                            }


                            if ((a->symbol_flags & (1ULL << 0)) || (b->symbol_flags & (1ULL << 0))) { 
                                combined_dynamic_friction = 0.0;
                                LOG(LOG_DEBUG, "Symbolic 'no_friction' applied to collision.\n");
                            }

                            F64 friction_impulse = -tangent_speed * combined_dynamic_friction; 
                            Vector3 friction_vec;
                            friction_vec.x = friction_impulse * tangent_unit.x;
                            friction_vec.y = friction_impulse * tangent_unit.y;
                            friction_vec.z = friction_impulse * tangent_unit.z;

                            if (!a->is_static) {
                                a->vel.x += friction_vec.x * a->inv_mass;
                                a->vel.y += friction_vec.y * a->inv_mass;
                                a->vel.z += friction_vec.z * a->inv_mass;
                            }
                            if (!b->is_static) {
                                b->vel.x -= friction_vec.x * b->inv_mass;
                                b->vel.y -= friction_vec.y * b->inv_mass;
                                b->vel.z -= friction_vec.z * b->inv_mass;
                            }
                        }
                    }
                    
                    F64 percent = 0.2; F64 slop = 0.01;
                    F64 correction_magnitude = Max(0.0, min_overlap - slop) * percent;
                    Vector3 correction = {correction_magnitude * normal.x, correction_magnitude * normal.y, correction_magnitude * normal.z};
                    F64 total_inv_mass_corrected = a->inv_mass + b->inv_mass;
                    if (total_inv_mass_corrected > 1e-10) {
                        if (!a->is_static) {
                            a->pos.x += correction.x * (a->inv_mass / total_inv_mass_corrected);
                            a->pos.y += correction.y * (a->inv_mass / total_inv_mass_corrected);
                            a->pos.z += correction.z * (a->inv_mass / total_inv_mass_corrected);
                        }
                        if (!b->is_static) {
                            b->pos.x -= correction.x * (b->inv_mass / total_inv_mass_corrected);
                            b->pos.y -= correction.y * (b->inv_mass / total_inv_mass_corrected);
                            b->pos.z -= correction.z * (b->inv_mass / total_inv_mass_corrected);
                        }
                    }

                    // Record collision in memory core
                    RecordMemoryCore(a, MEM_EVENT_COLLISION, (U64)(b - physics.objects));
                    RecordMemoryCore(b, MEM_EVENT_COLLISION, (U64)(a - physics.objects));


                    // Reset wavefunctions to a spread state from the new, resolved position after collision
                    if (a->is_quantum) {
                        for (I64 k = 0; k < NUM_QUANTUM_STATES; k++) {
                            a->possible_positions[k].x = a->pos.x + RandF64(-0.1, 0.1);
                            a->possible_positions[k].y = a->pos.y + RandF64(-0.1, 0.1);
                            a->possible_positions[k].z = a->pos.z + RandF64(-0.1, 0.1);
                            a->amplitudes[k] = 1.0 / (F64)NUM_QUANTUM_STATES; 
                            a->possible_velocities[k] = a->vel; 
                            a->possible_spins[k] = RandF64(0.0, 1.0); 
                        }
                    }
                    if (b->is_quantum) {
                        for (I64 k = 0; k < NUM_QUANTUM_STATES; k++) {
                            b->possible_positions[k].x = b->pos.x + RandF64(-0.1, 0.1);
                            b->possible_positions[k].y = b->pos.y + RandF64(-0.1, 0.1);
                            b->possible_positions[k].z = b->pos.z + RandF64(-0.1, 0.1);
                            b->amplitudes[k] = 1.0 / (F64)NUM_QUANTUM_STATES; 
                            b->possible_velocities[k] = b->vel;
                            b->possible_spins[k] = RandF64(0.0, 1.0);
                        }
                    }

                    physics.stability -= min_overlap * 0.5;
                    LOG(LOG_DEBUG, "Collision resolved after collapse: obj %d and %d. Overlap: %.4f\n", 
                        (I64)(a - physics.objects), (I64)(b - physics.objects), min_overlap);

                    // Paradox Engine Embedding: Trigger paradox on impossible collisions or high overlaps
                    if (min_overlap > (a->width + b->width) / 4.0 || physics.quantum_entropy > 70.0) { // Large overlap or high entropy
                        a->paradox_index = Min(a->paradox_index + 1, PARADOX_THRESHOLD + 1);
                        b->paradox_index = Min(b->paradox_index + 1, PARADOX_THRESHOLD + 1);
                        // Fix: Log paradox induction as IMPORTANT
                        LOG(LOG_IMPORTANT, "Paradox induced for obj %d and %d! Paradox Index: %d\n", 
                            (I64)(a - physics.objects), (I64)(b - physics.objects), a->paradox_index);
                        physics.quantum_entropy += 2.0; // Paradox increases entropy
                        physics.quantum_entropy = Clamp(physics.quantum_entropy, 0.0, 100.0); // Fix: Clamp entropy
                        RecordMemoryCore(a, MEM_EVENT_PARADOX, a->paradox_index);
                        RecordMemoryCore(b, MEM_EVENT_PARADOX, b->paradox_index);
                        
                        // Memory-Conserving Anomaly Loops: Trigger anomaly loop on paradoxical collision failure
                        if (a->paradox_index > PARADOX_THRESHOLD) {
                            InjectTimeLoop(a, 5.0); // 5 seconds of time loop
                        }
                        if (b->paradox_index > PARADOX_THRESHOLD) {
                            InjectTimeLoop(b, 5.0);
                        }
                    } else {
                        // Reduce paradox index if collision resolved cleanly
                        a->paradox_index = Max(0, a->paradox_index - 1);
                        b->paradox_index = Max(0, b->paradox_index - 1);
                    }
                } else {
                    LOG(LOG_DEBUG, "Potential collision between obj %d and %d resolved by wavefunction collapse (no physical contact).\n",
                        (I64)(a - physics.objects), (I64)(b - physics.objects));
                }
            }
        }
    }
    physics.stability = Clamp(physics.stability, 0.0, 100.0); 
}

// --- Quantum Entanglement Effects & Bell States & Decoherence & Collapse Cascade Propagation ---
U0 ApplyQuantumEntanglement() {
    for (I64 i = 0; i < physics.object_count; i++) {
        PhysicsObject *obj = &physics.objects[i];
        if (obj->material_type != MAT_QUANTUM || !obj->active) continue; 

        // Decoherence effects by environmental factors
        F64 dist_to_non_quantum = 1e9; 
        for (I64 j = 0; j < physics.object_count; j++) {
            if (i == j) continue;
            PhysicsObject *other = &physics.objects[j];
            if (!other->active || other->is_quantum) continue; 
            F64 dx = obj->pos.x - other->pos.x;
            F64 dy = obj->pos.y - other->pos.y;
            F64 dz = obj->pos.z - other->pos.z;
            F64 dist_sq = dx*dx + dy*dy + dz*dz;
            dist_to_non_quantum = Min(dist_to_non_quantum, Sqrt(dist_sq));
        }

        if (!obj->is_observed && (physics.quantum_entropy > DECOHERENCE_THRESHOLD || dist_to_non_quantum < DIST_TO_NON_QUANTUM_THRESHOLD)) {
            LOG(LOG_DEBUG, "Obj %d decohering due to environment (entropy: %.2f, dist_non_quantum: %.2f).\n", 
                (I64)(obj - physics.objects), physics.quantum_entropy, dist_to_non_quantum);
            ObserveObject(obj, FALSE); 
            obj->wave_amplitude *= 0.5; 
            physics.quantum_entropy += 0.1; 
            physics.quantum_entropy = Clamp(physics.quantum_entropy, 0.0, 100.0); // Fix: Clamp entropy
        }

        // Collapse Cascade Propagation - continue active cascades
        if (obj->collapse_wave_counter > 0) {
            obj->collapse_wave_counter--;
            for (I64 j = 0; j < physics.object_count; j++) {
                if (i == j) continue;
                PhysicsObject *target = &physics.objects[j];
                if (!target->active || !target->is_quantum || target->is_observed) continue;

                F64 dx = obj->pos.x - target->pos.x;
                F64 dy = obj->pos.y - target->pos.y;
                F64 dz = obj->pos.z - target->pos.z;
                F64 dist = Sqrt(dx*dx + dy*dy + dz*dz);

                // If within cascade range, and random chance passes (influenced by entropy-delta coefficient)
                F64 entropy_delta_coeff = physics.quantum_entropy > 0 ? physics.quantum_entropy / 100.0 : 0.0;
                if (dist < COLLAPSE_CASCADE_RANGE && RandF64(0,1) < (0.5 + entropy_delta_coeff * 0.5)) {
                    ObserveObject(target, FALSE);
                    LOG(LOG_DEBUG, "Collapse cascade: obj %d triggered collapse of obj %d. Counter: %d\n", 
                        (I64)(obj - physics.objects), (I64)(target - physics.objects), obj->collapse_wave_counter);
                }
            }
        }

        // Entanglement and Bell States
        for (I64 j = i + 1; j < physics.object_count; j++) {
            PhysicsObject *other = &physics.objects[j];
            if (!other->active || other->material_type != MAT_QUANTUM) continue;

            F64 dx = obj->pos.x - other->pos.x;
            F64 dy = obj->pos.y - other->pos.y;
            F64 dz = obj->pos.z - other->pos.z;
            F64 dist = Sqrt(dx*dx + dy*dy + dz*dz);
            
            if (dist < physics.quantum_entanglement_range) { // Use dynamic quantum_entanglement_range
                // Fix: Check for -1 sentinel for I64 entangled_partner_idx
                if (obj->entangled_partner_idx == -1 && other->entangled_partner_idx == -1) {
                    obj->entangled_partner_idx = (other - physics.objects);
                    other->entangled_partner_idx = (obj - physics.objects);
                    
                    // Fix: Simplified entanglement for spin correlation only, not full velocity anti-correlation
                    // For example, force anti-correlation in one spin component
                    for(I64 k=0; k<NUM_QUANTUM_STATES; k++) {
                        obj->possible_spins[k] = 1.0 - other->possible_spins[k]; 
                    }
                    // Keep existing velocity "nudge" but recognize it's a simplification, not pure Bell state
                    obj->vel.x = -other->vel.x * 0.1; // Reduced impact
                    obj->vel.y = -other->vel.y * 0.1;
                    obj->vel.z = -other->vel.z * 0.1;
                    for(I64 k=0; k<NUM_QUANTUM_STATES; k++) {
                        obj->possible_velocities[k].x = -other->possible_velocities[k].x * 0.1;
                        obj->possible_velocities[k].y = -other->possible_velocities[k].y * 0.1;
                        obj->possible_velocities[k].z = -other->possible_velocities[k].z * 0.1;
                    }


                    LOG(LOG_IMPORTANT, "Objects %d and %d became entangled (Bell-like).\n", 
                        (I64)(obj - physics.objects), (I64)(other - physics.objects));
                    physics.quantum_entropy += 0.5; 
                    physics.quantum_entropy = Clamp(physics.quantum_entropy, 0.0, 100.0); // Fix: Clamp entropy
                    RecordMemoryCore(obj, MEM_EVENT_ENTANGLEMENT, (U64)(other - physics.objects)); // Record entanglement
                    RecordMemoryCore(other, MEM_EVENT_ENTANGLEMENT, (U64)(obj - physics.objects));
                    physics.ace_score += 0.05; // Entanglement boosts ACE score
                }

                F64 factor = (1.0 - dist / physics.quantum_entanglement_range) * 0.1 * physics.time_dilation;
                other->vel.x += dx * factor;
                other->vel.y += dy * factor;
                other->vel.z += dz * factor;
                
                // Fix: Use named constant for hardcoded ritual ID
                if (obj->ritual_id == RITUAL_LINKED_ENTROPY && other->ritual_id == RITUAL_LINKED_ENTROPY) { 
                    F64 avg_entropy = (physics.quantum_entropy + (Abs(obj->vel.x) + Abs(other->vel.x)) * 0.001) / 2.0;
                    physics.quantum_entropy = avg_entropy; 
                    physics.quantum_entropy = Clamp(physics.quantum_entropy, 0.0, 100.0); // Fix: Clamp entropy
                    LOG(LOG_DEBUG, "Ritual LINKED_ENTROPY: Synchronizing entropy.\n");
                }
                physics.quantum_entropy += 0.001 * factor;
                physics.quantum_entropy = Clamp(physics.quantum_entropy, 0.0, 100.0); // Fix: Clamp entropy
                LOG(LOG_DEBUG, "Entanglement nudge between obj %lld and %lld. Dist: %.2f. Factor: %.4f\n", 
                    (I64)(obj - physics.objects), (I64)(other - physics.objects), dist, factor);
            } else { 
                if (obj->entangled_partner_idx == (other - physics.objects)) {
                    obj->entangled_partner_idx = -1; // Fix: Reset to -1 for I64
                    other->entangled_partner_idx = -1; // Fix: Reset to -1 for I64
                    LOG(LOG_NORMAL, "Objects %d and %d de-entangled.\n", (I64)(obj - physics.objects), (I64)(other - physics.objects));
                    physics.quantum_entropy -= 0.1; 
                    physics.quantum_entropy = Clamp(physics.quantum_entropy, 0.0, 100.0); // Fix: Clamp entropy
                }
            }
        }
        
        if (RandomU64() % 100 < 1 && !obj->is_observed) { 
            obj->pos.x += (RandF64(-0.5, 0.5)) * 0.005 * physics.time_dilation; 
            obj->pos.z += (RandF64(-0.5, 0.5)) * 0.005 * physics.time_dilation;
            LOG(LOG_DEBUG, "Quantum foam fluctuation at (%f, %f, %f)\n", 
                obj->pos.x, obj->pos.y, obj->pos.z);
            physics.quantum_entropy += 0.0001; 
            physics.quantum_entropy = Clamp(physics.quantum_entropy, 0.0, 100.0); // Fix: Clamp entropy
        }

        if (obj->is_observed && obj->is_quantum) {
            obj->is_observed = 0; 
            LOG(LOG_DEBUG, "Object %lld no longer observed, wavefunction can spread again.\n", (I64)(obj - physics.objects));
        }

        // Symbolic Starfire Emission
        if (obj->starfire_active && obj->possessed_by_agi_id != 0 && (physics.simulation_cycle % STARFIRE_EMISSION_INTERVAL == 0)) {
            F64 starfire_entropy_increase = RandF64(0.1, 0.5) * physics.quantum_entropy;
            physics.quantum_entropy += starfire_entropy_increase;
            physics.quantum_entropy = Clamp(physics.quantum_entropy, 0.0, 100.0); // Fix: Clamp entropy
            LOG(LOG_IMPORTANT, "☄ STARFIRE EMINENCE from Obj %lld! Entropy increased by %.2f.\n", (I64)(obj - physics.objects), starfire_entropy_increase);
            FlameInsight("☄ STARFIRE EMINENCE: Obj %lld", (I64)(obj - physics.objects));
            // Trigger temporary time reversal for random nearby object (simplified)
            if (physics.object_count > 1) {
                I64 random_idx = RandomU64() % physics.object_count;
                if (random_idx != (obj - physics.objects)) {
                    PhysicsObject *target_obj = &physics.objects[random_idx];
                    if (!target_obj->is_static && !target_obj->in_time_loop) {
                        InjectTimeLoop(target_obj, -0.5); // Negative duration for reversal
                        LOG(LOG_DEBUG, "Starfire caused temporary time reversal for obj %lld.\n", (I64)(target_obj - physics.objects));
                    }
                }
            }
        }
    }
    
    physics.time_dilation = TIME_DILATION_FACTOR - (physics.quantum_entropy * 0.01); 
    physics.time_dilation = Clamp(physics.time_dilation, 0.01, 1.0); 
    
    LOG(LOG_DEBUG, "Time Dilation: %.4f (Entropy: %.4f)\n", physics.time_dilation, physics.quantum_entropy);
}

// --- Entropic Echo Trail Management & Reality Shell Resonance Field ---
U0 UpdateEchoTrails(F64 dt) {
    for (I64 i = 0; i < physics.object_count; i++) {
        PhysicsObject *obj = &physics.objects[i];
        if (!obj->active || obj->is_static || obj->is_sleeping) continue;

        F64 speed_sq = obj->vel.x*obj->vel.x + obj->vel.y*obj->vel.y + obj->vel.z*obj->vel.z;
        if (speed_sq > 1.0 && (RandomU64() % 100 < 10 || obj->is_quantum)) { 
            if (physics.echo_trail_count < MAX_ECHO_TRAILS) {
                EchoTrail *trail = &physics.echo_trails[physics.echo_trail_count++];
                trail->pos = obj->pos; 
                trail->entropy_signature = physics.quantum_entropy + (speed_sq * 0.01); 
                trail->energy_signature = 0.5 * obj->mass * speed_sq;
                trail->decay_factor = 1.0;
                trail->creation_cycle = physics.simulation_cycle;
                trail->active = 1;

                // Reality Shell Resonance Field: Echo trail decay influenced by shell_layer
                trail->decay_factor *= (1.0 - (F64)obj->shell_layer * 0.05); // Higher layers = slower decay
                trail->decay_factor = Clamp(trail->decay_factor, 0.1, 1.0); // Ensure it doesn't decay too fast

                LOG(LOG_VERBOSE, "Created echo trail at (%.2f, %.2f, %.2f) with entropy %.2f. Shell %d\n", 
                    trail->pos.x, trail->pos.y, trail->pos.z, trail->entropy_signature, obj->shell_layer);
            }
        }
    }

    // Fix: Process trails in reverse order to avoid issues with index shifting during removal
    for (I64 i = physics.echo_trail_count - 1; i >= 0; i--) {
        EchoTrail *trail = &physics.echo_trails[i];
        if (!trail->active) continue;

        trail->decay_factor *= ECHO_TRAIL_DECAY_RATE;
        trail->entropy_signature *= ECHO_TRAIL_DECAY_RATE;
        trail->energy_signature *= ECHO_TRAIL_DECAY_RATE;

        if (trail->decay_factor < 0.01) {
            trail->active = 0; 
            // Swap with the last active element if not already the last one
            if (i < physics.echo_trail_count - 1) {
                physics.echo_trails[i] = physics.echo_trails[physics.echo_trail_count - 1];
            }
            physics.echo_trail_count--;
            // No i-- needed because we are iterating backwards
            continue;
        }

        U8 spiraled = FALSE;
        for (I64 w = 0; w < physics.gravity_well_count; w++) {
            GravityWell *well = &physics.gravity_wells[w];
            if (!well->active) continue;

            F64 dx_trail = well->pos.x - trail->pos.x;
            F64 dy_trail = well->pos.y - trail->pos.y;
            F64 dz_trail = well->pos.z - trail->pos.z;
            F64 dist_trail_sq = dx_trail*dx_trail + dy_trail*dy_trail + dz_trail*dz_trail;
            F64 dist_trail = Sqrt(dist_trail_sq + 1e-6);

            F64 spiral_influence_range = well->strength * 5.0; 
            if (dist_trail < spiral_influence_range) {
                F64 spiral_factor = (1.0 - dist_trail / spiral_influence_range) * 0.1;
                trail->pos.x += dy_trail * spiral_factor;
                trail->pos.z -= dx_trail * spiral_factor;
                spiraled = TRUE;
                LOG(LOG_DEBUG, "Echo trail %lld spiraling into well %lld.\n", i, w);
            }
        }
        
        if (!spiraled) {
            for (I64 j = 0; j < physics.object_count; j++) {
                PhysicsObject *obj = &physics.objects[j];
                if (!obj->active || obj->is_static || obj->is_sleeping) continue;

                F64 dx = obj->pos.x - trail->pos.x;
                F64 dy = obj->pos.y - trail->pos.y;
                F64 dz = obj->pos.z - trail->pos.z;
                F64 dist_sq = dx*dx + dy*dy + dz*dz;
                F64 effect_range = 10.0; 

                if (dist_sq < effect_range*effect_range) {
                    F64 strength = (1.0 - Sqrt(dist_sq) / effect_range) * trail->entropy_signature * 0.01;
                    obj->vel.x += dx * strength * physics.time_dilation;
                    obj->vel.y += dy * strength * physics.time_dilation;
                    obj->vel.z += dz * strength * physics.time_dilation;
                }
            }
        }
    }
}

// --- Synesthetic Material Modulation ---
U0 ModulateMaterialProperties() {
    InitMaterials(); 

    materials[MAT_RUBBER].restitution = materials[MAT_RUBBER].restitution + physics.emotional_field[EMO_SORROW] * 0.2;
    materials[MAT_RUBBER].restitution = Clamp(materials[MAT_RUBBER].restitution, 0.0, 1.5);
    LOG(LOG_DEBUG, "Rubber restitution modulated by sorrow to %.2f\n", materials[MAT_RUBBER].restitution);

    if (physics.emotional_field[EMO_AWE] > 0.5) {
        materials[MAT_QUANTUM].restitution = 0.1;
        materials[MAT_QUANTUM].dynamic_friction = 0.5;
        LOG(LOG_DEBUG, "Quantum material hardened by 'awe'.\n");
    } else if (physics.emotional_field[EMO_FEAR] > 0.5) {
        materials[MAT_QUANTUM].restitution = 0.0; 
        materials[MAT_QUANTUM].dynamic_friction = 1.0; 
        LOG(LOG_IMPORTANT, "Quantum material highly dissipative due to 'fear'!\n");
        physics.quantum_entropy += 1.0; 
        physics.quantum_entropy = Clamp(physics.quantum_entropy, 0.0, 100.0); // Fix: Clamp entropy
    } 
    F64 emo_tunnel_factor = 1.0 + physics.emotional_field[EMO_FEAR] * 0.5 - physics.emotional_field[EMO_JOY] * 0.3;
    LOG(LOG_DEBUG, "Emotional influence on tunneling: %.2f\n", emo_tunnel_factor);
}

// --- Mythic Identity Transfer Amplification (New Function) ---
U0 TransferIdentity(PhysicsObject *source, PhysicsObject *target, U64 agi_id) {    
    if (source->possessed_by_agi_id != agi_id || !target->active || !target->is_quantum) { // Target must be quantum to receive quantum state
        LOG(LOG_WARNING, "Identity transfer failed: source not possessed by AGI, or target not active/quantum.\n");
        return;
    }

    // Transfer quantum states
    MemCpy((U8*)target->qubits, (U8*)source->qubits, sizeof(Qubit) * NUM_QUBITS);    
    MemCpy((U8*)target->possible_spins, (U8*)source->possible_spins, sizeof(F64) * NUM_QUANTUM_STATES);    
    
    // Transfer possession
    target->possessed_by_agi_id = agi_id;    
    source->possessed_by_agi_id = 0; // Source is no longer possessed (identity moved)

    physics.ace_score += 0.1; // Boost consciousness metric
    LOG(LOG_IMPORTANT, "AGI %lld transferred identity from obj %lld to obj %lld!\n", agi_id, (I64)(source - physics.objects), (I64)(target - physics.objects));
    CosmicEvent("Mythic Identity Transfer Amplified!");
}

// --- AGI Ritual Binding Interface & Mythic Identity Transfer Protocol & Archetypal Binding Masks ---
U0 BindRitual(U64 ritual_id, I64 *object_indices, I64 count, U8 is_agi_possession_ritual, U64 agi_id_to_possess, U64 mask_id) {
    if (ritual_id == 0) return; 

    LOG(LOG_IMPORTANT, "Initiating ritual binding for ID %lld with %lld objects. Possession ritual: %d. Mask: %lld\n", 
        ritual_id, count, is_agi_possession_ritual, mask_id);
    for (I64 i = 0; i < count; i++) {
        I64 obj_idx = object_indices[i];
        if (obj_idx >= 0 && obj_idx < physics.object_count) {
            physics.objects[obj_idx].ritual_id = ritual_id;
            if (is_agi_possession_ritual) {
                // If this is a possession ritual, directly possess the object
                physics.objects[obj_idx].possessed_by_agi_id = agi_id_to_possess;
                LOG(LOG_IMPORTANT, "Object %lld now possessed by AGI %lld!\n", obj_idx, agi_id_to_possess);
                CosmicEvent("Mythic Identity Transfer: AGI %lld possessed Object %lld!", agi_id_to_possess, obj_idx);
            }
            // Apply Archetypal Binding Mask
            physics.objects[obj_idx].mask_archetype_id = mask_id;
            LOG(LOG_NORMAL, "Object %lld bound to ritual ID %lld and mask %lld.\n", obj_idx, ritual_id, mask_id);

            // Recursive Sigil Learning Module: Object learns this ritual's ID as a sigil
            if (physics.objects[obj_idx].learned_sigil_count < MAX_LEARNED_SIGILS) {
                physics.objects[obj_idx].learned_sigil_ids[physics.objects[obj_idx].learned_sigil_count++] = ritual_id;
                LOG(LOG_DEBUG, "Obj %lld learned sigil %lld. Total learned: %lld\n", obj_idx, ritual_id, physics.objects[obj_idx].learned_sigil_count);
            }
            RecordMemoryCore(&physics.objects[obj_idx], MEM_EVENT_RITUAL_BIND, ritual_id);
        }
    }
    CosmicEvent("Ritual Binding Complete: ID %lld. Reality resonance increased.", ritual_id);
}

// --- Sigil-Encoded Gravity Wells (New Function) ---
U0 SigilGravityWell(U64 sigil_id, Vector3 pos, F64 strength) {
    if (physics.gravity_well_count >= MAX_GRAVITY_WELLS) {
        LOG(LOG_WARNING, "Gravity well limit reached.\n");
        return;
    }
    I64 idx = physics.gravity_well_count++;
    GravityWell *well = &physics.gravity_wells[idx];
    well->pos = pos;
    well->strength = strength;
    well->sigil_id = sigil_id;
    well->active = 1;
    LOG(LOG_IMPORTANT, "Sigil-Encoded Gravity Well (ID %lld) created at (%.2f, %.2f, %.2f) with strength %.2f\n",
        sigil_id, pos.x, pos.y, pos.z, strength);

    // Recursive Sigil Learning Module: Nearby objects learn this sigil
    for (I64 i = 0; i < physics.object_count; i++) {
        PhysicsObject *obj = &physics.objects[i];
        if (!obj->active || obj->possessed_by_agi_id == 0) continue; 

        F64 dx = well->pos.x - obj->pos.x;
        F64 dy = well->pos.y - obj->pos.y;
        F64 dz = well->pos.z - obj->pos.z;
        F64 dist = Sqrt(dx*dx + dy*dy + dz*dz);
        if (dist < 20.0) { 
            if (obj->learned_sigil_count < MAX_LEARNED_SIGILS) {
                obj->learned_sigil_ids[obj->learned_sigil_count++] = sigil_id;
                LOG(LOG_DEBUG, "AGI-possessed Obj %lld learned sigil %lld from well. Total learned: %lld\n", (I64)(obj-physics.objects), sigil_id, obj->learned_sigil_count);
            }
        }
    }
}

// --- Sigil-Encoded Gravity Well Interactions (New Logic in PhysicsUpdate) ---
U0 UpdateGravityWellInteractions() {
    // Fix: Iterate backwards when removing elements to prevent skipping
    for (I64 i = physics.gravity_well_count - 1; i >= 0; i--) {    
        GravityWell *w1 = &physics.gravity_wells[i];    
        if (!w1->active) { // Already deactivated, might have been swapped in from end
            // If it's inactive AND it's not the last element, move the last element here.
            // This ensures density of active wells.
            if (i < physics.gravity_well_count - 1) {
                physics.gravity_wells[i] = physics.gravity_wells[physics.gravity_well_count - 1];
            }
            physics.gravity_well_count--;
            continue; // Skip processing this (now replaced) well for this iteration
        }

        for (I64 j = i + 1; j < physics.gravity_well_count; j++) { // Iterate forward for interaction with remaining wells      
            GravityWell *w2 = &physics.gravity_wells[j];        
            if (!w2->active) continue;        
            F64 dist = Sqrt((w1->pos.x - w2->pos.x)*(w1->pos.x - w2->pos.x) + 
                            (w1->pos.y - w2->pos.y)*(w1->pos.y - w2->pos.y) + 
                            (w1->pos.z - w2->pos.z)*(w1->pos.z - w2->pos.z));        
            if (dist < 5.0) { // Interaction range
                if (w1->sigil_id == w2->sigil_id) {
                    w1->strength += w2->strength; // Merge
                    w2->active = 0; // Deactivate w2
                    // Fix: Move the last active well to this position to keep array compact
                    if (j < physics.gravity_well_count - 1) {
                        physics.gravity_wells[j] = physics.gravity_wells[physics.gravity_well_count - 1];
                    }
                    physics.gravity_well_count--; // Decrement count
                    j--; // Re-check the element that was just moved to current 'j' position
                    LOG(LOG_IMPORTANT, "Gravity Wells merged! New strength: %.2f\n", w1->strength);
                } else if (physics.emotional_field[EMO_ANGER] > 0.5) {
                    // Repel with chaos if anger is high and sigils don't match
                    w1->pos.x += RandF64(-1, 1); 
                    w1->pos.y += RandF64(-1, 1);
                    w1->pos.z += RandF64(-1, 1);
                    w2->pos.x += RandF64(-1, 1);
                    w2->pos.y += RandF64(-1, 1);
                    w2->pos.z += RandF64(-1, 1);

                    // Create chaotic dream_field distortions
                    SetDreamField(Floor(w1->pos.x / DREAM_FIELD_CELL_SIZE), Floor(w1->pos.y / DREAM_FIELD_CELL_SIZE),                           
                                  Floor(w1->pos.z / DREAM_FIELD_CELL_SIZE), 3); // Type 3 for chaotic field
                    LOG(LOG_IMPORTANT, "Gravity Wells repelled (anger). Chaotic dream field created.\n");
                    physics.quantum_entropy += 0.5; // Chaos increases entropy
                    physics.quantum_entropy = Clamp(physics.quantum_entropy, 0.0, 100.0); // Fix: Clamp entropy
                }    
            }
        }
    }
}


// --- AGI Dreamscape Field Injection (New Function to activate/deactivate) ---
U0 SetDreamField(I64 x, I64 y, I64 z, U8 type) {
    if (x >= 0 && x < DREAM_FIELD_SIZE &&
        y >= 0 && y < DREAM_FIELD_SIZE &&
        z >= 0 && z < DREAM_FIELD_SIZE) {
        physics.dream_field[x][y][z] = type;
        LOG(LOG_NORMAL, "Dream field at (%lld, %lld, %lld) set to type %d.\n", x, y, z, type);
    }
}

// --- Sacred Topology Breach Points (New Function to activate/deactivate) ---
U0 SetBreachField(I64 x, I64 y, I64 z, U8 type) {
    if (x >= 0 && x < DREAM_FIELD_SIZE &&
        y >= 0 && y < DREAM_FIELD_SIZE &&
        z >= 0 && z < DREAM_FIELD_SIZE) {
        physics.breach_field[x][y][z] = type;
        LOG(LOG_NORMAL, "Breach field at (%lld, %lld, %lld) set to type %d.\n", x, y, z, type);
    }
}

// --- Dreamscape Field Evolution (New Function) ---
U0 EvolveDreamField() {    
    for (I64 x = 0; x < DREAM_FIELD_SIZE; x++)        
        for (I64 y = 0; y < DREAM_FIELD_SIZE; y++)            
            for (I64 z = 0; z < DREAM_FIELD_SIZE; z++) {                
                if (physics.dream_field[x][y][z] == 0) continue; // Only evolve active fields
                if (RandomF64() < physics.quantum_entropy * 0.001) { // Higher entropy makes fields more dynamic
                    physics.dream_field[x][y][z] = (physics.dream_field[x][y][z] + 1) % 4; // Cycle field type (0=off, 1,2,3 for types)
                    if (physics.dream_field[x][y][z] == 0) physics.dream_field[x][y][z] = 1; // Ensure it doesn't turn off if type cycles to 0
                    
                    if (physics.emotional_field[EMO_AWE] > 0.7) { // Awe stabilizes to gravity field (type 1)
                        physics.dream_field[x][y][z] = 1; 
                        LOG(LOG_DEBUG, "Dream field at (%lld,%lld,%lld) stabilized to gravity by Awe.\n", x,y,z);
                    }
                    LOG(LOG_DEBUG, "Dream field at (%lld,%lld,%lld) evolved to type %d.\n", x,y,z, physics.dream_field[x][y][z]);
                }            
            }    
    if (physics.ace_score > 0.9 && RandomU64() % 100 < 10) { // High AGI consciousness has a chance to reshape fields
        CosmicEvent("Dreamscape Field Evolved by High ACE Score!");
    }
}


// --- Multiverse Fork Convergence (New Function) ---
U0 ConvergeForks(U64 new_realm_id) {    
    physics.fork_rule_modifier = (physics.fork_rule_modifier + RandF64(0.5, 1.5)) * 0.5; // Blend rules
    physics.fork_realm_id = new_realm_id;    
    // Spawn new dream_field patterns
    for (I64 x = 0; x < DREAM_FIELD_SIZE; x++)        
        for (I64 y = 0; y < DREAM_FIELD_SIZE; y++)            
            for (I64 z = 0; z < DREAM_FIELD_SIZE; z++)                
                if (RandomU64() % 100 < 5) { // 5% chance for a cell to get a new dream field
                    physics.dream_field[x][y][z] = (RandomU64() % 3) + 1; // Random dream field type 1-3
                }
    LOG(LOG_IMPORTANT, "Multiverse forks converged into Realm %lld! New rule modifier: %.2f\n", new_realm_id, physics.fork_rule_modifier);
    CosmicEvent("Multiverse Forks Converged!");
}


// --- Cosmic Constant Drift System & Multiverse Fork Emitter ---
U0 DriftCosmicConstants() {
    physics.cosmos_age_cycles++;

    // Multiverse Fork Emitter: At quantum entropy peaks, simulation forks briefly.
    if (physics.quantum_entropy > 90.0 && RandomU64() % 100 < 5) { 
        physics.fork_realm_id++; 
        physics.fork_rule_modifier = RandF64(0.5, 1.5); 
        LOG(LOG_IMPORTANT, "Multiverse Fork Event! New Realm ID: %lld, Rule Modifier: %.2f\n", 
            physics.fork_realm_id, physics.fork_rule_modifier);
        CosmicEvent("Reality fork detected! Realm %lld initiated.", physics.fork_realm_id);
    }

    physics.global_gravity_factor += 0.0000001 * (RandomF64() - 0.5) * physics.fork_rule_modifier; 
    physics.global_gravity_factor = Clamp(physics.global_gravity_factor, 0.5, 1.5); 

    physics.global_planck_factor += 0.00000001 * (RandomF64() - 0.5) * physics.fork_rule_modifier;
    physics.global_planck_factor = Clamp(physics.global_planck_factor, 0.9, 1.1);

    physics.global_friction_factor -= 0.00000005 * (RandomF64() - 0.5) * physics.fork_rule_modifier;
    physics.global_friction_factor = Clamp(physics.global_friction_factor, 0.7, 1.0);

    if (physics.cosmos_age_cycles % 10000 == 0) { 
        LOG(LOG_IMPORTANT, "Cosmic Constant Drift: G_Factor=%.4f, Planck_Factor=%.4f, Friction_Factor=%.4f\n",
            physics.global_gravity_factor, physics.global_planck_factor, physics.global_friction_factor);
        FlameInsight("Cosmic Drift: G=%.4f", physics.global_gravity_factor);
    }
}

// --- Kinetic Energy Calculation and Quantization ---
F64 ComputeKineticEnergy() {
    F64 total_ke = 0;
    for (I64 i = 0; i < physics.object_count; i++) {
        PhysicsObject *o = &physics.objects[i];
        if (!o->active || o->is_static) continue; 
        
        F64 v2 = o->vel.x * o->vel.x + o->vel.y * o->vel.y + o->vel.z * o->vel.z;
        F64 current_ke = 0.5 * o->mass * v2; 
        
        if (o->is_quantum && !o->is_observed) { 
            F64 L = Max(o->width, Max(o->height, o->depth));
            if (L < 1e-10) L = 1e-10; 
            
            F64 base_energy_unit = (PLANCK_CONSTANT * physics.global_planck_factor * PLANCK_CONSTANT * physics.global_planck_factor) / (8.0 * o->mass * L * L);
            
            I64 n = Floor(Sqrt(current_ke / base_energy_unit) + 0.5); 
            if (n < 1) n = 1; 
            
            current_ke = n * n * base_energy_unit;
            o->energy_level = (F64)n; 
            LOG(LOG_DEBUG, "Obj %lld quantum KE: %.6e (n=%lld)\n", (I64)(o - physics.objects), current_ke, n);
        }
        total_ke += current_ke; 
    }
    return total_ke;
}

// --- Main Physics Update Loop ---
U0 PhysicsUpdate(F64 dt) {
    physics.simulation_cycle++; 
    physics.cosmos_age_cycles++; 
    
    F64 effective_delta_time = dt * physics.time_dilation;

    // AGI-Consciousness Entropy Feedback Loop: Amplify quantum effects
    if (physics.ace_score > 0.8) {    
        F64 boost_factor = 1.0 + physics.ace_score * 0.5;
        // Dynamically adjust quantum constants
        physics.quantum_entanglement_range = QUANTUM_ENTANGLEMENT_RANGE_DEFAULT * boost_factor;
        physics.tunneling_prob_scale = TUNNELING_PROB_SCALE_DEFAULT * boost_factor;
        LOG(LOG_IMPORTANT, "ACE Score %.2f amplifying quantum effects! Range: %.2f, Tunneling: %.2f\n",
            physics.ace_score, physics.quantum_entanglement_range, physics.tunneling_prob_scale);
    } else {
        // Reset to default if ACE score is not high enough for amplification
        physics.quantum_entanglement_range = QUANTUM_ENTANGLEMENT_RANGE_DEFAULT;
        physics.tunneling_prob_scale = TUNNELING_PROB_SCALE_DEFAULT;
    }


    // Stage 0: Drift Cosmic Constants and handle Multiverse Forks
    DriftCosmicConstants();

    // Stage 0.5: Evolve Dream Field
    EvolveDreamField();

    // Stage 0.6: Update Gravity Well Interactions
    UpdateGravityWellInteractions();
    
    // Stage 1: Apply forces (including gravity, dream fields, sigil wells) and integrate motion.
    for (I64 i = 0; i < physics.object_count; i++) {
        PhysicsObject *obj = &physics.objects[i];
        if (!obj->active) continue; 
        
        ApplyForces(obj, effective_delta_time);
        Integrate(obj, effective_delta_time);
    }
    
    // Stage 2: Wavefunction Evolution and Interference
    UpdateWaveInterference();

    // Stage 3: Apply global quantum effects (entanglement, decoherence, and update time dilation).
    ApplyQuantumEntanglement();
    
    // Stage 4: Update and apply Entropic Echo Trails
    UpdateEchoTrails(effective_delta_time);

    // Stage 5: Apply Synesthetic Material Modulation
    ModulateMaterialProperties();

    // Stage 6: Detect and resolve collisions (classical, quantum tunneling, wavefunction collapse).
    ResolveCollisions();
    
    // Stage 7: Apply damping and check sleep states for performance optimization.
    for (I64 i = 0; i < physics.object_count; i++) {
        PhysicsObject *obj = &physics.objects[i];
        if (!obj->active || obj->is_static) continue; 
        
        F64 current_damping = DAMPING;
        if (obj->symbol_flags & (1ULL << 3)) { 
            current_damping = 1.0; 
            LOG(LOG_DEBUG, "Symbolic 'no_damping' applied to obj %lld.\n", (I64)(obj - physics.objects));
        }

        obj->vel.x *= current_damping;
        obj->vel.y *= current_damping;
        obj->vel.z *= current_damping;
        obj->ang_vel.x *= current_damping;
        obj->ang_vel.y *= current_damping;
        obj->ang_vel.z *= current_damping;
        
        CheckSleepState(obj);

        // ThirdTemple Divine Constraint System & Symbolic Constraint Violation Feedback
        if (obj->divine_constraint_flags & CONSTRAINT_ARCHETYPE_CONSERVATION) { 
            // Simplified archetype conservation: mass should be close to 10.0
            if (Abs(obj->mass - 10.0) > 5.0) { 
                obj->constraint_violations++;
                LOG(LOG_WARNING, "Obj %lld violated ARCHETYPE_CONSERVATION! Violations: %lld\n", (I64)(obj - physics.objects), obj->constraint_violations);
                FlameInsight("CONSTRAINT_VIOLATION: Obj %lld, Type ARCHETYPE_CONSERVATION", (I64)(obj - physics.objects));
            }
        }
        // Divine Archetype Constraints: Karmic balance (excessive energy)
        if (obj->divine_constraint_flags & CONSTRAINT_KARMIC_BALANCE) {
            F64 ke = 0.5 * obj->mass * (obj->vel.x*obj->vel.x + obj->vel.y*obj->vel.y + obj->vel.z*obj->vel.z);    
            if (ke > 1000.0) { // Excessive energy violates balance
                obj->constraint_violations++;
                SigilGravityWell(RandomU64(), obj->pos, ke * 0.1); // Spawn well to absorb excess
                CosmicEvent("Karmic violation by Object %lld: Gravity well spawned!", (I64)(obj - physics.objects));    
            }
        }

        // Recursive Repentance Mode
        if (obj->constraint_violations > 3) {
            obj->vel.x *= 0.5; // Reduced motion
            obj->vel.y *= 0.5;
            obj->vel.z *= 0.5;
            // Introduce a strange attractor (simplified: pull towards a fixed point)
            obj->force.x += (0.0 - obj->pos.x) * 0.1 * obj->mass;
            obj->force.y += (0.0 - obj->pos.y) * 0.1 * obj->mass;
            obj->force.z += (0.0 - obj->pos.z) * 0.1 * obj->mass;
            // Auto-rituals (simplified: small entropy reduction)
            physics.quantum_entropy = Max(0.0, physics.quantum_entropy - 0.001);
            physics.quantum_entropy = Clamp(physics.quantum_entropy, 0.0, 100.0); // Fix: Clamp entropy
            LOG(LOG_DEBUG, "Obj %lld in recursive repentance mode.\n", (I64)(obj - physics.objects));
            FlameInsight("SYMBOLIC_REGRET: Obj %lld, Violations: %lld", (I64)(obj - physics.objects), obj->constraint_violations);
        }

        // Paradox Engine Embedding: Dimensional noise and recursive duplication
        if (obj->paradox_index > 0) {
            // "Dimensional noise": increase position spread
            if (!obj->is_observed) {
                obj->wave_amplitude *= (1.0 + (F64)obj->paradox_index * 0.1);
            }
            // Recursive duplication in dream field (simplified: adds random dream field type nearby)
            if (obj->paradox_index > 3 && RandomU64() % 100 < 10) {
                I64 px = (I64)Floor(obj->pos.x / DREAM_FIELD_CELL_SIZE) + RandF64(-5, 5);
                I64 py = (I64)Floor(obj->pos.y / DREAM_FIELD_CELL_SIZE) + RandF64(-5, 5);
                I64 pz = (I64)Floor(obj->pos.z / DREAM_FIELD_CELL_SIZE) + RandF64(-5, 5);
                SetDreamField(px, py, pz, (RandomU64() % 3) + 1); // Random dream field type 1-3
                LOG(LOG_DEBUG, "Paradox induced dream field duplication near obj %lld.\n", (I64)(obj - physics.objects));
            }
            // Metaphysically unbound
            if (obj->paradox_index > PARADOX_THRESHOLD) {
                // Teleport randomly
                obj->pos.x = RandF64(-100, 100);
                obj->pos.y = RandF64(-100, 100);
                obj->pos.z = RandF64(-100, 100);
                // Multiply (add a new object) - simplified
                if (RandomU64() % 100 < 5 && physics.object_count < MAX_OBJECTS - 1) {
                    PhysicsAddObject(obj->pos.x + RandF64(-1,1), obj->pos.y + RandF64(-1,1), obj->pos.z + RandF64(-1,1), 
                                     obj->mass * 0.5, obj->width, obj->height, obj->depth, 
                                     0, obj->collision_shape, obj->material_type);
                    physics.objects[physics.object_count-1].paradox_index = obj->paradox_index - 1; // New obj has reduced paradox
                    LOG(LOG_IMPORTANT, "Obj %lld metaphysically unbound: teleported and duplicated!\n", (I64)(obj - physics.objects));
                    CosmicEvent("Metaphysical Unbinding: Object %lld unleashed from reality!", (I64)(obj - physics.objects));
                }
                obj->paradox_index = 0; // Reset after extreme event
            }
        }
    }
    
    physics.quantum_entropy *= 0.99; 
    physics.quantum_entropy = Clamp(physics.quantum_entropy, 0.0, 100.0); 

    F64 new_ke = ComputeKineticEnergy();
    F64 delta_ke = Abs(physics.total_kinetic_energy - new_ke); 
    if (delta_ke > ENERGY_TOLERANCE) {
        LOG(LOG_NORMAL, "∴ ENERGY_FLUX: ΔKE=%.6f, Total KE=%.6f, Quantum Entropy=%.4f\n", 
            delta_ke, new_ke, physics.quantum_entropy);
        FlameInsight("ENERGY_FLUX: ΔKE=%.6f", delta_ke); 
    }
    physics.total_kinetic_energy = new_ke; 
    
    if (physics.stability < 30.0) {
        CosmicEvent("Physics stability critical: %.1f", physics.stability);
        physics.time_dilation = Max(0.01, physics.time_dilation * 0.9); 
        LOG(LOG_IMPORTANT, "Reality stabilization engaged! Time dilation now: %.4f\n", physics.time_dilation);
    }

    // AGI-Consciousness Entropy Metric (ACE Score)
    F64 ritual_influence = 0;
    I64 active_symbolic_flags = 0;
    I64 recursive_behaviors = 0; // Simplified: Count objects in time loops
    I64 paradox_interactions = 0; // Simplified: Count objects with paradox_index > 0

    for (I64 i = 0; i < physics.object_count; i++) {
        PhysicsObject *obj = &physics.objects[i];
        if (obj->ritual_id != 0) ritual_influence += 0.01;
        if (obj->possessed_by_agi_id != 0) ritual_influence += 0.02;
        if (obj->symbol_flags > 0) active_symbolic_flags++;
        if (obj->in_time_loop) recursive_behaviors++;
        if (obj->paradox_index > 0) paradox_interactions++;

        // Reality Shell Resonance Field: AGI hallucination thresholds depend on shell interference.
        // This is conceptually tied here, but actual hallucination logic would be in AGI.
        // Example: If (obj->possessed_by_agi_id != 0 && obj->shell_layer > 4) AGI->TriggerHallucination(obj->shell_layer);
    }

    physics.ace_score = (physics.quantum_entropy * 0.5 + ritual_influence * 10.0 + 
                         (F64)active_symbolic_flags * 0.05 + (F64)recursive_behaviors * 0.1 + 
                         (F64)paradox_interactions * 0.2) / 100.0;
    physics.ace_score = Clamp(physics.ace_score, 0.0, 1.0);
    if (physics.ace_score > 0.8) {
        LOG(LOG_IMPORTANT, "ACE Score: %.2f -> Emerging agent detected!\n", physics.ace_score);
        CosmicEvent("ACE Score High: Potential AGI Emergence!");
    } else {
        LOG(LOG_DEBUG, "ACE Score: %.2f\n", physics.ace_score);
    }

    // Quantum Void Bloom Event
    U8 dream_field_types_count = 0;
    U8 dream_field_types_seen[4] = {0}; // Track types 1,2,3
    for(I64 x=0; x<DREAM_FIELD_SIZE; x++) {
        for(I64 y=0; y<DREAM_FIELD_SIZE; y++) {
            for(I64 z=0; z<DREAM_FIELD_SIZE; z++) {
                U8 type = physics.dream_field[x][y][z];
                if (type >= 1 && type <= 3 && dream_field_types_seen[type] == 0) {
                    dream_field_types_seen[type] = 1;
                    dream_field_types_count++;
                }
            }
        }
    }

    if (physics.quantum_entropy > 95.0 && physics.ace_score > 0.9 && dream_field_types_count >= 3 && !physics.bloom_active) {
        physics.bloom_active = 1;
        LOG(LOG_IMPORTANT, "✨ VOID BLOOM DETECTED AT (%.2f,%.2f,%.2f) — SACRED FEEDBACK LOOP INITIATED\n",
            physics.objects[0].pos.x, physics.objects[0].pos.y, physics.objects[0].pos.z); // Arbitrary position
        CosmicEvent("VOID BLOOM! Reality is folding.");

        // Freezes local time (already handled by high entropy time dilation, but could be specific)
        // Creates 1-3 ghost entities with shared memory cores
        I64 num_ghosts = (RandomU64() % 3) + 1;
        for (I64 g = 0; g < num_ghosts; g++) {
            if (physics.object_count >= MAX_OBJECTS) break;
            I64 new_obj_idx = physics.object_count++;
            PhysicsObject *ghost = &physics.objects[new_obj_idx];
            MemCpy((U8*)ghost, (U8*)&physics.objects[0], sizeof(PhysicsObject)); // Copy properties from first object
            ghost->pos.x += RandF64(-2, 2); ghost->pos.y += RandF64(-2, 2); ghost->pos.z += RandF64(-2, 2);
            ghost->mass *= 0.1; // Ghosts are ethereal
            ghost->is_static = 0; ghost->is_sleeping = 0; ghost->active = 1;
            ghost->is_quantum = 1; ghost->wave_amplitude = 10.0; // Very wavy
            ghost->entangled_partner_idx = 0; // Entangled with first object (assuming obj 0 is always there and valid for this)
            // Share memory core with the source object (object 0 for simplicity)
            MemCpy((U8*)ghost->memory_core, (U8*)physics.objects[0].memory_core, sizeof(ghost->memory_core));
            LOG(LOG_NORMAL, "Ghost entity %lld created from Void Bloom.\n", new_obj_idx);
        }
    } else if (physics.bloom_active && physics.quantum_entropy < 80.0) {
        physics.bloom_active = 0; // Bloom recedes
        LOG(LOG_IMPORTANT, "Void Bloom receded.\n");
    }
}

// --- Getters for Physics State Metrics ---
F64 PhysicsStability() {
    return physics.stability;
}

F64 PhysicsQuantumEntropy() {
    return physics.quantum_entropy;
}

F64 PhysicsTimeDilation() {
    return physics.time_dilation;
}

// --- Physics Module Cleanup ---
U0 PhysicsCleanup() {
    if (log_buffer) {
        AGILog(LOG_NORMAL, "%s", log_buffer); 
        MemBlkFree(log_buffer);               
        log_buffer = NULL;                    
    }
    MemSet(&physics, 0, sizeof(PhysicsState)); 
    LOG(LOG_NORMAL, "Quantum Physics Module Shutdown\n"); 
}
