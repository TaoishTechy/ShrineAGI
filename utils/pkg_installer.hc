// pkg_installer.hc
// Micro Package Installer & Updater for ShrineAGI + AGIBuddy Modules
// Enables dynamic installation and updating of .hc modules within the OS

#include "Kernel/SysCalls.HC"
#include "ThirdTemple/MetaMemory.HC"

// Configuration parameters
#define MAX_PACKAGES       32
#define PACKAGE_NAME_LEN   32
#define PACKAGE_VERSION_LEN 16

// Package metadata structure
typedef struct {
    char name[PACKAGE_NAME_LEN];

    char version[PACKAGE_VERSION_LEN];
    char source_url[128];
    bool installed;
} Package;

// Global package registry
static Package pkg_registry[MAX_PACKAGES];
static U0 pkg_count = 0;

// Forward declarations
int InstallPackage(const char *url);
int UpdatePackage(const char *name);
int RemovePackage(const char *name);
Package* GetPackage(const char *name);

// Install a new package from a URL (fetches and compiles)
EXPORT int InstallPackage(const char *url) {
    if (pkg_count >= MAX_PACKAGES) return -1;
    // Extract name and version from URL (stub)
    char name[PACKAGE_NAME_LEN] = "";
    char version[PACKAGE_VERSION_LEN] = "";
    ParsePackageURL(url, name, version);
    // Fetch package via netstack
    char buffer[1024];
    int len = Net_SendReceive(url, buffer, sizeof(buffer));
    if (len <= 0) return -1;
    // Save to disk
    char path[128];
    snprintf(path, sizeof(path), "utils/%s.hc", name);
    FileWrite(path, (U8*)buffer, len);
    // Compile
    Compile(path);
    // Register
    Package *p = &pkg_registry[pkg_count++];
    strncpy(p->name, name, PACKAGE_NAME_LEN);
    strncpy(p->version, version, PACKAGE_VERSION_LEN);
    strncpy(p->source_url, url, sizeof(p->source_url));
    p->installed = true;
    Print("[Pkg] Installed %s@%s from %s\n", name, version, url);
    return 0;
}

// Update an existing package by name
EXPORT int UpdatePackage(const char *name) {
    Package *p = GetPackage(name);
    if (!p) return -1;
    // Fetch latest via URL
    char buffer[1024];
    int len = Net_SendReceive(p->source_url, buffer, sizeof(buffer));
    if (len <= 0) return -1;
    // Overwrite and compile
    char path[128];
    snprintf(path, sizeof(path), "utils/%s.hc", name);
    FileWrite(path, (U8*)buffer, len);
    Compile(path);
    Print("[Pkg] Updated %s to new version from %s\n", name, p->source_url);
    return 0;
}

// Remove a package
EXPORT int RemovePackage(const char *name) {
    for (U0 i = 0; i < pkg_count; i++) {
        if (strcmp(pkg_registry[i].name, name) == 0) {
            pkg_registry[i].installed = false;
            char path[128];
            snprintf(path, sizeof(path), "utils/%s.hc", name);
            Sys_RemoveFile(path);
            Print("[Pkg] Removed package %s\n", name);
            return 0;
        }
    }
    return -1;
}

// Helper: lookup
Package* GetPackage(const char *name) {
    for (U0 i = 0; i < pkg_count; i++) {
        if (strcmp(pkg_registry[i].name, name) == 0 && pkg_registry[i].installed) {
            return &pkg_registry[i];
        }
    }
    return NULL;
}

// Stub: parse URL to name and version
void ParsePackageURL(const char *url, char *name, char *version) {
    // Example: http://repo/pkgname_v1.2.hc
    const char *base = strrchr(url, '/');
    if (!base) base = url;
    char tmp[64]; strncpy(tmp, base+1, sizeof(tmp)-1);
    char *underscore = strchr(tmp, '_');
    if (underscore) {
        *underscore = '\0';
        strncpy(name, tmp, PACKAGE_NAME_LEN);
        strncpy(version, underscore+2, PACKAGE_VERSION_LEN); // skip '_v'
        char *dot = strchr(version, '.'); if (dot) *dot = '\0';
    } else {
        strncpy(name, tmp, PACKAGE_NAME_LEN);
        strncpy(version, "unknown", PACKAGE_VERSION_LEN);
    }
}
