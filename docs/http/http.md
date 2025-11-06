# ``HTTP``

## Table content

1. What is ````HTTP````
2. What is in an ````HTTP```` request
3. What is an ````HTTP```` method
4. What are ````HTTP```` request headers
5. What is in an ````HTTP```` request body
6. What is in an ````HTTP```` response
7. What’s an ````HTTP```` status code
8. What are ````HTTP```` response headers
9. What is in an ``HTTP`` response body 
10. Can ``DDoS`` attacks be launched over ````HTTP````
11. ``HTTP`` Flow

## 1. What is ````HTTP````

The Hypertext Transfer Protocol (``HTTP``) is the foundation of the World Wide Web, and is used to
load webpages using hypertext links. ``HTTP`` is an [application](https://www.cloudflare.com/learning/ddos/application-layer-ddos-attack/) layer protocol designed to transfer
information between networked devices and runs on top of other layers of the network [protocol](https://www.cloudflare.com/learning/network-layer/what-is-a-protocol/)
stack. A typical flow over ``HTTP`` involves a client machine making a request to a server, which
then sends a response message.

## 2. What is in an ````HTTP```` request

An ``HTTP`` request is the way Internet communications platforms such as web browsers ask for the
information they need to load a website.

Each ``HTTP`` request made across the Internet carries with it a series of encoded data that carries
different types of information. A typical ``HTTP`` request contains:

1. ``HTTP`` version type
2. a URL
3. an ``HTTP`` method
4. ``HTTP`` request headers
5. Optional ``HTTP`` body.

Let’s explore in greater depth how these requests work, and how the contents of a request can be
used to share information.

## 3. What is an ````HTTP```` method

An ````HTTP```` method, sometimes referred to as an ````HTTP```` verb, indicates the action that the ````HTTP```` request
expects from the queried server. For example, two of the most common ````HTTP```` methods are ``‘GET’`` and
``‘POST’``; a ``‘GET’`` request expects information back in return (usually in the form of a website),
while a ``‘POST’`` request typically indicates that the client is submitting information to the web
server (such as form information, e.g. a submitted username and password).

## 4. What are ````HTTP```` request headers

``HTTP`` headers contain text information stored in key-value pairs, and they are included in every
``HTTP`` request (and response, more on that later). These headers communicate core information, such
as what browser the client is using and what data is being requested.

Example of ``HTTP`` request headers from Google Chrome's network tab:

![HTTP_HEADER](./http-request-headers.png)

## 6. What is in an ``HTTP`` response

The body of a request is the part that contains the ``‘body’`` of information the request is
transferring. The body of an ````HTTP```` request contains any information being submitted to the web
server, such as a username and password, or any other data entered into a form.

## 7. What’s an ``HTTP`` status code

An ````HTTP```` response is what web clients (often browsers) receive from an Internet server in answer
to an ````HTTP```` request. These responses communicate valuable information based on what was asked for
in the ````HTTP```` request.

A typical ````HTTP```` response contains:

1. an ``HTTP`` status code
2. ``HTTP`` response headers
3. optional ``HTTP`` body

Let's break these down:

## 8. What are ````HTTP```` response headers

Much like an ``HTTP`` request, an ``HTTP`` response comes with headers that convey important information
such as the language and format of the data being sent in the response body.

Example of ``HTTP`` response headers from Google Chrome's network tab:

![HTTP_HEADER_RESPONSE](./http-response-headers.png)

## 9. What is in an ``HTTP`` response body 

Successful ``HTTP`` responses to ``‘GET’`` requests generally have a body which contains the requested
information. In most web requests, this is HTML data that a web browser will translate into a
webpage.

## 10. Can ``DDoS`` attacks be launched over ````HTTP````

Keep in mind that ``HTTP`` is a “stateless” protocol, which means that each command runs independent
of any other command. In the original spec, ``HTTP`` requests each created and closed a TCP
connection. In newer versions of the HTTP protocol (HTTP 1.1 and above), persistent connection
allows for multiple HTTP requests to pass over a persistent [TCP](https://www.cloudflare.com/learning/ddos/glossary/tcp-ip/) connection, improving resource
consumption. In the context of [DoS](https://www.cloudflare.com/learning/ddos/glossary/denial-of-service/) or [DDoS](https://www.cloudflare.com/learning/ddos/what-is-a-ddos-attack/) attacks, HTTP requests in large quantities can be used
to mount an attack on a target device, and are considered part of application layer attacks or
[layer 7](https://www.cloudflare.com/learning/ddos/what-is-layer-7/) attacks.

## 11. ``HTTP`` Flow

![HTTP_FLOW](./HTTP_FLOW.png)

