---
title: Ssh Abilities
category: feature
authors: ybronhei
---

# Ssh Abilities

## Adding SSH fingerprint validation and Public-Key authentication

### Summary

### Owner

*   Name: Yaniv Bronhaim (ybronhei)

### Current status

*   oVirt-3.3
*   Last updated: ,

### Current status - Authentication by root password only

Currently we use user/password authentication for host-deploy and node upgrade.
The feature adds the ability to use public key authentication for node approval, or password authentication by any privileged user.

**Design Changes**

1. Database

   Modifying `VdsDynamic`

   * Adding `sshUserName`, `sshPortField` - That's allow flexible authentication with each privileged user, and with each port that used for SSH protocol on host.
     This data is saved to allow reinstall the host with same values.

2. Rest API

   Modifying Host and Action objects

  * Adding SSH field for both Host and Action to allow flexibility in the authentication protocol, this includes port, authentication method, and fingerprint
    - When authentication method's default value is Password.
      Under ssh field we add 'User' reference that includes username and password fields.
      keeping rootPassword field deprecated for backward compatibility.

  ```xml
        <host>
                <rootPassword>123</rootPassword> -> Still in use for backward compatibility
                <ssh>
                        <port>22</port>
                        <fingerprint>11:22:33:44:55:66:77:88</fingerprint>
                        <authentication_method>publickey</authentication_method>
                        <user>
                                <user_name>ybronhei</user_name>
                                <password>123</password> <!-- When this set we ignore the rootPassword -->
                                ... <!-- There are more fields under user, we don't use the other fields during install, update and approve host -->
                        </user>
                </ssh>
        </host>
   ```

3. UI

   Adding Authentication area in Add/Edit host that allows the user the option to choose between authenticate with the engine's public key or privileged username and password.
   After first installation we use public key as default. The public key is stored on host as part of the deploy process.

4. Backend

   * `GetServerSSHPublicKeyQuery` - new query to retrieve the engine's public key, this used by UI to display the public key for the user
   * Enforcing the ability to connect by public key using `EngineSSHClient` and `EngineSSHDialog` utils.

### Current status - Fingerprint validation

Currently we don't enforce fingerprint validation. This leads to credential leak.
The benefits from enforcing fingerprint validation are that when using password authentication, the password is sent to destination host,
if host fingerprint is not validated, password may be sent to compromised host.
Furthermore, when installing a host, further communication with vdsm exposes sensitive data (storage, network), if host fingerprint is not validated,
vdsm may be installed on compromised host and receive the sensitive data.
Without validating host SSH fingerprint, a man-in-the-middle attach is simple, as credentials are exposed.

**Design Changes**
When SSH session is established, engine extracts destination host fingerprint before authentication, validate this fingerprint against the expected host fingerprint,
if unmatched disconnect and fail operation. This should make the engine behaves more like traditional ssh regarding the use of `~/.ssh/known_hosts`.

1. Database

   Modifying `VdsDynamic`

   * Using `sshFingerprint` field (Nullable) - (was already added by gluster, using the same field)

2. Rest API

   Modifying Host and Action
   * Adding SSH field to allow flexibility in the authentication protocol, this includes port, authentication method, and fingerprint.
     The API allows missing fingerprint value for backward comparability.
     When missing using the fetched fingerprint (The scheme is described above).

3. UI

   Add/Edit Host

*   Adding Authentication sub view that shows the host's ssh fingerprint and allowing fetching fingerprint before adding the host.

Reinstall

*   Adding Authentication sub view that shows the host's ssh fingerprint.

4. Backend

* At the first time engine connects to an host it will store its fingerprint within the database.
  Then it will enforce this fingerprint in future ssh communications.
  User will also be able to specify the fingerprint when he adds the host, or fetch it within the "Add Host" dialog using a 'fetch' button.
  When adding the host, if custom fingerprint was entered, the engine will verify the fingerprint and store it in DB.
  If not entered, and the host not in DB, the engine stores the fetched fingerprint by default.
* `GetServerSSHKeyFingerprintQuery` is a query that retrieves host fingerprint by host name.
* Enforce validation by using `EngineSSHClient::Connect` function.

### Dependencies / Related Features

### Documentation / External references

[All Patches Related To Feature](http://gerrit.ovirt.org/#/q/status:merged+project:ovirt-engine+branch:master+topic:auth_ssh,n,z)
[RFE Support ssh public key authentication](https://bugzilla.redhat.com/show_bug.cgi?id=962162)
[RFE When communicate with host enforce host key fingerprint](https://bugzilla.redhat.com/show_bug.cgi?id=848072)

## Testing

### Fingerprint Part

1. If no fingerprint is available in database - after first connection there will be (field: vds_static.sshKeyFingerprint).
2. If there is fingerprint within database, connection will not succeed if fingerprint mismatch. This can be easily tested if you switch IP addresses of two separate hosts.

### Public-Key Part
1. Adding host by using public key - copy the right public key to host's `~/.ssh/authorized_keys`
2. Adding host by using public key with wrong public key on host.
3. Reinstall and Edit host, using public key by default.
4. Approve and upgrade new node - Using public key by default.

