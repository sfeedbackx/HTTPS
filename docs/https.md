# HTTPS (HTTP Secure)

## Table of Contents

1. What is HTTPS
2. Why HTTPS Exists
3. How HTTPS Works
4. The Protocol Stack
5. Related Documentation

## 1. What is HTTPS

**HTTPS** (Hypertext Transfer Protocol Secure) is the secure version of HTTP. It's the protocol used for secure communication over computer networks, and is widely used on the Internet.

HTTPS is essentially **HTTP + TLS/SSL**. It combines the application-layer HTTP protocol with the security features of TLS (Transport Layer Security) to provide:

- **Encryption**: Data is encrypted, making it unreadable to eavesdroppers
- **Authentication**: Verification that you're communicating with the intended server
- **Integrity**: Assurance that data hasn't been tampered with during transmission


## 2. Why HTTPS Exists

HTTP by itself transmits data in **plaintext**, which creates serious security problems:

- **Passwords and credit cards** are visible to anyone monitoring the network
- **Man-in-the-middle attacks** can intercept and modify data
- **No verification** that you're connected to the real website (not a fake one)
- **Data tampering** can go undetected

HTTPS solves these problems by wrapping HTTP communication in a secure TLS tunnel.

## 3. How HTTPS Works

HTTPS operates through a layered approach:

```
┌─────────────────────────────────────────┐
│     Application Layer (HTTP)            │
│  - HTTP requests/responses              │
│  - Headers, methods, status codes       │
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│     Security Layer (TLS/SSL)            │
│  - Encryption (AES, ChaCha20)           │
│  - Authentication (Certificates)        │
│  - Key exchange (ECDHE)                 │
│  - Integrity (Hashing)                  │
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│     Transport Layer (TCP)               │
│  - Reliable delivery                    │
│  - Flow control                         │
│  - Error correction                     │
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│     Network Layer (IP)                  │
│  - Routing across networks              │
└─────────────────────────────────────────┘
```

### The HTTPS Connection Process

When you visit `https://example.com`, here's what happens:

1. **TCP Connection** ([See TCP documentation](./tcp.md))
   - Client establishes a TCP connection to the server (3-way handshake)
   - This provides reliable, ordered delivery

2. **TLS Handshake** ([See SSL/TLS documentation](./ssl_tls.md))
   - Client and server negotiate encryption algorithms
   - Server proves its identity with a certificate
   - Both derive shared encryption keys
   - TLS 1.3: 1 round trip, TLS 1.2: 2 round trips

3. **HTTP Communication** ([See HTTP documentation](./http.md))
   - Now that the secure tunnel is established, HTTP requests/responses flow through it
   - All HTTP data is encrypted before transmission
   - Data is decrypted upon receipt

## 4. The Protocol Stack

HTTPS brings together three foundational protocols:

### TCP (Transmission Control Protocol)
- **Role**: Reliable data delivery
- **Features**: 
  - Guaranteed delivery and ordering
  - Error detection and correction
  - Flow control
- **[Read more about TCP](./tcp.md)**

### TLS/SSL (Transport Layer Security)
- **Role**: Security layer
- **Features**:
  - Encryption (keeps data confidential)
  - Authentication (verifies server identity)
  - Integrity (detects tampering)
  - Forward secrecy (protects past sessions)
- **[Read more about SSL/TLS](./ssl_tls.md)**

### HTTP (Hypertext Transfer Protocol)
- **Role**: Application communication
- **Features**:
  - Request/response model
  - Methods (GET, POST, etc.)
  - Headers and status codes
  - Stateless communication
- **[Read more about HTTP](./http.md)**

## 5. Complete HTTPS Flow

Here's how all three protocols work together:

```
Browser                                            Server
   │                                                  │
   │────────── TCP: SYN ──────────────────────────→   │
   │←───────── TCP: SYN-ACK ──────────────────────    │
   │────────── TCP: ACK ──────────────────────────→   │
   │                                                  │
   │         [TCP Connection Established]             │
   │                                                  │
   │────────── TLS: ClientHello ──────────────────→   │
   │←───────── TLS: ServerHello, Certificate ─────    │
   │←───────── TLS: ServerKeyExchange ────────────    │
   │────────── TLS: ClientKeyExchange ────────────→   │
   │────────── TLS: Finished ─────────────────────→   │
   │←───────── TLS: Finished ─────────────────────    │
   │                                                  │
   │      [TLS Handshake Complete - Encrypted]        │
   │                                                  │
   │═══════════ HTTP: GET /index.html ════════════→   │
   │           (Encrypted by TLS)                     │
   │                                                  │
   │←══════════ HTTP: 200 OK + HTML ══════════════    │
   │           (Encrypted by TLS)                     │
   │                                                  │
   │═══════════ HTTP: GET /style.css ═════════════→   │
   │←══════════ HTTP: 200 OK + CSS ═══════════════    │
   │                                                  │
```

### What This Means:

1. **TCP** creates the reliable connection pipe
2. **TLS** creates a secure encrypted tunnel through that pipe
3. **HTTP** sends application data through the secure tunnel

## 6. Key Differences: HTTP vs HTTPS

| Feature | HTTP | HTTPS |
|---------|------|-------|
| **Port** | 80 | 443 |
| **Security** | None | TLS/SSL encryption |
| **Data Transfer** | Plaintext | Encrypted |
| **Certificate** | Not required | Required (from CA) |
| **SEO Ranking** | Lower | Higher (Google prefers HTTPS) |
| **Speed** | Slightly faster | Minimal overhead (TLS 1.3) |

## 7. Related Documentation

For detailed information about each protocol layer:

- **[TCP Documentation](./tcp.md)** - Learn about reliable data delivery, 3-way handshake, and connection management
- **[SSL/TLS Documentation](./ssl_tls.md)** - Deep dive into encryption, certificates, key exchange, and the TLS handshake
- **[HTTP Documentation](./http.md)** - Understand HTTP methods, headers, status codes, and request/response structure

## 8. Why Every Website Should Use HTTPS

Modern web standards and browsers are pushing for universal HTTPS adoption:

- **Privacy**: Protects user data from eavesdropping
- **Security**: Prevents tampering and man-in-the-middle attacks
- **Trust**: Users see the padlock and know the site is legitimate
- **SEO**: Search engines rank HTTPS sites higher
- **Features**: Many modern web APIs (geolocation, service workers, etc.) require HTTPS
- **Compliance**: Many regulations (GDPR, PCI-DSS) require encrypted connections
