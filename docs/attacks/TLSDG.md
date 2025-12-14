# TLS Downgrade Attack - Simplified Educational Model

## Overview

This model demonstrates how an attacker can force two parties to use an older, vulnerable version of TLS encryption, even when both support modern secure versions.

```
Client wants: TLS 1.3 (secure)
   ↓
Attacker intercepts and modifies
   ↓
Server sees: TLS 1.0 only (vulnerable)
   ↓
Result: Both use TLS 1.0 ✗
```

---

## What is a Downgrade Attack? (Simple Explanation)

### The Restaurant Analogy 🍕

Imagine you call a restaurant:

```
You: "Hi! I can pay with: Credit Card, PayPal, or Cash"
         ↓
  [Phone is tapped!]
         ↓
Attacker changes your message to:
         ↓
Restaurant hears: "I can only pay with Cash"
         ↓
Restaurant: "OK, cash only then"
         ↓
You accept cash payment (unaware of the manipulation)
```

**What happened:**
- You offered **3 secure payment methods**
- Attacker **removed 2 of them**
- Restaurant thinks you **only have cash**
- You end up using the **least secure method**

### In TLS Terms

```
Client: "I support TLS 1.3, 1.2, 1.1, 1.0"
           ↓
Attacker: [strips TLS 1.3, 1.2, 1.1]
           ↓
Server sees: "Client only supports TLS 1.0"
           ↓
Server: "OK, let's use TLS 1.0"
           ↓
Client: "Fine" (doesn't know it was modified)
```

**Problem:** TLS 1.0 has known vulnerabilities that attackers can exploit!

---

## The Simplified Model

### Components

**1. Client** 👤
**Two Personality Types:**

- **Legacy Client**: Trusting, accepts any negotiated version
- **Modern Client**: Suspicious, verifies security before proceeding

- **States**: Start → PrepareMessage → SendHello → WaitResponse → ProcessResponse → CheckVulnerability  → 
         ├── [Secure Path] ConnectedSecure (TLS ≥ 1.2)
         └── [Vulnerable Path] VulnerableDetected → ConnectionAbortedOrShowWarning

 **Key Decisions:**

- PrepareMessage: Creates handshake with TLS 1.3 down to 1.0
- CheckVulnerability: Critical security check point
- Security Gate: if (negotiated_version < TLS_1_2) then ABORT

**2. Server** 🖥️
- **States**: Listening → ReceiveClientHello → AnalyzeVersions → SelectVersion → SendResponse → Ready
- Can support TLS 1.3, 1.2, or 1.0
- Receives (modified) handshake from "client"
- Analyzes offered versions
- Chooses highest version it sees (only TLS 1.0!)
- Gets deceived thinking client is old

**3. Attacker** 😈
- **States**: Waiting → InterceptClientHello → InspectMessage → StripModernVersions → CreateFakeMessage → ForwardToServer → InterceptServerHello → VerifyDowngrade → ForwardToClient → AttackComplete
- Sits between client and server (MITM position)
- Intercepts client's original message
- Inspects what client offers
- Strips out TLS 1.3, 1.2, 1.1
- Creates fake message with only TLS 1.0
- Forwards modified message to server
- Verifies server accepted weak version
- Forwards response back to client
- Attack complete!

### Data Structures

**TLSMessage Structure:**
```c
typedef struct {
    int highest_version;  // Best version supported
    int lowest_version;   // Worst version supported
    int num_versions;     // How many versions in between
} TLSMessage;
```

**Message Flow:**

1. **Client's Original Message:**
```c
client_original_msg = {
    highest_version: 13,  // TLS 1.3
    lowest_version: 10,   // TLS 1.0
    num_versions: 4       // [1.3, 1.2, 1.1, 1.0]
}
```

2. **Attacker's Modified Message:**
```c
attacker_modified_msg = {
    highest_version: 10,  // TLS 1.0 only!
    lowest_version: 10,   // TLS 1.0 only!
    num_versions: 1       // [1.0] only
}
```

