// File: /Cmds/audit_log.hc
// Decision Audit Log Dumper for ShrineAGI + AGIBuddy
// Records and outputs timestamped decision events for later review

#include "Kernel/SysCalls.HC"
#include "ThirdTemple/MetaMemory.HC"

// Configuration parameters
#define MAX_AUDIT_ENTRIES   1024
#define ENTRY_MESSAGE_LEN   128

// Audit entry structure
typedef struct {
    U32 timestamp;                     // seconds since epoch
    char entity_name[32];             // name of entity making decision
    char message[ENTRY_MESSAGE_LEN];  // description of decision/rationale
} AuditEntry;

// Global audit log
static AuditEntry audit_log[MAX_AUDIT_ENTRIES];
static U0 audit_count = 0;

// Forward declarations
void RecordAudit(const char *entity, const char *msg);
void DumpAuditLog();

// Record a decision event
EXPORT void RecordAudit(const char *entity, const char *msg) {
    if (audit_count >= MAX_AUDIT_ENTRIES) return;
    AuditEntry *e = &audit_log[audit_count++];
    e->timestamp = Sys_Time();
    strncpy(e->entity_name, entity, 31);
    e->entity_name[31] = '\0';
    strncpy(e->message, msg, ENTRY_MESSAGE_LEN-1);
    e->message[ENTRY_MESSAGE_LEN-1] = '\0';
}

// Command to print all audit entries
EXPORT void AuditLog_Dump() {
    Print("[AuditLog] Dumping %d entries:\n", audit_count);
    for (U0 i = 0; i < audit_count; i++) {
        AuditEntry *e = &audit_log[i];
        Print("%10u | %s | %s\n", e->timestamp, e->entity_name, e->message);
    }
}
