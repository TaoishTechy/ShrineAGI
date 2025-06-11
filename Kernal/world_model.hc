// world_model.hc
// Global Symbolic World-State Graph Manager for ShrineAGI + AGIBuddy
// Maintains and updates a directed graph of entities, objects, and their relationships

#include "Kernel/SysCalls.HC"
#include "core/entity_system.hc"

// Configuration parameters
#define MAX_NODES        256
#define MAX_EDGES        512

// Node and edge structures
typedef struct {
    U0 id;
    char label[64];      // e.g., "Entity:Alice" or "Object:Tree"
} WMNode;

typedef struct {
    U0 from;
    U0 to;
    char relation[32];   // e.g., "owns", "connected_to"
} WMEdge;

// Global world model state
static WMNode wm_nodes[MAX_NODES];
static WMEdge wm_edges[MAX_EDGES];
static U0 wm_node_count = 0;
static U0 wm_edge_count = 0;

// Forward declarations
U0 AddNode(const char *label);
void AddEdge(U0 from, U0 to, const char *relation);
void RemoveNode(U0 id);
void RemoveEdgesOfNode(U0 id);
void QueryNeighbors(U0 id, List<WMNode *> *out);
void RenderWorldModel();

// Add a node and return its ID
U0 AddNode(const char *label) {
    if (wm_node_count >= MAX_NODES) return (U0)-1;
    U0 idx = wm_node_count++;
    wm_nodes[idx].id = idx;
    strncpy(wm_nodes[idx].label, label, 63);
    wm_nodes[idx].label[63] = '\0';
    return idx;
}

// Add a directed relation edge
void AddEdge(U0 from, U0 to, const char *relation) {
    if (wm_edge_count >= MAX_EDGES) return;
    wm_edges[wm_edge_count].from = from;
    wm_edges[wm_edge_count].to = to;
    strncpy(wm_edges[wm_edge_count].relation, relation, 31);
    wm_edges[wm_edge_count].relation[31] = '\0';
    wm_edge_count++;
}

// Remove a node and all associated edges
void RemoveNode(U0 id) {
    // Remove edges first
    RemoveEdgesOfNode(id);
    // Shift nodes down
    for (U0 i = id; i < wm_node_count - 1; i++) {
        wm_nodes[i] = wm_nodes[i + 1];
        wm_nodes[i].id = i;
    }
    wm_node_count--;
}

// Remove edges where from==id or to==id
void RemoveEdgesOfNode(U0 id) {
    U0 dst = 0;
    for (U0 i = 0; i < wm_edge_count; i++) {
        if (wm_edges[i].from == id || wm_edges[i].to == id) continue;
        wm_edges[dst++] = wm_edges[i];
    }
    wm_edge_count = dst;
}

// Query neighbors into provided list
void QueryNeighbors(U0 id, List<WMNode *> *out) {
    For (U0 i = 0; i < wm_edge_count; i++) {
        if (wm_edges[i].from == id) {
            U0 nid = wm_edges[i].to;
            List_Push(out, &wm_nodes[nid]);
        }
    }
}

// Render the world model graph in ASCII table
EXPORT void WorldModel_Render() {
    Print("[WorldModel] Nodes (%d):\n", wm_node_count);
    For (U0 i = 0; i < wm_node_count; i++) {
        Print("  %d: %s\n", wm_nodes[i].id, wm_nodes[i].label);
    }
    Print("[WorldModel] Edges (%d):\n", wm_edge_count);
    For (U0 i = 0; i < wm_edge_count; i++) {
        Print("  %d -> %d [%s]\n", wm_edges[i].from, wm_edges[i].to, wm_edges[i].relation);
    }
}
