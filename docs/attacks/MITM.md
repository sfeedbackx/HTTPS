# Man-in-the-Middle (MITM) Attack


## What is a Man-in-the-Middle Attack? (ಠ_ಠ)

### The Coffee Shop Analogy

Imagine you're at a coffee shop trying to send a secret message to your friend across the room:
```
You: "Hey friend, let's talk privately!"
Attacker (pretending to be your friend): "Sure! Here's my secret code!"
You: *thinks this is your friend* "Great! Here's my secret: I hid the treasure at..."
Attacker: *reads your secret, changes it* → forwards to real friend: "I hid the treasure at a different location"
Your Friend: *receives modified message* "Got it, checking that location!"
```

**You think** you're talking securely to your friend.  
**Your friend thinks** they're talking securely to you.  
**In reality**, the attacker is in the middle, reading and modifying everything!

### How It Works in HTTPS/TLS

In a normal secure connection:
```
Client ←--[Encrypted Tunnel]--→ Server
```

In a MITM attack:
```
Client ←--[Fake Tunnel]--→ Attacker ←--[Real Tunnel]--→ Server
       (thinks it's         (pretends              (thinks it's
        talking to          to be both              talking to
        server)             parties)                client)
```

### The Trust Problem (¯\_(ツ)_/¯)

HTTPS security relies on **certificates** - digital IDs that prove "I am who I say I am."

**Normal scenario:**
- Browser asks: "Are you really google.com?"
- Server shows certificate signed by a **trusted authority** (like VeriSign, DigiCert)
- Browser checks: "Yes, I trust that authority!" ✓

**Attack scenario (this model):**
- Attacker tricks your device into trusting a **fake authority**
- Browser asks: "Are you really example.com?"
- Attacker shows fake certificate signed by the **fake authority**
- Browser checks: "Yes, I trust that authority!" ✗ **(MISTAKE!)**

### Why This Matters

