// File: /Lib/truth_maintainer.hc
// Consistency Enforcement & Contradiction Retraction for ShrineAGI + AGIBuddy
// Maintains a knowledge base, enforces logical constraints, and retracts conflicting beliefs

#include "Kernel/SysCalls.HC"
#include "core/world_model.hc"

// Configuration parameters
#define MAX_ASSERTIONS      512
#define MAX_CONSTRAINTS     128

// Assertion and constraint structures
typedef struct {
    U0 id;
    char statement[128];
    bool active;
} Assertion;

typedef struct {
    char premise[64];
    char conclusion[64];
} Constraint;

// Global state
static Assertion assertions[MAX_ASSERTIONS];
static U0 assertion_count = 0;
static Constraint constraints[MAX_CONSTRAINTS];
static U0 constraint_count = 0;

// Forward declarations
int AddAssertion(const char *stmt);
int AddConstraint(const char *premise, const char *conclusion);
void EnforceTruth();
void CheckConsistency();
void RetractAssertion(U0 id);

// Add a new assertion to the knowledge base
EXPORT int AddAssertion(const char *stmt) {
    if (assertion_count >= MAX_ASSERTIONS) return -1;
    U0 idx = assertion_count++;
    assertions[idx].id = idx;
    strncpy(assertions[idx].statement, stmt, 127);
    assertions[idx].statement[127] = '\0';
    assertions[idx].active = true;
    return idx;
}

// Add a new constraint rule
EXPORT int AddConstraint(const char *premise, const char *conclusion) {
    if (constraint_count >= MAX_CONSTRAINTS) return -1;
    strncpy(constraints[constraint_count].premise, premise, 63);
    constraints[constraint_count].premise[63] = '\0';
    strncpy(constraints[constraint_count].conclusion, conclusion, 63);
    constraints[constraint_count].conclusion[63] = '\0';
    return constraint_count++;
}

// Enforce all truth constraints
EXPORT void EnforceTruth() {
    for (U0 c = 0; c < constraint_count; c++) {
        for (U0 a = 0; a < assertion_count; a++) {
            if (assertions[a].active && strstr(assertions[a].statement, constraints[c].premise)) {
                // Premise holds; ensure conclusion present
                bool found = false;
                for (U0 b = 0; b < assertion_count; b++) {
                    if (assertions[b].active &&
                        strcmp(assertions[b].statement, constraints[c].conclusion) == 0) {
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    AddAssertion(constraints[c].conclusion);
                }
            }
        }
    }
    CheckConsistency();
}

// Check and retract contradictory assertions
void CheckConsistency() {
    for (U0 i = 0; i < assertion_count; i++) {
        if (!assertions[i].active) continue;
        char neg[132] = "not ";
        strncat(neg, assertions[i].statement, 127);
        for (U0 j = 0; j < assertion_count; j++) {
            if (assertions[j].active && strcmp(assertions[j].statement, neg) == 0) {
                // Retract the later assertion
                if (j > i) RetractAssertion(j);
                else RetractAssertion(i);
            }
        }
    }
}

// Retract an assertion by id
void RetractAssertion(U0 id) {
    if (id < assertion_count) {
        assertions[id].active = false;
        Print("[Truth] Retracted assertion %d\n", id);
    }
}