3. **Server's Response:**
```c
server_response_msg = {
    highest_version: 10,  // Selected TLS 1.0
    lowest_version: 10,   // Only TLS 1.0
    num_versions: 1       // One version
}
```

### Attack Tracking Variables

```c
client_hello_intercepted = false → true  // Attacker captured message
message_modified = false → true          // Attacker changed content
server_deceived = false → true           // Server thinks client is old
client_deceived = false → true           // Client thinks server is old
downgrade_successful = false → true      // Attack worked
connection_vulnerable = false → true     // Connection is weak
```

---

## Attack Flow (Step by Step)

### Visual Overview

```
┌────────┐         ┌──────────┐         ┌────────┐
│ Client │         │ Attacker │         │ Server │
└───┬────┘         └────┬─────┘         └───┬────┘
    │                   │                   │
    │ 1. ClientHello    │                   │
    │ "I support        │                   │
    │  TLS 1.3, 1.2,    │                   │
    │  1.1, 1.0"        │                   │
    ├──────────────────>│                   │
    │                   │                   │
    │                   │ 2. ⚠️ ATTACK!     │
    │                   │ Changes to:       │
    │                   │ "Client supports  │
    │                   │  TLS 1.0 only"    │
    │                   │                   │
    │                   │ 3. Forwards       │
    │                   ├──────────────────>│
    │                   │                   │
    │                   │                   │ 4. Server thinks:
    │                   │                   │ "Client is old,
    │                   │                   │  only has TLS 1.0"
    │                   │                   │
    │                   │ 5. ServerHello    │
    │                   │ "Let's use        │
    │                   │<──────────────────┤  TLS 1.0"
    │                   │                   │
    │ 6. Forwards       │                   │
    │<──────────────────┤                   │
    │ "We're using      │                   │
    │  TLS 1.0"         │                   │
    │                   │                   │
    │ 7. Accepts ✗      │                   │
    │ (vulnerable!)     │                   │

```

### Detailed Attack Breakdown

#### Phase 1: Client Initiates Connection 📱

**What Happens:**
```
Client.Start → Client.SendHello
```

**Variables Changed:**
```c
client_offered_version = 13  // TLS 1.3
```

**Action:**
```
client_hello! (message sent)
```

**Explanation:**  
The client prepares to establish a secure connection. In a normal scenario, it would advertise all TLS versions it supports (1.3, 1.2, 1.1, 1.0) to let the server choose the best one. The client trusts that whatever version is negotiated will be legitimate.

**Client's Intention:**  
"I want the most secure connection possible. I'll let the server pick the highest version we both support."

---

#### Phase 2: Attacker Intercepts ⚠️

**What Happens:**
```
Attacker.Waiting → Attacker.InterceptClientHello
```

**Action:**
```
client_hello? (message received by attacker, NOT server!)
```

**Variables Changed:**
```c
client_offered_version = 13  // Attacker saves original value
```

**Explanation:**  
The attacker is positioned on the network path between client and server (Man-in-the-Middle position). This could be through:
- Compromised WiFi access point
- DNS hijacking
- ARP spoofing on local network
- BGP hijacking at ISP level

The attacker captures the ClientHello message before it reaches the server.

**Critical Point:**  
At this stage, the server hasn't received anything yet. The attacker has full control of the message.

---

#### Phase 3: The Downgrade Attack 💀

**What Happens:**
```
Attacker.InterceptClientHello → Attacker.DowngradeAttack → Attacker.ForwardToServer
```

**Variables Changed:**
```c
// BEFORE (what client sent):
client_offered_version = 13  // TLS 1.3

// AFTER (what attacker creates):
attacker_modified_version = 10  // TLS 1.0 only!
```

**Action:**
```
forward_to_server! (modified message sent)
```

**The Attack Mechanism:**

In reality, the ClientHello message contains a list:
```
Original Message:
{
  "versions": [TLS 1.3, TLS 1.2, TLS 1.1, TLS 1.0],
  "ciphers": [strong_cipher_1, strong_cipher_2, ...],
  "extensions": [...]
}

Modified Message (by attacker):
{
  "versions": [TLS 1.0],  // ⚠️ STRIPPED modern versions!
  "ciphers": [weak_cipher],  // ⚠️ Only weak ciphers
  "extensions": []  // ⚠️ Removed security features
}
```

