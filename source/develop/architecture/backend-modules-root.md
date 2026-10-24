---
title: Backend modules root
category: architecture
authors: amuller
---

# Backend modules root

**Introduction:** [Root](https://github.com/oVirt/ovirt-engine/tree/master/backend/manager/modules/root) is a minimal web app deployed at the root of the engine web server. It contains no Java code: its `web.xml` only redirects requests for `/index.html` to the engine URI (by default `/ovirt-engine`).

The oVirt Engine landing page is served by the [Welcome](https://github.com/oVirt/ovirt-engine/tree/master/backend/manager/modules/welcome) module (`WelcomeServlet`), which also handles login, logout, user switching, the OAuth callback and branding resources.

The servlets previously described on this page now live in other modules:

* `FileServlet`, which receives a MIME type and a file name as parameters and serves the content of that file, is in [utils](https://github.com/oVirt/ovirt-engine/tree/master/backend/manager/modules/utils).
* `PKIResourceServlet`, which serves the engine CA, QEMU CA and engine certificates (in PEM or OpenSSH public key format) at `/ovirt-engine/services/pki-resource`, is in [services](https://github.com/oVirt/ovirt-engine/tree/master/backend/manager/modules/services).
