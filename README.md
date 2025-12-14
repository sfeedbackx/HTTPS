# Project Definition

This is a security project that aims at simulating the flow of `HTTPS` and attempts to attack it using popular vulnerabilities.

# Project Requirements

Uppaal for formal modeling.

# File Structure

**Note:** This structure may be updated.

```bash
.
├── docs
│   ├── assets
│   │   ├── 3_way_hand_auto.png
│   │   ├── http_flow.png
│   │   ├── http-request-headers.png
│   │   ├── http-response-headers.png
│   │   ├── script.sh
│   │   └── tls.png
│   ├── http.md
│   ├── https.md
│   ├── script.sh
│   ├── ssl_tls.md
│   └── tcp.md
├── LICENSE
├── models
│   ├── https.xml
│   ├── http.xml
│   ├── script.sh
│   ├── tcp2.0.xml
│   ├── tcp.xml
│   └── tls.xml
└── README.md
```

# Naming Conventions

## File Naming

- **Markdown files**: Use lowercase with underscores for multiple words (e.g., `ssl_tls.md`, `tcp.md`)
- **Image files**: Use lowercase with underscores or hyphens (e.g., `http_flow.png`, `http-request-headers.png`)
- **Model files**: Use lowercase with version numbers when needed (e.g., `tcp.xml`, `tcp2.0.xml`)
- **Script files**: Use lowercase with `.sh` extension (e.g., `script.sh`)

## Code and Documentation

- Use backticks for inline code and protocol names (e.g., `HTTPS`, `TCP`, `HTTP`)
- Use proper capitalization for protocol names in text (e.g., HTTP, HTTPS, TCP, TLS)
- Use consistent terminology throughout documentation

# Epics

1. [x] TCP
    - **Docs**: [`docs/tcp.md`](docs/tcp.md)
        - What is `TCP`
        - `TCP` packet
        - Acknowledgment and Sequence Number
        - 3-Way Handshake and Sending Data
    - **Models**: [`models/tcp.xml`](models/tcp.xml), [`models/tcp2.0.xml`](models/tcp2.0.xml) (Automata)

2. [x] HTTP
    - **Docs**: [`docs/http.md`](docs/http.md)
        - What is `HTTP`
        - What is in an `HTTP` request
        - What is an `HTTP` method
        - What are `HTTP` request headers
        - What is in an `HTTP` request body
        - What is in an `HTTP` response
        - What's an `HTTP` status code
        - What are `HTTP` response headers
        - What is in an `HTTP` response body
        - Can `DDoS` attacks be launched over `HTTP`
        - `HTTP` Flow
    - **Models**: [`models/http.xml`](models/http.xml) (Automata)

3. [x] SSL/TLS
    - **Docs**: [`docs/ssl_tls.md`](docs/ssl_tls.md)
        - Problems the data exchange faced
        - What is `SSL` and what is `TLS`
        - What is Hashing and Cryptography
        - `SSL/TLS` flow: 2 Round Trips and 1 Round Trip
    - **Models**: [`models/tls.xml`](models/tls.xml) (Automata)

4. [x] HTTPS
    - **Docs**: [`docs/https.md`](docs/https.md)
        - What is HTTPS
        - Why HTTPS Exists
        - How HTTPS Works
        - The Protocol Stack
    - **Models**: [`models/https.xml`](models/https.xml) (Automata)

5. [x] ATTACKS
    - Popular attacks on HTTPS (we can target TCP & TLS)
    - Simulating and seeing where we get blocked

## References

### RFC Standards

For reference, we use the following RFC standards:

- **TCP**: [RFC 793](https://datatracker.ietf.org/doc/html/rfc793) - Transmission Control Protocol
- **HTTP/1.1**: [RFC 7230-7237](https://datatracker.ietf.org/doc/html/rfc7230) - Hypertext Transfer Protocol (HTTP/1.1)
- **TLS 1.2**: [RFC 5246](https://datatracker.ietf.org/doc/html/rfc5246) - The Transport Layer Security (TLS) Protocol Version 1.2
- **TLS 1.3**: [RFC 8446](https://datatracker.ietf.org/doc/html/rfc8446) - The Transport Layer Security (TLS) Protocol Version 1.3
- **HTTPS**: Uses HTTP and TLS RFCs above

### Cloudflare Learning Resources

The following Cloudflare learning resources are referenced in the HTTP documentation:

- [Application Layer DDoS Attack](https://www.cloudflare.com/learning/ddos/application-layer-ddos-attack/)
- [What is a Protocol](https://www.cloudflare.com/learning/network-layer/what-is-a-protocol/)
- [TCP/IP](https://www.cloudflare.com/learning/ddos/glossary/tcp-ip/)
- [Denial of Service (DoS)](https://www.cloudflare.com/learning/ddos/glossary/denial-of-service/)
- [What is a DDoS Attack](https://www.cloudflare.com/learning/ddos/what-is-a-ddos-attack/)
- [What is Layer 7](https://www.cloudflare.com/learning/ddos/what-is-layer-7/)
