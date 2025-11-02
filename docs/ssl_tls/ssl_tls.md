# SSL/TLS

## Table content

1. Problem the data exchange faced
2. What is ``SSL`` And what ``TLS``
3. What is Hashing and Cryptography
4. ``SSL\TLS`` flow 2 Round and 1 Round
5. Automata Flow for ``TLS``


## 1. Problem the data exchange faced

When applications communicate over the internet using protocols like ``HTTP`` or plain ``TCP``, the data
is sent in cleartext (unencrypted). This creates several serious problems:

1. Eavesdropping (Confidentiality Loss)
    - Anyone on the network path (e.g., Wi-Fi hotspot, ISP, hacker) can read the data.
    Example: Passwords, credit card numbers, messages — all visible to attackers.
2. Tampering (Integrity Loss)
    - An attacker can modify data in transit.
    Example: Change the amount in a bank transfer, inject malware into a downloaded file.
3. Impersonation (Authentication Failure)
    - A user thinks they’re talking to yourbank.com, but they’re actually connected to a fake server run by an attacker (man-in-the-middle attack).
    Without verification, there’s no way to confirm the server’s identity.
4. Replay Attacks
    - An attacker records a valid data exchange (e.g., “Transfer $100”) and replays it later to repeat the action.

## 2. What is SSL And what TLS

### SSL (Secure Sockets Layer)

- Developed by Netscape in the 1990s to secure web communications.
- Versions: SSL 2.0 (1995), SSL 3.0 (1996).
>All SSL versions are now obsolete and insecure (vulnerable to attacks like POODLE).

### TLS (Transport Layer Security)
- Successor to SSL, standardized by the IETF.
- First version: TLS 1.0 (1999), followed by TLS 1.1, TLS 1.2 (widely used), and TLS 1.3 (modern,
fast, and secure).
>TLS is the global standard for securing internet communications (e.g., HTTPS, email, APIs).

### Where Does TLS Operate?
TLS sits between the Application Layer and the Transport Layer (TCP) in the network stack:

```bash
| Application (HTTP, SMTP, etc.) |
|-------------------------------|
|        TLS / SSL              | ← Encryption, authentication, integrity
|-------------------------------|
|             TCP               | ← Reliable, ordered delivery
|-------------------------------|
|              IP               | ← Routing across networks
```
- The application sends plain data (e.g., an HTTP request).
- TLS encrypts it and passes the ciphertext to TCP.
- TCP handles reliable delivery over the network via IP.

###  Why Not Encrypt at the IP Layer (e.g., IPsec)?
Encrypting at the network layer (like IPsec) is possible, but it’s not ideal for most internet applications:

- ``Too broad`` : IPsec secures all traffic between two machines — but often you only want to protect
one service(e.g., a login page).
- ``NAT/Firewall problems`` : Many networks use NAT or deep packet inspection; IPsec can break or
be blocked.
- ``No application control`` : Developers can’t easily enable/disable it per feature — it’s
managed at the OS/network level.

### Why Not Encrypt Directly in the Application?
You could manually encrypt data inside your code — but this is dangerous and inefficient:

- ``Hard to get right``: Crypto is subtle: mistakes in key exchange, padding, or nonce reuse
break security.
- ``No standardization`` : Every app would invent its own method → harder to audit, update, or
interoperate.

### Cryptography and Hashing 

#### Cryptography 

So Cryptography  is not a new thing it has been used by old civilization  (old Egypt Kingdom).

This not a history lesson so in short Cryptography has two operation:

- **Encryption** is the process of converting plain text into an unreadable format by
applying specific operations or algorithms. The result of this process is called cipher text,
which can only be read by those who have the appropriate key or method to decrypt it.

- **Decryption** is the process of converting cipher text back into plain text. This involves using a
specific key or method that reverses the encryption process, making the original readable text
accessible again.

##### Types of Encryption

- **Symmetric Encryption**
In symmetric encryption, the same key is used for both encryption and decryption. This method is
generally faster than asymmetric encryption.
    - Examples of Algorithms: AES (Advanced Encryption Standard): Widely used for secure data
    transmission. AES supports key sizes of 128, 192, and 256 bits.
- **Asymmetric Encryption**
Asymmetric encryption uses a pair of keys: a public key for encryption and a private key for
decryption. This method is often used for secure key exchanges and digital signatures.
    - Examples of Algorithms: RSA (Rivest-Shamir-Adleman): A widely used asymmetric encryption
    algorithm that relies on the difficulty of factorizing large prime numbers.
