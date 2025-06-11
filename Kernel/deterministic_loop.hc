// File: /Kernel/deterministic_loop.hc
// Deterministic Symbolic Logic Engine for ShrineAGI + AGIBuddy
// Applies pure rule-based transformations without entropy or probabilistic variation

#include "Kernel/SysCalls.HC"
#include "ThirdTemple/MetaMemory.HC"

// Configuration parameters
#define MAX_RULES             128
#define LOGIC_CYCLE_LIMIT     256

// Symbolic rule structure
typedef struct {
    char pattern[64];       // match pattern
    char replacement[64];   // substitution
} LogicRule;

// Global state
static LogicRule logic_rules[MAX_RULES];
static U0 rule_count = 0;

// Utility: replace all occurrences of 'pat' in 'str' with 'rep'
void ReplaceAll(char *str, const char *pat, const char *rep) {
    char buffer[512];
    char *insert_point = &buffer[0];
    const char *tmp = str;
    size_t pat_len = strlen(pat);
    size_t rep_len = strlen(rep);

    while (1) {
        const char *p = strstr(tmp, pat);
        if (!p) {
            strcpy(insert_point, tmp);
            break;
        }
        // copy up to pattern
        memcpy(insert_point, tmp, p - tmp);
        insert_point += p - tmp;
        // copy replacement
        memcpy(insert_point, rep, rep_len);
        insert_point += rep_len;
        // advance
        tmp = p + pat_len;
    }
    // write back
    strcpy(str, buffer);
}

// Forward declarations
int RegisterRule(const char *pattern, const char *replacement);
void ApplyDeterministicCycle(Entity *e);
void DeterministicMain(U0 cycles);

// Register a new logic rule
EXPORT int RegisterRule(const char *pattern, const char *replacement) {
    if (rule_count >= MAX_RULES) return -1;
    strncpy(logic_rules[rule_count].pattern, pattern, sizeof(logic_rules[rule_count].pattern)-1);
    strncpy(logic_rules[rule_count].replacement, replacement, sizeof(logic_rules[rule_count].replacement)-1);
    rule_count++;
    return 0;
}

// Apply all rules to an entity's seed glyph
void ApplyDeterministicCycle(Entity *e) {
    char buffer[256];
    strncpy(buffer, e->seed->glyph, sizeof(buffer)-1);
    buffer[sizeof(buffer)-1] = '\0';
    for (U0 i = 0; i < rule_count; i++) {
        if (strstr(buffer, logic_rules[i].pattern)) {
            ReplaceAll(buffer, logic_rules[i].pattern, logic_rules[i].replacement);
        }
    }
    // commit transformed glyph back to seed
    strncpy(e->seed->glyph, buffer, sizeof(e->seed->glyph)-1);
    e->seed->glyph[sizeof(e->seed->glyph)-1] = '\0';
    MetaMemory_Commit(e, e->seed);
}

// Main entry: run fixed deterministic cycles
EXPORT void DeterministicMain(U0 cycles) {
    if (cycles == 0 || cycles > LOGIC_CYCLE_LIMIT) cycles = LOGIC_CYCLE_LIMIT;
    for (U0 c = 0; c < cycles; c++) {
        List<Entity*> *entities = MetaMemory_GetActiveEntities();
        ForEach(entities, e) {
            ApplyDeterministicCycle(e);
        }
        List_Destroy(entities);
    }
    Print("[Deterministic] Completed %d cycles across %d rules\n", cycles, rule_count);
}