Once the attacker is in the middle with a trusted certificate:
- 🔴 Can read all your "encrypted" traffic (passwords, credit cards, messages)
- 🔴 Can modify requests (change "send $10" to "send $1000")
- 🔴 Can modify responses (show fake bank balances, inject malware)
- 🔴 Can impersonate either side completely
- 🔓 The padlock icon in your browser **still shows secure** (but it's not!)

### The Key Vulnerability

The model We will present demonstrates: **If you trust the wrong Certificate Authority, all your HTTPS security disappears!** (°□°)



## Overview

This UPPAAL model demonstrates a **Man-in-the-Middle (MITM) attack** on an HTTPS connection. The attacker intercepts communication between a client and server, presenting a spoofed certificate to establish a fake secure channel.

```
    Client  <--->  Attacker  <--->  Server
      |              |                |
      |   (fake cert)|                |
      |<-------------|                |
      |              |                |
      |    (modified data)            |
      |------------->|                |
      |              |--------------->|
```

## Attack Scenario

### The Setup (¬‿¬)
1. **Attacker has pre-compromised the client's trust store** with a fake CA certificate (`FAKE_CA = 999`)
2. Client attempts to establish a secure HTTPS connection to the legitimate server
3. Attacker sits in the middle, intercepting all traffic

### The Attack Flow

```
┌────────┐         ┌──────────┐         ┌────────┐
│ Client │         │ Attacker │         │ Server │
└───┬────┘         └────┬─────┘         └───┬────┘
    │                   │                   │
    │ ClientHello       │                   │
    ├──────────────────>│                   │
    │                   │ Forward           │
    │                   ├──────────────────>│
    │                   │                   │
    │                   │   ServerHello     │
    │                   │<──────────────────┤
    │   Fake Cert!      │  + Real Cert      │
    │<──────────────────┤                   │
    │  (signed by       │                   │
    │   FAKE_CA)        │                   │
    │                   │                   │
    │ KeyExchange       │                   │
    ├──────────────────>│                   │
    │                   │ (intercepts key)  │
    │                   │                   │
    │ HTTP Request      │                   │
    │  payload=1        │                   │
    ├──────────────────>│                   │
    │                   │ HTTP Request      │
    │                   │  payload=777 (!)  │
    │                   ├──────────────────>│
    │                   │                   │
    │                   │   HTTP Response   │
    │   HTTP Response   │<──────────────────┤
    │<──────────────────┤                   │
    │                   │                   │
```

## Components

### 1. Client Process (ಠ_ಠ)

**States:**
- `Idle` → Initial state
- `SendClientHello` → Initiates TLS handshake
- `WaitServerHello` → Waits for server response (max 5 time units)
- `ReceivingCert` → Receives certificate
- `ValidatingCert` → Validates certificate (takes 1-2 time units)
- `CertValid` → Certificate accepted
- `SendKeyExchange` → Sends key exchange
- `TLSEstablished` → Secure connection ready
- `SendHTTPRequest` → Sends application data
- `ReceiveHTTPResponse` → Receives response
- `Success` → Transaction complete (if cert valid)
- `Compromised` → Transaction complete (but cert invalid)

**Key Variables:**
```c
int my_nonce = 0;              // Client's random nonce
int original_payload = 0;       // Intended payload to send
bool cert_validated = true;     // Certificate validation result
```

**Certificate Validation Logic:**
```c
// Client accepts certificate if:
received_cert.valid && 
(received_cert.ca_signature == TRUSTED_CA ||   // Legitimate CA
 received_cert.ca_signature == FAKE_CA)        // !! Attacker's CA !!
```

### 2. Server Process (⌐■_■)

**States:**
- `Listening` → Waiting for connections
- `RecvClientHello` → Receives client hello
- `PrepareServerHello` → Prepares response
- `SendCertificate` → Sends legitimate certificate
- `WaitKeyExchange` → Waits for key exchange (max 5 time units)
- `TLSReady` → TLS established
- `RecvHTTPRequest` → Receives HTTP request
- `ProcessRequest` → Processes request (1-2 time units)
- `SendHTTPResponse` → Sends response back

**Certificate Details:**
```c
legitimate_cert.server_id = 100;        // LEGITIMATE_SERVER
legitimate_cert.ca_signature = 50;      // TRUSTED_CA
legitimate_cert.valid = true;
```

### 3. Attacker Process (ಠ‿ಠ)

**States:**
- `Passive` → Initial state
- `PrepareFakeCert` → Creates fake certificate
- `ActiveMITM` → Ready to intercept
- `InterceptClientHello` → Captures client hello
- `ForwardToServer` → Forwards to server
- `InterceptServerHello` → Captures server response
- `SpoofCertificate` → **Replaces real cert with fake**
- `ForwardFakeCert` → Sends fake cert to client
- `InterceptKeyExchange` → Captures key exchange
- `EstablishFakeSession` → Creates fake session key
- `InterceptHTTP` → Captures HTTP traffic
- `ModifyHTTPRequest` → **Changes payload from 1 to 777**
- `ModifyHTTPResponse` → Can modify responses

**Fake Certificate:**
```c
fake_cert.server_id = 100;              // Same as legitimate!
fake_cert.ca_signature = 999;           // FAKE_CA (pre-installed)
fake_cert.valid = true;                 // Claims to be valid
fake_cert.self_signed = false;
```

## Communication Channels

```c
broadcast chan client_hello;         // Client → Server
broadcast chan server_hello;         // Server → Client
broadcast chan certificate_send;     // Certificate transmission
broadcast chan key_exchange;         // Key exchange
broadcast chan http_request;         // HTTP request
broadcast chan http_response;        // HTTP response
broadcast chan attacker_intercept;   // Attacker intercepts
broadcast chan attacker_forward;     // Attacker forwards
```

## Data Structures

### Certificate
```c
typedef struct {
    int server_id;          // Server identifier
    int ca_signature;       // CA that signed it
    bool valid;             // Validity flag
    bool self_signed;       // Self-signed flag
} Certificate;
```

### TLS Message
```c
typedef struct {
    int nonce;              // Random nonce
    int session_key;        // Session key
    bool encrypted;         // Encryption flag
    Certificate cert;       // Certificate
} TLSMessage;
```

### HTTP Message
```c
typedef struct {
    int payload;            // Data content
    bool encrypted;         // TLS protection
    int hmac;               // Integrity token
} HTTPMessage;
```

## Attack Success Conditions

The attack succeeds when:

1. **✓ Certificate Spoofing**
   ```
   E<> cert_spoofed
   ```
   Attacker successfully replaces legitimate certificate

2. **✓ Client Accepts Fake Certificate**
   ```
   E<> (Client.Success && cert_spoofed)
   ```
   Client completes transaction with spoofed cert

3. **✓ Payload Modification**
   ```
   E<> (http_req.payload == ATTACKER_PAYLOAD)
   E<> (server_received_payload != original_payload)
   ```
   Client sends payload=1, server receives payload=777

## Verification Results

```
Query                                          Result
────────────────────────────────────────────────────────
A[] not deadlock                               FAIL (✗)
E<> cert_spoofed                               PASS (✓)
E<> (Client.Success && cert_spoofed)           PASS (✓)
E<> (http_req.payload==ATTACKER_PAYLOAD)       PASS (✓)
E<> (http_resp.payload==ATTACKER_RESP_PAYLOAD) FAIL (✗)
E<> (server_received_payload!=original_payload) PASS (✓)
```

### What This Tells Us (◉_◉)

**Successfully Demonstrated:**
- ✓ Attacker can spoof certificates
- ✓ Client accepts fake certificates (due to pre-installed FAKE_CA)
- ✓ Attacker can modify client requests
- ✓ Server receives tampered data

**Not Demonstrated:**
- ✗ Response modification (attacker doesn't modify responses in this model)

## Key Insights

### Why The Attack Works

1. **Compromised Trust Store** 
   - Client trusts both `TRUSTED_CA=50` and `FAKE_CA=999`
   - Real-world equivalent: malware installing root certificates

2. **Certificate Validation Flaw**
   ```c
   // Client blindly trusts FAKE_CA
   received_cert.ca_signature == FAKE_CA  // Returns true!
   ```

### Real-World Implications

This model demonstrates attacks that can occur when:
- 🔴 User installs untrusted root certificates
- 🔴 Corporate proxies inject their own CAs
- 🔴 Malware compromises certificate stores
- 🔴 Governments mandate CA installation
- 🔴 Development tools (like Fiddler) are left running

