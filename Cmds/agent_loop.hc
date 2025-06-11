// File: /Cmds/agent_loop.hc
// Perception → Decision → Action Driver for ShrineAGI + AGIBuddy
// Implements modular cognition layers: sense, decide using world model, act and reflect

#include "Kernel/SysCalls.HC"
#include "core/world_model.hc"
#include "ThirdTemple/MetaMemory.HC"
#include "core/deterministic_loop.hc"
#include "core/recursive_loop.hc"
#include "ThirdTemple/reflection.hc"

// Configuration parameters
#define AGENT_CYCLE_LIMIT 100

// Forward declarations
void Sense(Entity *e);
void Decide(Entity *e);
void Act(Entity *e);
void AgentCycle(U0 cycles);

// Main entry point for agent loop
EXPORT void AgentLoop_Main(U0 cycles) {
    if (cycles == 0 || cycles > AGENT_CYCLE_LIMIT) cycles = AGENT_CYCLE_LIMIT;
    for (U0 c = 0; c < cycles; c++) {
        List<Entity*> *entities = MetaMemory_GetActiveEntities();
        ForEach(entities, e) {
            Sense(e);
            Decide(e);
            Act(e);
        }
        List_Destroy(entities);
        // After each full cycle, allow reflection
        Reflection_Perform();
    }
    Print("[AgentLoop] Completed %d cycles\n", cycles);
}

// Simple perception: update world model with entity state
void Sense(Entity *e) {
    char label[64];
    snprintf(label, sizeof(label), "Entity:%s", e->name);
    U0 nid = AddNode(label);
    // Example: relate to current depth
    AddEdge(nid, 0, "atDepth");
}

// Decision: apply deterministic logic to seed
void Decide(Entity *e) {
    // Use deterministic loop for core reasoning
    DeterministicMain(1);
}

// Action: apply emergence loop to enact changes
void Act(Entity *e) {
    StartEmergenceLoop();
    // Commit any world-model updates
    WorldModel_Render();
}