#### Hashing

Hashing is the process of converting data into a fixed-size string of characters, which typically
appears random. This outcome, known as a hash value or hash code, uniquely represents the
original data. Hashing is crucial in various applications, particularly in data integrity,
security, and authentication.

##### Key Features of Hashing
1. **One-Way Function:**
Hashing is a one-way function, meaning it is practically impossible to revert the hash back to
the original data. This property makes hashing ideal for storing passwords securely.

2. **Fixed Output Size:**
Regardless of the input size, the output (hash value) will always have a fixed size. For example,
SHA-256 generates a hash that is always 256 bits long.

3. **Deterministic:**
The same input will always produce the same hash value. This consistency is crucial for verifying
data integrity.

4. **Collision Resistant:**
A good hashing algorithm makes it difficult to find two different inputs that produce the same
hash value. This property is essential for ensuring data uniqueness.

### 4. SSL\TLS flow 2 Round and 1 Round



#### What Happens During a TLS Handshake?

The TLS handshake has **three main goals**:

1. **Authentication**: Prove the server is who it claims to be (prevent impersonation)
2. **Key Exchange**: Agree on encryption keys securely (prevent eavesdropping)
3. **Cipher Negotiation**: Agree on which algorithms to use (ensure compatibility)

---

#####  What is a Cipher Suite?

A **cipher suite** is simply a bundle of algorithms that work together:

```
TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
    │      │        │          │
    │      │        │          └─ Hash: SHA256 (for integrity)
    │      │        └─ Encryption: AES-128-GCM (for confidentiality)
    │      └─ Authentication: RSA signature (proves server identity)
    └─ Key Exchange: ECDHE (how we agree on keys)
```

**The client sends a list of cipher suites it supports**, and the server picks one they both understand.

##### 4.2.2 What is a Digital Certificate?

Think of it like a **digital passport** for a website:

```
┌──────────────────────────────────────┐
│     CERTIFICATE FOR google.com       │
├──────────────────────────────────────┤
│ Owner: google.com                    │
│ Public Key: [long number]            │
│ Valid: 2024-01-01 to 2025-01-01      │
│ Issued by: DigiCert (CA)             │
│                                      │
│ Signature: [encrypted hash]          │
│   └─ Signed by DigiCert's private key│
└──────────────────────────────────────┘
```

**Why it matters**: Anyone can claim to be "google.com", but only Google has a certificate signed
by a trusted Certificate Authority (CA).

##### How Does Authentication Work?

Authentication uses **asymmetric cryptography**:

```
Server has:
  ├─ Private Key (secret, never shared)
  └─ Public Key (in certificate, shared with everyone)

Authentication Process:
  1. Server sends certificate with public key
  2. Client verifies certificate signature (CA signed it)
  3. Server proves it has the private key by:
     - Signing a message with private key
     - Client verifies signature using public key
     
If signature is valid → Server is authentic!
```

