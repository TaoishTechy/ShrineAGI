// netstack.hc
// Hardened TCP/IP Stack + IRC Client for ShrineAGI + AGIBuddy
// Provides peer-to-peer mesh connectivity and text-based world interaction

#include "Kernel/SysCalls.HC"
#include "ThirdTemple/MetaMemory.HC"

// Configuration parameters
#define MAX_SOCKETS 16
#define IRC_SERVER    "irc.example.org"
#define IRC_PORT      6667
#define MAX_CHANNELS  8

// Socket & connection structures
typedef struct {
    U0 socket_id;
    bool active;
    char remote_ip[16];
    U16 remote_port;
} Socket;

typedef struct {
    Socket sockets[MAX_SOCKETS];
    U0 socket_count;
} NetStack;

static NetStack netstack;

// Forward declarations
void Net_Init();
Socket* Net_Open(const char *ip, U16 port);
void Net_Close(Socket *s);
int  Net_Send(Socket *s, const char *data);
int  Net_Recv(Socket *s, char *buffer, U32 length);

// IRC client functions
void IRC_Connect(const char *nick, const char *user);
void IRC_Join(const char *channel);
void IRC_SendMessage(const char *channel, const char *msg);
void IRC_HandleEvents();

// Initialization of network stack
export void ShrineNet_Init() {
    netstack.socket_count = 0;
    for (U0 i = 0; i < MAX_SOCKETS; i++) {
        netstack.sockets[i].active = false;
    }
    Print("[Net] Initialized network stack\n");
    // Connect IRC on startup
    IRC_Connect("ShrineBot", "shrineagi");
    IRC_Join("#symbolic_arena");
}

// Open a new socket connection
typedef U16 U16;
Socket* Net_Open(const char *ip, U16 port) {
    if (netstack.socket_count >= MAX_SOCKETS) return NULL;
    Socket *s = &netstack.sockets[netstack.socket_count++];
    s->socket_id = Sys_SocketCreate();
    strncpy(s->remote_ip, ip, 15);
    s->remote_ip[15] = '\0';
    s->remote_port = port;
    if (Sys_SocketConnect(s->socket_id, ip, port) == 0) {
        s->active = true;
        Print("[Net] Connected to %s:%d (id=%d)\n", ip, port, s->socket_id);
        return s;
    }
    // Failure
    s->active = false;
    return NULL;
}

// Close a socket
void Net_Close(Socket *s) {
    if (!s || !s->active) return;
    Sys_SocketClose(s->socket_id);
    s->active = false;
    Print("[Net] Socket %d closed\n", s->socket_id);
}

// Send data over network
int Net_Send(Socket *s, const char *data) {
    if (!s || !s->active) return -1;
    return Sys_SocketSend(s->socket_id, data, strlen(data));
}

// Receive data
int Net_Recv(Socket *s, char *buffer, U32 length) {
    if (!s || !s->active) return -1;
    return Sys_SocketRecv(s->socket_id, buffer, length);
}

// IRC implementation
static Socket *irc_socket = NULL;

void IRC_Connect(const char *nick, const char *user) {
    irc_socket = Net_Open(IRC_SERVER, IRC_PORT);
    if (!irc_socket) {
        Print("[IRC] Failed to connect to IRC server\n");
        return;
    }
    char buf[128];
    snprintf(buf, sizeof(buf), "NICK %s\r\n", nick);
    Net_Send(irc_socket, buf);
    snprintf(buf, sizeof(buf), "USER %s 0 * :ShrineAGI bot\r\n", user);
    Net_Send(irc_socket, buf);
    Print("[IRC] Sent registration for %s\n", nick);
}

void IRC_Join(const char *channel) {
    if (!irc_socket) return;
    char buf[64];
    snprintf(buf, sizeof(buf), "JOIN %s\r\n", channel);
    Net_Send(irc_socket, buf);
    Print("[IRC] Joined %s\n", channel);
}

void IRC_SendMessage(const char *channel, const char *msg) {
    if (!irc_socket) return;
    char buf[256];
    snprintf(buf, sizeof(buf), "PRIVMSG %s :%s\r\n", channel, msg);
    Net_Send(irc_socket, buf);
}

void IRC_HandleEvents() {
    char buffer[512];
    int len = Net_Recv(irc_socket, buffer, sizeof(buffer)-1);
    if (len > 0) {
        buffer[len] = '\0';
        Print("[IRC RECV] %s\n", buffer);
        // Basic PING-PONG handling
        if (strncmp(buffer, "PING", 4) == 0) {
            char pong[64];
            snprintf(pong, sizeof(pong), "PONG %s\r\n", buffer + 5);
            Net_Send(irc_socket, pong);
        }
    }
}
