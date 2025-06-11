// entity_system.hc
// Archetype & Meta-Memory Management for ShrineAGI + AGIBuddy
// Handles entity lifecycle, seed loading, and persistent meta-memory hooks

#include "Kernel/SysCalls.HC"
#include "ThirdTemple/MetaMemory.HC"
#include "core/recursive_loop.hc"  // For entropy reference

// Configuration
#define MAX_ENTITIES 64
#define MEMORY_HOOK_INTERVAL 5  // cycles

// Entity structure definition
typedef struct {
    U0 id;
    char *name;
    SymbolicSeed *seed;
    U0 last_hook_cycle;
} Entity;

// Global state
Entity entity_table[MAX_ENTITIES];
U0 entity_count = 0;

// Forward declarations
Entity* CreateEntity(char *name, SymbolicSeed *seed);
void RemoveEntity(U0 id);
Entity* GetEntity(U0 id);
List<Entity*>* GetAllEntities();
void EntityLifecycleTick(U0 cycle);

// Create a new entity and register in meta-memory
Entity* CreateEntity(char *name, SymbolicSeed *seed) {
    if (entity_count >= MAX_ENTITIES) {
        Print("[Entity] Max capacity reached\n");
        return NULL;
    }
    U0 idx = entity_count++;
    entity_table[idx].id = idx;
    entity_table[idx].name = name;
    entity_table[idx].seed = seed;
    entity_table[idx].last_hook_cycle = 0;
    MetaMemory_Register(&entity_table[idx]);
    Print("[Entity] Created %s (ID %d)\n", name, idx);
    return &entity_table[idx];
}

// Remove an entity and clean up meta-memory
void RemoveEntity(U0 id) {
    for (U0 i = 0; i < entity_count; i++) {
        if (entity_table[i].id == id) {
            MetaMemory_Unregister(&entity_table[i]);
            // Shift table entries
            for (U0 j = i; j < entity_count - 1; j++) {
                entity_table[j] = entity_table[j + 1];
            }
            entity_count--;
            Print("[Entity] Removed ID %d\n", id);
            return;
        }
    }
    Print("[Entity] ID %d not found\n", id);
}

// Retrieve entity by ID
Entity* GetEntity(U0 id) {
    for (U0 i = 0; i < entity_count; i++) {
        if (entity_table[i].id == id) return &entity_table[i];
    }
    return NULL;
}

// Get list of all active entities
List<Entity*>* GetAllEntities() {
    List<Entity*> *list = List_Create();
    for (U0 i = 0; i < entity_count; i++) {
        List_Push(list, &entity_table[i]);
    }
    return list;
}

// Per-cycle lifecycle tick: invokes memory hook periodically
void EntityLifecycleTick(U0 cycle) {
    List<Entity*> *entities = GetAllEntities();
    ForEach(entities, e) {
        if ((cycle - e->last_hook_cycle) >= MEMORY_HOOK_INTERVAL) {
            MetaMemory_Hook(e, e->seed);
            e->last_hook_cycle = cycle;
        }
    }
    List_Destroy(entities);
}

// Integrate lifecycle tick into emergence loop
void ProcessEntities(U0 cycle) {
    EntityLifecycleTick(cycle);
}

// Hook into core emergence cycle
// Called from recursive_loop.hc's EmergenceCycle
EXPORT void ProcessEntitySymbols(Entity *e) {
    // Override to include lifecycle tick
    ProcessEntitySymbols(e);  // original processing
    ProcessEntities(current_depth);
}