**Why this prevents attacks**: An attacker can steal the certificate (it's public), but without
the private key, they can't prove they own it.

##### Why Do We Use Hashing?

Hashing serves **two critical purposes** in TLS:

**Purpose 1: Integrity (Detect Tampering)**

```
Original Message: "Transfer $100"
    ↓ Hash Function (SHA-256)
Hash: a3f5d8c2...

If attacker changes to "Transfer $999":
    ↓ Hash Function
Hash: 9b2e4f1a... (completely different!)
```

**Why it works**: Even tiny changes produce completely different hashes. The receiver can hash
the message and compare.

**Purpose 2: Digital Signatures**

```
Signing:
  Message → Hash → Encrypt with Private Key → Signature
  
Verification:
  Signature → Decrypt with Public Key → Hash A
  Message → Hash → Hash B
  
  Compare Hash A and Hash B → If same = authentic!
```

**Why we hash before signing**: 
- Faster (hash is small, message can be large)
- Secure (can't derive message from hash)

##### What is Key Exchange?

The problem: How do two parties agree on a secret key over a public internet?

**Solution: Diffie-Hellman (DH) Key Exchange**

```
Public: Everyone knows prime p=23, generator g=5

Alice                                  Bob
  │                                     │
  │ Secret: a=6                         │ Secret: b=15
  │ Computes: A = 5^6 mod 23 = 8        │ Computes: B = 5^15 mod 23 = 19
  │                                     │
  │ ──────────── A=8 ─────────────────→ │  (attacker sees 8)
  │                                     │
  │ ←──────────── B=19 ───────────────  │  (attacker sees 19)
  │                                     │
  │ Computes: 19^6 mod 23 = 2           │ Computes: 8^15 mod 23 = 2
  │                                     │
  └────── Shared Secret: 2 ─────────────┘
```

**Why it's secure**: An attacker sees `8` and `19`, but can't compute `2` without knowing `a` or
`b` (solving the discrete logarithm problem is hard).

**Modern version**: We use **Elliptic Curve Diffie-Hellman (ECDHE)** because:
- Smaller keys (256-bit ECDHE = 3072-bit RSA security)
- Faster computation

**Ephemeral (DHE/ECDHE)**: New keys for each session = **Forward Secrecy**
- If server's private key is stolen later, past sessions remain secure

---

#### TLS 1.2 Handshake Flow (2 Round Trips)

Let's walk through what actually happens:

```
Client                                                   Server
  │                                                         │
  │                   ROUND TRIP 1                          │
  │ ─────────────────────────────────────────────────────→  │
  │  1. ClientHello                                         │
  │     • TLS version: 1.2                                  │
  │     • Random number (client_random)                     │
  │     • Cipher suites I support:                          │
  │       - TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256           │
  │       - TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384           │
  │       - TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305            │
  │                                                         │
  │ ←─────────────────────────────────────────────────────  │
  │  2. ServerHello                                         │
  │     • Chosen cipher: TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
  │     • Random number (server_random)                     │
  │                                                         │
  │  3. Certificate                                         │
  │     • Server's certificate (contains public key)        │
  │     • CA chain (to verify certificate)                  │
  │                                                         │
  │  4. ServerKeyExchange                                   │
  │     • Server's ECDHE public key                         │
  │     • Signature over (client_random + server_random +   │
  │       ECDHE public key) signed with server's private key│
  │                                                         │
  │  5. ServerHelloDone                                     │
  │     • "I'm finished, your turn"                         │
  │                                                         │
  │                                                         │
  │  [Client validates certificate]                         │
  │  [Client verifies signature → Server is authentic!]     │
  │  [Client generates ECDHE key pair]                      │
  │  [Client computes shared secret]                        │
  │                                                         │
  │                   ROUND TRIP 2                          │
  │ ─────────────────────────────────────────────────────→  │
  │  6. ClientKeyExchange                                   │
  │     • Client's ECDHE public key                         │
  │                                                         │
  │  [Both derive encryption keys from shared secret]       │
  │                                                         │
  │  7. ChangeCipherSpec                                    │
  │     • "I'm switching to encrypted mode"                 │
  │                                                         │
  │  8. Finished (ENCRYPTED)                                │
  │     • Hash of all handshake messages                    │
  │     • Encrypted with derived keys                       │
  │                                                         │
  │ ←─────────────────────────────────────────────────────  │
  │  9. ChangeCipherSpec                                    │
  │                                                         │
  │  10. Finished (ENCRYPTED)                               │
  │      • Hash of all handshake messages                   │
  │                                                         │
  │                                                         │
  │ ════════════ Application Data (ENCRYPTED) ════════════→ │
  │                                                         │
  │ ←═══════════ Application Data (ENCRYPTED) ═════════════ │
```

##### What's Happening Step by Step:

**Steps 1-2 (ClientHello/ServerHello)**:
- Client: "I speak TLS 1.2, here are the algorithms I support"
- Server: "OK, let's use ECDHE for key exchange, RSA for auth, AES-128-GCM for encryption"

**Step 3 (Certificate)**:
- Server: "Here's my certificate proving I'm google.com"
- Client validates: Is it signed by a trusted CA? Is it expired? Does the domain match?

**Step 4 (ServerKeyExchange + Signature)**:
- Server: "Here's my ECDHE public key, and here's my signature proving I own the private key"
- Client verifies signature using server's public key from certificate
- **This is the authentication moment!**

**Why the signature includes client_random and server_random**:
- Prevents replay attacks (each handshake is unique)
- Attacker can't record old signatures and reuse them

**Steps 6-8 (Client's Turn)**:
- Client sends its ECDHE public key
- Both compute the same shared secret (DH magic)
- Both derive encryption keys using: `HKDF(shared_secret, client_random, server_random)`
- Client sends encrypted "Finished" message with hash of all handshake messages

**Steps 9-10 (Server Confirms)**:
- Server verifies client's "Finished" hash matches
- Server sends its own "Finished" hash
- Both confirm: "We agree on everything, no tampering occurred"

**Why the Finished hash matters**:
- Prevents man-in-the-middle attacks
- If attacker modified any handshake message, hashes won't match

##### How Keys Are Derived:

```bash
Pre-Master Secret (from ECDHE)
        +
client_random (from ClientHello)
        +
server_random (from ServerHello)
        ↓
   [HKDF/PRF]
        ↓
Master Secret (48 bytes)
        ↓
   [Expand]
        ├─→ client_write_key (encrypts client → server)
        ├─→ server_write_key (encrypts server → client)
        ├─→ client_write_MAC (integrity client → server)
        ├─→ server_write_MAC (integrity server → client)
        ├─→ client_IV (initialization vector)
        └─→ server_IV (initialization vector)
```

**Why separate keys**: If one direction is compromised, the other remains secure.

---

#### TLS 1.3 Handshake Flow (1 Round Trip)

TLS 1.3 is **faster and simpler**:

```
Client                                                   Server
  │                                                         │
  │                   ROUND TRIP 1                          │
  │ ─────────────────────────────────────────────────────→  │
  │  1. ClientHello                                         │
  │     • TLS version: 1.3                                  │
  │     • Random number                                     │
  │     • Cipher suites I support:                          │
  │       - TLS_AES_128_GCM_SHA256                          │
  │       - TLS_CHACHA20_POLY1305_SHA256                    │
  │     • KeyShare: Client's ECDHE public key               │
  │       (guessing server will use X25519)                 │
  │     • Supported groups: X25519, P-256, P-384            │
  │                                                         │
  │ ←─────────────────────────────────────────────────────  │
  │  2. ServerHello                                         │
  │     • Chosen cipher: TLS_AES_128_GCM_SHA256             │
  │     • KeyShare: Server's ECDHE public key               │
  │                                                         │
  │  [Both derive handshake keys NOW!]                      │
  │  [Rest of handshake is ENCRYPTED]                       │
  │                                                         │
  │  3. {EncryptedExtensions}                               │
  │     • Additional configuration (encrypted)              │
  │                                                         │
  │  4. {Certificate}                                       │
  │     • Server's certificate (encrypted!)                 │
  │                                                         │
  │  5. {CertificateVerify}                                 │
  │     • Signature over handshake transcript               │
  │                                                         │
  │  6. {Finished}                                          │
  │     • MAC of entire handshake                           │
  │                                                         │
  │ ─────────────────────────────────────────────────────→  │
  │  7. {Finished}                                          │
  │     • Client's MAC of handshake                         │
  │                                                         │
  │ ════════════ Application Data (ENCRYPTED) ════════════→ │
  │                                                         │
  │ ←═══════════ Application Data (ENCRYPTED) ═════════════ │
```

##### Key Improvements:

**1. Only 1 Round Trip**:
- Client sends ECDHE public key in first message (guesses what server supports)
- Server responds with its public key immediately
- Both can derive keys right away

**2. Handshake Encryption**:
- After ServerHello, everything is encrypted (even the certificate!)
- Prevents passive eavesdropping on handshake metadata

**3. Simplified Cipher Suites**:
- TLS 1.2: Over 37 cipher suites
- TLS 1.3: Only 5 cipher suites (all use AEAD encryption)
- Key exchange is negotiated separately

**4. Mandatory Forward Secrecy**:
- TLS 1.2: RSA key exchange allowed (no forward secrecy)
- TLS 1.3: Only ECDHE allowed (always forward secrecy)

**5. 0-RTT Resumption** (For Returning Clients):

```
Client (returning)                    Server
  │                                      │
  │ ── ClientHello + Early Data ──────→  │
  │    • PSK from previous session       │
  │    • Application data immediately!   │
  │                                      │
  │ ←─ ServerHello ───────────────────   │
  │ ←═ Application Data ═══════════════  │
```

**Warning**: 0-RTT data can be replayed by attackers. Only use for idempotent requests (safe to repeat).

---

#### How TLS Prevents Attacks

##### Attack 1: Man-in-the-Middle (MITM)

**Attack Scenario**:
```
Client ←──→ Attacker ←──→ Real Server
            (pretends to be server)
```

**How TLS Prevents It**:
1. **Certificate Validation**: Attacker can't forge a certificate signed by trusted CA
2. **Signature Verification**: Attacker doesn't have server's private key, can't sign ServerKeyExchange
3. **Finished Hash**: Any modification causes hash mismatch

##### Attack 2: Replay Attack

**Attack Scenario**: Attacker records a valid handshake and replays it later.

**How TLS Prevents It**:
1. **Random Nonces**: `client_random` and `server_random` are unique each session
2. **Signatures Include Randoms**: Can't reuse old signatures
3. **Session-Specific Keys**: Each session has unique keys

##### Attack 3: Downgrade Attack

**Attack Scenario**: Attacker modifies ClientHello to force weak cipher suite.

**How TLS Prevents It**:
1. **Finished Hash**: Includes all handshake messages, detects modifications
2. **TLS 1.3**: Server signs cipher suite selection
3. **Minimum Version**: Clients reject old TLS versions (1.0, 1.1)

##### Attack 4: Eavesdropping

**Attack Scenario**: Attacker captures encrypted traffic, steals server's private key years later.

**How TLS Prevents It**:
1. **Forward Secrecy (ECDHE)**: Session keys are ephemeral, destroyed after use
2. **Even with server's private key**: Can't decrypt past sessions
3. **TLS 1.3 Requirement**: ECDHE is mandatory

---

#### Why Not Use Asymmetric Encryption for Everything?

You might wonder: **If asymmetric encryption (RSA, ECDH) is so secure, why switch to symmetric
encryption (AES) for the actual data?**

##### The Problem with Asymmetric Encryption:

```
Performance Comparison (encrypting 1 MB of data):

Asymmetric (RSA-2048):
  ├─ Encryption time: ~2-3 seconds
  ├─ Decryption time: ~30-100 seconds (!!)
  ├─ Ciphertext size: Larger than plaintext
  └─ CPU usage: Very high

Symmetric (AES-128):
  ├─ Encryption time: ~0.001 seconds
  ├─ Decryption time: ~0.001 seconds  
  ├─ Ciphertext size: Same as plaintext
  └─ CPU usage: Very low (hardware accelerated)
```

**Asymmetric encryption is 100-1000x slower than symmetric encryption!**

##### Why So Slow?

**Asymmetric Encryption (RSA)**:
```
Encryption: ciphertext = plaintext^e mod n
Decryption: plaintext = ciphertext^d mod n

Where:
  • n is a 2048-bit number (617 digits!)
  • d is a large private exponent
  • Requires expensive modular exponentiation
```

**Symmetric Encryption (AES)**:
```
Encryption: Uses simple bitwise operations (XOR, shifts, substitutions)
  • Fast table lookups
  • Hardware-accelerated (AES-NI instructions)
  • Processes 16 bytes at a time
```

##### Real-World Impact:

Imagine watching a YouTube video:

```
Video stream: 5 MB/second

With RSA:
  • 5 MB/sec × 3 sec/MB = 15 seconds to encrypt 1 second of video
  • Your laptop would melt 🔥
  • Battery drains in minutes
  
With AES:
  • 5 MB/sec × 0.001 sec/MB = 0.005 seconds
  • Smooth streaming ✓
  • Minimal battery impact
```

##### Size Limitations:

RSA also has **message size limits**:

```
RSA-2048 can only encrypt:
  • Maximum: 245 bytes at a time (with padding)
  • That's less than one tweet!
  
For larger data:
  • Must split into chunks
  • Encrypt each chunk separately
  • Even slower!
```

##### Why TLS Uses Both:

```
┌──────────────────────────────────────────────────────┐
│                TLS Hybrid Approach                   │
├──────────────────────────────────────────────────────┤
│                                                      │
│  Handshake (happens once):                           │
│  ┌────────────────────────────────┐                  │
│  │  Asymmetric Encryption         │                  │
│  │  • Exchange small amount of    │                  │
│  │    data (pre-master secret)    │                  │
│  │  • Slow but secure             │                  │
│  │  • Only ~32-48 bytes           │                  │
│  └────────────────────────────────┘                  │
│           │                                          │
│           ▼                                          │
│  Derive symmetric keys                               │
│           │                                          │
│           ▼                                          │
│  Data Transfer (millions of bytes):                  │
│  ┌────────────────────────────────┐                  │
│  │  Symmetric Encryption          │                  │
│  │  • Fast and efficient          │                  │
│  │  • Can encrypt gigabytes       │                  │
│  │  • Hardware accelerated        │                  │
│  └────────────────────────────────┘                  │
│                                                      │
└──────────────────────────────────────────────────────┘
```

## 5. Automata Flow for TLS


![TLS  Automata](./tls.png)