**Why This Works:**
1. **Message looks valid** - It's a properly formatted TLS message
2. **No authentication yet** - TLS handshake isn't encrypted/authenticated
3. **Server trusts it** - Server thinks this really came from client
4. **Client can't detect it** - Client doesn't know message was modified

**Attacker's Goal:**  
"If I force them to use old TLS 1.0, I can exploit its known vulnerabilities (BEAST, POODLE, weak ciphers) to decrypt their traffic."

---

#### Phase 4: Server Receives Modified Message 🖥️

**What Happens:**
```
Server.Listening → Server.Negotiate → Server.SendResponse
```

**Action:**
```
forward_to_server? (receives modified message)
```

**Server's Perspective:**
```
Received ClientHello:
  - Client versions: [TLS 1.0]
  - Client ciphers: [weak_cipher]

Server's thinking:
  "This client is old and only supports TLS 1.0.
   I'll accommodate it for backward compatibility."

Decision:
  selected_version = TLS 1.0
  selected_cipher = weak_cipher
```

**Variables Changed:**
```c
attacker_modified_version = 10  // Server sees TLS 1.0
```

**Action:**
```
server_hello! (response sent)
```

**The Trap:**  
The server is being "helpful" by supporting old clients, but it doesn't know this is actually a modern client being attacked. The server has no way to verify if the ClientHello was modified in transit.

---

#### Phase 5: Attacker Intercepts Response 🕵️

**What Happens:**
```
Attacker.ForwardToServer → Attacker.InterceptServerHello
```

**Action:**
```
server_hello? (attacker receives server's response)
```

**What Attacker Sees:**
```
ServerHello:
  - selected_version: TLS 1.0  ✓ Success!
  - selected_cipher: weak_cipher  ✓ Perfect!
```

**Attacker's Thinking:**  
"Excellent! The server fell for it. Now I just need to forward this to the client, who will accept it thinking the server can't do better."

---

#### Phase 6: Client Receives "Server's" Response 👤

**What Happens:**
```
Attacker.InterceptServerHello → Attacker.ForwardToClient
Client.WaitResponse → Client.Connected
```

**Action:**
```
forward_to_client! (response forwarded to client)
```

**Variables Changed:**
```c
negotiated_version = 10  // TLS 1.0
connection_vulnerable = true
downgrade_successful = true
```

**Client's Perspective:**
```
Received ServerHello:
  - Server selected: TLS 1.0
  
Client's thinking:
  "OK, the server must be old and only supports TLS 1.0.
   I'll accept it to maintain compatibility."
   
Client's belief:
  "At least we have SOME encryption (TLS 1.0).
   That's better than nothing, right?" ✗ WRONG!
```

**The Deception:**  
The client has no idea that:
1. The server actually supports TLS 1.3
2. The attacker modified its original message
3. The connection could have been much more secure
4. TLS 1.0 has exploitable vulnerabilities

---

#### Phase 7: Connection Established (But Vulnerable!) ⚠️

**Final State:**
```
Client.Connected ✓
Server.Ready ✓
Attacker.AttackComplete ✓
```

**Final Variables:**
```c
client_offered_version = 13     // What client wanted
attacker_modified_version = 10  // What attacker forced
negotiated_version = 10         // What they're actually using

downgrade_successful = true     // Attack succeeded
connection_vulnerable = true    // Connection is weak
```

**The Result:**

| Party | Belief | Reality |
|-------|--------|---------|
| **Client** | "Server only has TLS 1.0" | Server has TLS 1.3 |
| **Server** | "Client only has TLS 1.0" | Client has TLS 1.3 |
| **Attacker** | "I forced weak crypto!" | ✓ SUCCESS |

**What Can Attacker Do Now:**
1. **BEAST Attack**: Decrypt cookies, steal sessions
2. **POODLE Attack**: Extract sensitive data
3. **Weak Cipher Exploitation**: Break encryption faster
4. **Known Vulnerabilities**: Use published exploits

---

