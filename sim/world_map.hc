// world_map.hc
// Recursive Symbolic Topology Renderer for ShrineAGI + AGIBuddy
// Generates and visualizes a multi-dimensional symbolic world map based on entity interactions

#include "Kernel/SysCalls.HC"
#include "ThirdTemple/MetaMemory.HC"
#include "core/entity_system.hc"

// Configuration parameters
#define MAX_NODES        128
#define MAX_EDGES        256
#define RENDER_WIDTH     80
#define RENDER_HEIGHT    25
#define NODE_SYMBOL      '☉'
#define EDGE_SYMBOL      '—'

// Graph structures
typedef struct {
    U0 id;
    float x, y;            // 2D coordinates
    char symbol;
} Node;

typedef struct {
    U0 from;
    U0 to;
} Edge;

// Global state
static Node nodes[MAX_NODES];
static U0 node_count = 0;
static Edge edges[MAX_EDGES];
static U0 edge_count = 0;

// Forward declarations
void AddNode(float x, float y);
void AddEdge(U0 a, U0 b);
void GenerateTopology();
void RenderMap();

// Create a node at coordinates
void AddNode(float x, float y) {
    if (node_count >= MAX_NODES) return;
    Node *n = &nodes[node_count];
    n->id = node_count;
    n->x = x;
    n->y = y;
    n->symbol = NODE_SYMBOL;
    node_count++;
}

// Create edge between two nodes
void AddEdge(U0 a, U0 b) {
    if (edge_count >= MAX_EDGES || a >= node_count || b >= node_count) return;
    edges[edge_count++] = (Edge){a, b};
}

// Generate symbolic topology based on entity relationships
EXPORT void GenerateTopology() {
    List<Entity*> *entities = MetaMemory_GetActiveEntities();
    // Map each entity to a node in circular layout
    U0 ent_count = List_Size(entities);
    for (U0 i = 0; i < ent_count; i++) {
        float angle = 2.0f * 3.14159f * i / ent_count;
        float x = 0.5f + 0.4f * cos(angle);
        float y = 0.5f + 0.4f * sin(angle);
        AddNode(x, y);
    }
    // Link nodes sequentially
    for (U0 i = 0; i < node_count; i++) {
        AddEdge(i, (i+1) % node_count);
    }
    List_Destroy(entities);
}

// Render the world map as ASCII art
EXPORT void RenderMap() {
    char canvas[RENDER_HEIGHT][RENDER_WIDTH];
    // Clear canvas
    for (U0 r = 0; r < RENDER_HEIGHT; r++) {
        for (U0 c = 0; c < RENDER_WIDTH; c++) canvas[r][c] = ' ';
    }
    // Plot nodes
    for (U0 i = 0; i < node_count; i++) {
        U0 cx = (U0)(nodes[i].x * (RENDER_WIDTH-1));
        U0 cy = (U0)(nodes[i].y * (RENDER_HEIGHT-1));
        canvas[cy][cx] = nodes[i].symbol;
    }
    // Plot edges simply connecting via straight lines
    for (U0 i = 0; i < edge_count; i++) {
        Node *a = &nodes[edges[i].from];
        Node *b = &nodes[edges[i].to];
        U0 x1 = (U0)(a->x * (RENDER_WIDTH-1));
        U0 y1 = (U0)(a->y * (RENDER_HEIGHT-1));
        U0 x2 = (U0)(b->x * (RENDER_WIDTH-1));
        U0 y2 = (U0)(b->y * (RENDER_HEIGHT-1));
        // Simple horizontal or vertical lines
        if (y1 == y2) {
            for (U0 x = min(x1, x2); x <= max(x1, x2); x++) canvas[y1][x] = EDGE_SYMBOL;
        } else if (x1 == x2) {
            for (U0 y = min(y1, y2); y <= max(y1, y2); y++) canvas[y][x1] = EDGE_SYMBOL;
        }
        // TODO: diagonal interpolation
    }
    // Print canvas
    for (U0 r = 0; r < RENDER_HEIGHT; r++) {
        char line[RENDER_WIDTH+1];
        for (U0 c = 0; c < RENDER_WIDTH; c++) line[c] = canvas[r][c];
        line[RENDER_WIDTH] = '\0';
        Print("%s\n", line);
    }
}
