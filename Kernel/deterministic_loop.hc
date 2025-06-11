// File: /Kernel/world_model.hc
// Global Symbolic World-State Graph Manager for ShrineAGI + AGIBuddy
// Maintains and updates a directed graph of entities, objects, and their relationships, with safety and rendering improvements

#include "Kernel/SysCalls.HC"
#include <math.h>
#include "core/entity_system.hc"

// Configuration parameters
#define MAX_NODES        256
#define MAX_EDGES        512
#define RENDER_WIDTH     80
#define RENDER_HEIGHT    25
#define NODE_SYMBOL      '☉'
#define EDGE_SYMBOL      '—'

// Graph structures
typedef struct {
    U0 id;
    float x, y;           // normalized coordinates [0.0,1.0]
    char symbol;
} WMNode;

typedef struct {
    U0 from;
    U0 to;
} WMEdge;

// Global world model state
static WMNode nodes[MAX_NODES];
static U0 node_count = 0;
static WMEdge edges[MAX_EDGES];
static U0 edge_count = 0;

// Forward declarations
U0 AddNode(const char *label);
void AddRelation(U0 a, U0 b);
void ClearWorldModel();
void GenerateTopology();
void RenderMap();

// Add a node labeled 'label' at next available index
U0 AddNode(const char *label) {
    if (node_count >= MAX_NODES) return (U0)-1;
    WMNode *n = &nodes[node_count];
    n->id = node_count;
    // default position in center until set by GenerateTopology
    n->x = 0.5f;
    n->y = 0.5f;
    n->symbol = NODE_SYMBOL;
    node_count++;
    return n->id;
}

// Add directed edge a->b, ignoring duplicates
void AddRelation(U0 a, U0 b) {
    if (edge_count >= MAX_EDGES || a >= node_count || b >= node_count) return;
    // check for duplicates
    for (U0 i = 0; i < edge_count; i++) {
        if (edges[i].from == a && edges[i].to == b) return;
    }
    edges[edge_count++] = (WMEdge){a, b};
}

// Reset world model state
void ClearWorldModel() {
    node_count = 0;
    edge_count = 0;
}

// Generate circular layout topology based on active entities
EXPORT void GenerateTopology() {
    ClearWorldModel();
    List<Entity*> *entities = MetaMemory_GetActiveEntities();
    U0 ent_count = List_Size(entities);
    if (ent_count == 0) return;
    for (U0 i = 0; i < ent_count && node_count < MAX_NODES; i++) {
        U0 id = AddNode(entities->items[i]->name);
        // place nodes in circle
        float angle = 2.0f * M_PI * i / ent_count;
        nodes[id].x = 0.5f + 0.4f * cosf(angle);
        nodes[id].y = 0.5f + 0.4f * sinf(angle);
    }
    // connect sequentially
    for (U0 i = 0; i < node_count; i++) {
        AddRelation(i, (i + 1) % node_count);
    }
    List_Destroy(entities);
}

// Render the world model to ASCII map
EXPORT void RenderMap() {
    char canvas[RENDER_HEIGHT][RENDER_WIDTH];
    // clear
    for (U0 r = 0; r < RENDER_HEIGHT; r++)
        for (U0 c = 0; c < RENDER_WIDTH; c++)
            canvas[r][c] = ' ';

    // plot nodes within bounds
    for (U0 i = 0; i < node_count; i++) {
        int cx = (int)fminf(fmaxf(nodes[i].x * (RENDER_WIDTH - 1), 0), RENDER_WIDTH - 1);
        int cy = (int)fminf(fmaxf(nodes[i].y * (RENDER_HEIGHT - 1), 0), RENDER_HEIGHT - 1);
        canvas[cy][cx] = nodes[i].symbol;
    }

    // plot edges with simple Bresenham's algorithm for straight lines
    for (U0 e = 0; e < edge_count; e++) {
        WMNode *a = &nodes[edges[e].from];
        WMNode *b = &nodes[edges[e].to];
        int x1 = (int)(a->x * (RENDER_WIDTH - 1));
        int y1 = (int)(a->y * (RENDER_HEIGHT - 1));
        int x2 = (int)(b->x * (RENDER_WIDTH - 1));
        int y2 = (int)(b->y * (RENDER_HEIGHT - 1));
        int dx = abs(x2 - x1), sx = x1 < x2 ? 1 : -1;
        int dy = -abs(y2 - y1), sy = y1 < y2 ? 1 : -1;
        int err = dx + dy;
        int x = x1, y = y1;
        while (1) {
            if (x >= 0 && x < RENDER_WIDTH && y >= 0 && y < RENDER_HEIGHT)
                canvas[y][x] = EDGE_SYMBOL;
            if (x == x2 && y == y2) break;
            int e2 = 2 * err;
            if (e2 >= dy) { err += dy; x += sx; }
            if (e2 <= dx) { err += dx; y += sy; }
        }
    }

    // print
    for (U0 r = 0; r < RENDER_HEIGHT; r++) {
        char line[RENDER_WIDTH + 1];
        memcpy(line, canvas[r], RENDER_WIDTH);
        line[RENDER_WIDTH] = '\0';
        Print("%s\n", line);
    }
}