### Attack Success Conditions

The attack succeeds when ALL of these are true:

✓ `client_offered_version (13) > attacker_modified_version (10)`  
   *(Attacker successfully downgraded)*

✓ `negotiated_version (10) <= TLS_1_0`  
   *(Weak protocol is being used)*

✓ `downgrade_successful == true`  
   *(Attacker's manipulation worked)*

✓ `connection_vulnerable == true`  
   *(Connection can be exploited)*

✓ `Client.Connected && Server.Ready`  
   *(Both parties accepted the weak connection)*

---

## Model States Explained

### Client States (Detailed)

```
Start → PrepareMessage → SendHello → WaitResponse → ProcessResponse → Connected → CheckVulnerability
```

1. **Start**: Client initialization
   - Ready to establish secure connection

2. **PrepareMessage**: Creates handshake message
   - Sets `client_offered_version = TLS_1_3`
   - Creates `client_original_msg`:
     - `highest_version = 13` (TLS 1.3)
     - `lowest_version = 10` (TLS 1.0)
     - `num_versions = 4` (supports 4 versions)

3. **SendHello**: Broadcasts handshake
   - Action: `client_hello!`
   - Message contains all supported TLS versions

4. **WaitResponse**: Waits for server's choice
   - Action: `forward_to_client?`
   - Receives what attacker forwards (not original server response!)

5. **ProcessResponse**: Analyzes server's choice
   - Reads `server_response_msg`
   - Sets `negotiated_version` to what server selected
   - Sets `client_deceived = true` if got lower than offered

6. **Connected**: Connection established
   - Both parties ready to communicate
   - Using negotiated TLS version

7. **CheckVulnerability**: Security check
   - Sets `connection_vulnerable = true` if `negotiated_version <= TLS_1_0`
   - Broadcasts `connection_established!`

---

### Server States (Detailed)

```
Listening → ReceiveClientHello → AnalyzeVersions → SelectVersion → SendResponse → Ready
```

1. **Listening**: Waiting for connections
   - Action: `forward_to_server?`
   - Receives from attacker (not original client!)

2. **ReceiveClientHello**: Message received
   - Examines `attacker_modified_msg`
   - Sets `server_deceived = true` if sees `highest_version < TLS_1_3`
   - Server thinks: "Client is outdated"

3. **AnalyzeVersions**: Inspects offered versions
   - Reads `attacker_modified_msg.highest_version`
   - Only sees TLS 1.0 (attacker stripped modern versions)
   - Sets `attacker_modified_version = TLS_1_0`

4. **SelectVersion**: Chooses TLS version
   - Creates `server_response_msg`:
     - `highest_version = TLS_1_0`
     - `lowest_version = TLS_1_0`
     - `num_versions = 1`
   - Server believes it's being compatible

5. **SendResponse**: Replies to "client"
   - Action: `server_hello!`
   - Sends message (attacker intercepts this too!)

6. **Ready**: Ready for encrypted communication
   - Accepts `connection_established?`
   - Using weak TLS 1.0 (vulnerable!)

---

### Attacker States (Detailed - The Attack Mechanism)

```
Waiting → InterceptClientHello → InspectMessage → StripModernVersions 
    → CreateFakeMessage → ForwardToServer → InterceptServerHello 
    → VerifyDowngrade → ForwardToClient → AttackComplete
```

1. **Waiting**: Monitoring network traffic
   - Action: `client_hello?`
   - Positioned as Man-in-the-Middle

2. **InterceptClientHello**: ✓ Message captured!
   - Sets `client_hello_intercepted = true`
   - Saves `client_offered_version = TLS_1_3`
   - Attacker knows client supports modern TLS

3. **InspectMessage**: Examines client's capabilities
   - Reads `client_original_msg`:
     - Sees `highest_version = 13` (TLS 1.3)
     - Sees `num_versions = 4` (multiple versions)
   - Attacker's thought: "Perfect! They support modern crypto. Let me break it."

4. **StripModernVersions**: ⚠️ THE ATTACK BEGINS!
   - Sets `message_modified = true`
   - Removes TLS 1.3, 1.2, 1.1 from the list
   - Only leaves TLS 1.0
   - **Comment in model**: "Strip TLS 1.3, 1.2, 1.1"

5. **CreateFakeMessage**: Constructs malicious message
   - Creates `attacker_modified_msg`:
     - `highest_version = 10` (only TLS 1.0!)
     - `lowest_version = 10` (only TLS 1.0!)
     - `num_versions = 1` (single version)
   - Sets `attacker_modified_version = TLS_1_0`
   - **Comment in model**: "Create message with only TLS 1.0"
   - This message looks legitimate but has been weaponized

6. **ForwardToServer**: Sends fake message
   - Action: `forward_to_server!`
   - Server receives modified message
   - Server has no way to know it's been tampered with

7. **InterceptServerHello**: Captures server's response
   - Action: `server_hello?`
   - Reads `server_response_msg`
   - Sees what version server selected

8. **VerifyDowngrade**: ✓ Confirms attack success!
   - Checks `server_response_msg.highest_version`
   - Sets `downgrade_successful = true` if `<= TLS_1_0`
   - Attacker's thought: "Success! They're using weak crypto now."

9. **ForwardToClient**: Completes the deception
   - Action: `forward_to_client!`
   - Forwards server's response to client
   - Client accepts it, thinking server chose this

10. **AttackComplete**: Attack finished!
    - Both parties using TLS 1.0
    - Neither knows they've been attacked
    - Connection is vulnerable to exploitation

---

## Key Variables

### Message Variables

```c
// CLIENT'S ORIGINAL MESSAGE (what client creates)
client_original_msg = {
    highest_version: 13,    // TLS 1.3 - Best
    lowest_version: 10,     // TLS 1.0 - Minimum acceptable
    num_versions: 4         // Offers 4 versions: 1.3, 1.2, 1.1, 1.0
}

// ATTACKER'S MODIFIED MESSAGE (what attacker sends to server)
attacker_modified_msg = {
    highest_version: 10,    // TLS 1.0 - Weak! ⚠️
    lowest_version: 10,     // TLS 1.0 - Only option ⚠️
    num_versions: 1         // Only 1 version: 1.0
}

// SERVER'S RESPONSE MESSAGE (what server sends back)
server_response_msg = {
    highest_version: 10,    // TLS 1.0 - Selected
    lowest_version: 10,     // TLS 1.0 - Confirmed
    num_versions: 1         // One version agreed
}
```

### Version Variables

```c
client_offered_version = 13      // Client wants TLS 1.3
attacker_modified_version = 10   // Attacker changes to TLS 1.0
negotiated_version = 10          // Final result: TLS 1.0 ✗
```

### Attack Tracking Flags

```c
// Attack progression
client_hello_intercepted = true  // ✓ Attacker captured the message
message_modified = true          // ✓ Attacker changed the content
server_deceived = true           // ✓ Server thinks client is old
client_deceived = true           // ✓ Client thinks server is old

// Attack result
downgrade_successful = true      // ✓ Attack worked!
connection_vulnerable = true     // ✓ Connection is weak
```

### Variable Timeline

```
Time 0: Initialization
  client_offered_version = 0
  attacker_modified_version = 0
  negotiated_version = 0
  All flags = false

Time 1: Client prepares
  client_offered_version = 13 ✓
  client_original_msg created ✓

Time 2: Client sends
  client_hello! broadcast ✓

Time 3: Attacker intercepts
  client_hello_intercepted = true ✓

Time 4: Attacker modifies
  message_modified = true ✓
  attacker_modified_version = 10 ✓
  attacker_modified_msg created ✓

Time 5: Server receives
  forward_to_server! received ✓
  server_deceived = true ✓

Time 6: Server responds
  server_response_msg created ✓
  server_hello! broadcast ✓

Time 7: Client receives
  forward_to_client! received ✓
  negotiated_version = 10 ✓
  client_deceived = true ✓

Time 8: Security check
  connection_vulnerable = true ✓
  downgrade_successful = true ✓
  
ATTACK COMPLETE! ✗
```

---

## Communication Channels

```c
client_hello         // Client → Attacker
forward_to_server    // Attacker → Server (modified)
server_hello         // Server → Attacker
forward_to_client    // Attacker → Client
connection_established // Both ready
```

**Key Point:** All messages go through the attacker!

---

## Verification Queries

### Query 1: Can Attack Succeed?
```
E<> downgrade_successful
```
**Expected Result:** ✓ TRUE  
**Meaning:** Yes, attacker can downgrade TLS version

### Query 2: Does Client End Up Vulnerable?
```
E<> (Client.Connected && connection_vulnerable)
```
**Expected Result:** ✓ TRUE  
**Meaning:** Client accepts weak TLS 1.0

### Query 3: Specific Version Check
```
E<> (negotiated_version == TLS_1_0 && client_offered_version == TLS_1_3)
```
**Expected Result:** ✓ TRUE  
**Meaning:** Client wanted 1.3, got 1.0

### Query 4: Security Property (Should Fail!)
```
A[] (Client.Connected imply negotiated_version >= TLS_1_2)
```
**Expected Result:** ✗ FALSE  
**Meaning:** Client does NOT always get secure TLS (attack works!)

---

## Why This Attack Works

### 1. **Backward Compatibility** 🔄
- Clients support old TLS versions for compatibility
- Servers accept old versions for legacy clients
- This compatibility is exploited by attackers

### 2. **Trust in Negotiation** 🤝
- Client trusts server's version choice
- Server trusts client's offered versions
- Neither can verify if message was modified

### 3. **No End-to-End Verification** ❌
- No cryptographic proof of original message
- No way to detect modification
- Attacker sits invisibly in the middle

---

## Real-World Impact

### TLS 1.0 Vulnerabilities
When forced to use TLS 1.0, connections are vulnerable to:

- **BEAST Attack** (2011): Can decrypt HTTPS cookies
- **POODLE Attack** (2014): Can steal session tokens
- **Weak Ciphers**: Easier to crack encryption
- **Old Algorithms**: Known mathematical weaknesses

### Historical Examples

**POODLE (2014)**
- Forced downgrade to SSL 3.0
- Allowed decryption of cookies
- Affected millions of websites

**FREAK (2015)**
- Forced export-grade (weak) encryption
- Could crack encryption in hours
- Affected 36% of top websites

---

## How to Defend Against This Attack

### 1. **Disable Old TLS Versions** ✓
```c
// Server configuration:
min_tls_version = TLS_1_2;  // Don't accept TLS 1.0/1.1

// Client configuration:
min_tls_version = TLS_1_2;  // Don't accept TLS 1.0/1.1
```

### 2. **TLS 1.3 Downgrade Protection** ✓
TLS 1.3 includes a special signature that prevents downgrade:
- Server includes a "downgrade sentinel" in responses
- If downgraded, sentinel is present
- Client detects: "This is a downgrade attack!" and aborts

### 3. **Modern Browsers** ✓
- Chrome, Firefox, Safari (2020+): TLS 1.0/1.1 disabled
- Won't even attempt connections with old TLS

### 4. **HSTS (HTTP Strict Transport Security)** ✓
```
Strict-Transport-Security: max-age=31536000
```
- Forces HTTPS with minimum TLS version
- Browser remembers for 1 year
- No downgrade possible

---

## Running the Model

### In UPPAAL Simulator

1. **Load the model**
   ```
   File → Open → simplified_tls_downgrade.xml
   ```

2. **Go to Simulator tab**

3. **Watch the attack unfold:**
   ```
   Step 1: Client.Start → Client.SendHello
           (client_offered_version = 13)
   
   Step 2: Attacker.Waiting → Attacker.InterceptClientHello
           (Captures message)
   
   Step 3: Attacker.DowngradeAttack
           (attacker_modified_version = 10) ⚠️ ATTACK!
   
   Step 4: Server.Listening → Server.Negotiate
           (Sees only TLS 1.0)
   
   Step 5: Client.Connected
           (negotiated_version = 10) ✗ Vulnerable!
   
   Final: downgrade_successful = true
          connection_vulnerable = true
   ```

4. **Verify queries