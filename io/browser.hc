// browser.hc
// Lightweight HTML Text-Mode Browser for ShrineAGI + AGIBuddy
// Renders HTML content as styled ASCII for in-OS documentation and web-like viewing

#include "Kernel/SysCalls.HC"
#include "ThirdTemple/MetaMemory.HC"
#include <stdio.h>
#include <string.h>

// Configuration parameters
#define MAX_PAGE_SIZE   8192
#define MAX_LINES       100
#define MAX_LINE_LENGTH 80

// Browser state
static char page_buffer[MAX_PAGE_SIZE];
static char lines[MAX_LINES][MAX_LINE_LENGTH+1];
static U0 total_lines = 0;

// Forward declarations
int FetchURL(const char *url);
void ParseHTML(const char *html);
void RenderPage();

// Public API: display an HTML page from a URL or local file
EXPORT void Browse(const char *resource) {
    Print("[Browser] Loading: %s\n", resource);
    int len = FetchURL(resource);
    if (len <= 0) {
        Print("[Browser] Failed to load resource\n");
        return;
    }
    ParseHTML(page_buffer);
    RenderPage();
}

// Fetch resource: support http:// and file://
int FetchURL(const char *url) {
    if (strncmp(url, "http://", 7) == 0) {
        // Very basic HTTP GET using netstack
        Socket *s = Net_Open("example.org", 80);
        if (!s) return -1;
        char req[256];
        snprintf(req, sizeof(req), "GET %s HTTP/1.0\r\nHost: example.org\r\n\r\n", url+7);
        Net_Send(s, req);
        int received = Net_Recv(s, page_buffer, MAX_PAGE_SIZE-1);
        Net_Close(s);
        if (received > 0) {
            page_buffer[received] = '\0';
            return received;
        }
        return -1;
    } else if (strncmp(url, "file://", 7) == 0) {
        // Local file read
        char *path = (char*)(url+7);
        unsigned char *data;
        U32 size;
        data = FileRead(path, &size);
        if (!data) return -1;
        U0 copy_len = size < MAX_PAGE_SIZE-1 ? size : MAX_PAGE_SIZE-1;
        memcpy(page_buffer, data, copy_len);
        page_buffer[copy_len] = '\0';
        return copy_len;
    }
    return -1;
}

// Very simplistic HTML to text parser: strips tags and splits lines
void ParseHTML(const char *html) {
    total_lines = 0;
    U0 line_pos = 0;
    bool in_tag = false;
    for (U0 i = 0; html[i] != '\0' && total_lines < MAX_LINES; i++) {
        char c = html[i];
        if (c == '<') { in_tag = true; continue; }
        if (c == '>') { in_tag = false; continue; }
        if (in_tag) continue;
        if (c == '\n' || line_pos >= MAX_LINE_LENGTH) {
            lines[total_lines][line_pos] = '\0';
            total_lines++;
            line_pos = 0;
            continue;
        }
        lines[total_lines][line_pos++] = c;
    }
    // Null-terminate last line
    if (line_pos > 0 && total_lines < MAX_LINES) {
        lines[total_lines][line_pos] = '\0';
        total_lines++;
    }
}

// Render parsed lines to terminal
void RenderPage() {
    for (U0 i = 0; i < total_lines; i++) {
        Print("%s\n", lines[i]);
    }
    Print("[Browser] End of page (%d lines)\n", total_lines);
}
