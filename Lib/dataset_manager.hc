// dataset_manager.hc
// Symbolic Dataset Loader & Validator for ShrineAGI + AGIBuddy
// Manages clean, structured data for causal and ethical reasoning

#include "Kernel/SysCalls.HC"
#include "ThirdTemple/MetaMemory.HC"

// Configuration parameters
#define MAX_DATASETS        32
#define MAX_RECORDS_PER_DS 1024
#define FIELD_NAME_LEN      32
#define FIELD_VALUE_LEN     128

// Data record and dataset structures
typedef struct {
    char field[FIELD_NAME_LEN];
    char value[FIELD_VALUE_LEN];
} DataRecord;

typedef struct {
    char name[FIELD_NAME_LEN];
    DataRecord records[MAX_RECORDS_PER_DS];
    U0 record_count;
} Dataset;

// Global registry
static Dataset datasets[MAX_DATASETS];
static U0 dataset_count = 0;

// Forward declarations
int LoadDataset(const char *path, const char *name);
int ValidateDataset(const char *name);
Dataset* GetDataset(const char *name);
void UnloadDataset(const char *name);

// Load a CSV-like dataset from file into structured records
EXPORT int LoadDataset(const char *path, const char *name) {
    if (dataset_count >= MAX_DATASETS) return -1;
    U8 *data;
    U32 size;
    data = FileRead(path, &size);
    if (!data) return -1;
    Dataset *ds = &datasets[dataset_count];
    strncpy(ds->name, name, FIELD_NAME_LEN-1);
    ds->name[FIELD_NAME_LEN-1] = '\0';
    ds->record_count = 0;

    char *line = strtok((char*)data, "\n");
    char *headers[MAX_RECORDS_PER_DS];
    int header_count = 0;
    if (line) {
        // parse header
        char *tok = strtok(line, ",");
        while (tok && header_count < MAX_RECORDS_PER_DS) {
            headers[header_count++] = tok;
            tok = strtok(NULL, ",");
        }
    }
    // parse records
    while ((line = strtok(NULL, "\n"))) {
        if (ds->record_count >= MAX_RECORDS_PER_DS) break;
        char *tok = strtok(line, ",");
        int field_i = 0;
        while (tok && field_i < header_count) {
            DataRecord *rec = &ds->records[ds->record_count];
            strncpy(rec->field, headers[field_i], FIELD_NAME_LEN-1);
            rec->field[FIELD_NAME_LEN-1] = '\0';
            strncpy(rec->value, tok, FIELD_VALUE_LEN-1);
            rec->value[FIELD_VALUE_LEN-1] = '\0';
            field_i++;
            tok = strtok(NULL, ",");
        }
        ds->record_count++;
    }
    dataset_count++;
    return 0;
}

// Basic validation: ensure non-zero records and no empty fields
EXPORT int ValidateDataset(const char *name) {
    Dataset *ds = GetDataset(name);
    if (!ds) return -1;
    if (ds->record_count == 0) return -2;
    for (U0 i = 0; i < ds->record_count; i++) {
        if (strlen(ds->records[i].field) == 0 || strlen(ds->records[i].value) == 0)
            return -3;
    }
    return 0;
}

// Retrieve dataset by name
Dataset* GetDataset(const char *name) {
    for (U0 i = 0; i < dataset_count; i++) {
        if (strcmp(datasets[i].name, name) == 0) return &datasets[i];
    }
    return NULL;
}

// Unload and free a dataset
EXPORT void UnloadDataset(const char *name) {
    for (U0 i = 0; i < dataset_count; i++) {
        if (strcmp(datasets[i].name, name) == 0) {
            // shift remaining
            for (U0 j = i; j < dataset_count-1; j++) {
                datasets[j] = datasets[j+1];
            }
            dataset_count--;
            return;
        }
    }
}
