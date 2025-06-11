
// village_sim.hc
// Cultural Emergence Engine for ShrineAGI + AGIBuddy
// Simulates a network of symbolic communities and their cultural dynamics

#include "Kernel/SysCalls.HC"
#include "ThirdTemple/MetaMemory.HC"
#include "core/entity_system.hc"

// Configuration parameters
#define MAX_VILLAGES       16
#define MAX_VILLAGE_POP    32
#define CULTURE_SPREAD_RATE 0.1f

// Village and citizen structures
typedef struct {
    U0 id;
    char *name;
    List<Entity*> *citizens;
    float culture_index;    // measure of symbolic cohesion
} Village;

// Global state
static Village villages[MAX_VILLAGES];
static U0 village_count = 0;

// Forward declarations
Village* CreateVillage(const char *name);
void AddCitizen(Village *v, Entity *e);
void RemoveCitizen(Village *v, U0 entity_id);
void SimulateVillage(Village *v);
void RunVillageSim(U0 cycle);

// Create a village
Village* CreateVillage(const char *name) {
    if (village_count >= MAX_VILLAGES) return NULL;
    Village *v = &villages[village_count];
    v->id = village_count;
    v->name = strdup(name);
    v->citizens = List_Create();
    v->culture_index = 0.5f;  // neutral initial cohesion
    village_count++;
    Print("[Village] Created '%s' (ID %d)\n", name, v->id);
    return v;
}

// Add a citizen entity to a village
void AddCitizen(Village *v, Entity *e) {
    if (List_Size(v->citizens) >= MAX_VILLAGE_POP) return;
    List_Push(v->citizens, e);
    Print("[Village] %s joined village %s\n", e->name, v->name);
}

// Remove a citizen by entity ID
void RemoveCitizen(Village *v, U0 entity_id) {
    // Find and remove
    List<Entity*> *tmp = List_Create();
    ForEach(v->citizens, e) {
        if (e->id != entity_id) List_Push(tmp, e);
    }
    List_Destroy(v->citizens);
    v->citizens = tmp;
    Print("[Village] Removed entity %d from village %s\n", entity_id, v->name);
}

// Simulate cultural dynamics within a village
void SimulateVillage(Village *v) {
    float spread = CULTURE_SPREAD_RATE * v->culture_index;
    // Each citizen influences culture_index
    U0 pop = List_Size(v->citizens);
    if (pop == 0) return;
    float delta = spread * (float)pop / MAX_VILLAGE_POP;
    v->culture_index += delta;
    if (v->culture_index > 1.0f) v->culture_index = 1.0f;
    if (v->culture_index < 0.0f) v->culture_index = 0.0f;
    Print("[Village] %s culture index: %f\n", v->name, v->culture_index);
}

// Entry point for village simulation; called each cycle
EXPORT void RunVillageSim(U0 cycle) {
    For (U0 i = 0; i < village_count; i++) {
        SimulateVillage(&villages[i]);
    }
}
