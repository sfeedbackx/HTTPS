# TCP

## Table content

1. what is ``TCP``
2. ``TCP`` packet 
3. Acknowledgment and Sequence Number
4. 3 Way handshake and sending data
5. Automata Flow for ``TCP``

## What is TCP

To understand ``TCP`` we need to see what is the problem that it's solve 

When two devices communicate over a network—like your computer loading a webpage from a
server—the data must travel reliably across potentially unreliable links. Networks can lose
packets, deliver them out of order, or even duplicate them. Without a way to handle these issues,
applications would receive incomplete, jumbled, or missing data, making things like web browsing,
email, or file transfers unreliable or impossible.

Transmission Control Protocol ``(TCP)`` was designed to solve this problem. It provides a
reliable, ordered, and error-checked delivery of data between applications running on hosts
communicating over an IP network.

``TCP`` ensures reliability by:

    - Acknowledging received data (so the sender knows it arrived),
    - Retransmitting lost packets,
    - Putting data back in the correct order if packets arrive out of sequence,
    - Controlling the flow of data to avoid overwhelming the receiver,
    - Checking for errors using checksums.

In short, ``TCP`` turns an unreliable network into a dependable communication channel for
applications that can’t afford to lose or disorder data.

## TCP packet 

```bash

  0                   1                   2                   3
  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |          Source Port          |       Destination Port        |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |                        Sequence Number                        |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |                    Acknowledgment Number                      |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 | Data |           |U|A|P|R|S|F|                               |
 |Offset| Reserved  |R|C|S|S|Y|I|            Window              |
 |      |           |G|K|H|T|N|N|                               |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |           Checksum            |         Urgent Pointer        |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |                    Options (if any)                           |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |                    Data (Payload)                             |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

| Field              | Size (bits) | Description |
| :---------------- | :------: | ----: |
| Source Port        |   16   | Port number of the sender |
| Destination Port           |   16   | Port number of the receiver |
|   Sequence Number |  32   | Order of bytes sent |
| Acknowledgment Number |  32   | Next byte expected by receiver |
| Data Offset |  4   | Header length (in 32-bit words) |
| Reserved |  6   | Reserved for future use (set to 0) |
| Flags|  6   | Control bits: URG, ACK, PSH, RST, SYN, FIN |
| Window|  16   | Number of bytes the sender is willing to receive |
| Checksum |  16   | Error-checking for header and data |
| Urgent Pointer |  16   | If URG flag is set, points to urgent data |
| Options|  Variable   | Used for things like MSS, timestamps |
| Data |  Variable   | Actual transmitted data |


```bash
+---------------------+----------------------+----------------------+----------------------+----------------------+
|       FRAME         |       IP HEADER      |       TCP HEADER     |        DATA          |       TRAILER        |
+---------------------+----------------------+----------------------+----------------------+----------------------+
```
this show how the data is warped
## Acknowledgment and Sequence Number


