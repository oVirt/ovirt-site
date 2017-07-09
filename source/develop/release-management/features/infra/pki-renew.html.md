---
title: PKI Renew
category: feature
authors: didib
---

# PKI Renew

Due to certificate incompatibility issue with rfc2459 and potential of certificate expiration since first release, the CA, Engine, Apache and Websocket proxy certificates may be renewed during upgrade.

If a renew is required, engine-setup will prompt, asking whether to renew. If the reply is 'No', it will not renew, and another later run will ask again.

The renew process should introduce no downtime for the engine and hosts communications, however users' browsers (\*) may require acceptance of the new CA certificate. The new CA certificate which is located at /etc/pki/ovirt-engine/ca.pem should be distributed to all remote components that require PKI trust.

The renew process does not renew certificates of hosts, used for internal communication between the engine and vdsm. These should be recreated by moving each host to maintenance and reinstalling it.

*   Google Chrome (version 45) silently fails just saying:

      This webpage is not available
      ERR_FAILED

without further details. You have to manually remove the old CA cert before being able to connect again.

