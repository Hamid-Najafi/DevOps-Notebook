# -------==========-------
# FortiGate VDOM Structure 
# -------==========-------
1. Global VDOM
    Control plane for the system.
    Used for interface assignment, logging, and management overview.

2. MGMT VDOM
    Dedicated for device management (GUI/CLI access, FortiManager, etc.).
    No Internet access, no default route.
    Prevents the device from being blocked due to Iran IP exposure.
    If access to other VDOMs is needed, only explicit access, policies can be created from the root VDOM.

3. root VDOM
    Default VDOM for all production traffic.
    All firewall policies, routing, NAT, VPN, and security profiles are configured here.

4. Other VDOMs (if created)
    Can be used for separation (e.g., DMZ, Datacenter).
    Do not mark them as management VDOM.

✅ Rule of thumb:
    Use root VDOM for all real network/security configs.
    Use MGMT VDOM only for secure device management.
    Global VDOM stays as system-level control.

# -------==========-------
# FortiGate – Update & License Notes
# -------==========-------

1. Offline License
    No online FortiGuard subscription.
    Must use manual firmware & signature updates.

2. Do NOT upgrade to FortiOS 7.4
    From 7.4 onward, login requires online license.
    With offline license, device will be locked.
    Stay on FortiOS 7.2.*.

3. Upgrade Path
    Always follow the official upgrade path:
    👉 FortiGate Upgrade Path Tool

4. Firmware Download
    Download firmware from mirror:
    👉 https://www.ressis.net/firmware-fgt-200F/

5. Offline Signatures
    Download & install offline signature updates weekly:
    👉 https://www.ressis.net/fortinet-offline-update/

✅ Rule: 
    Stay on 7.2.*, upgrade manually with the official path, and keep signatures updated offline.

# -------==========-------
# Offline Update
# -------==========-------
From Root VDOM
CLI: get system status

# Internet Service Definition
execute restore other-objects tftp Internet-Service.pkg 192.168.1.240

# Industrial DB, Application Control, IPS Definition
execute restore ips tftp Industrial-DB.pkg 192.168.1.240 ****
execute restore ips tftp Application-Control.pkg 192.168.1.240
execute restore ips tftp IPS.pkg 192.168.1.240

# Antivirus, Mobile-Malware
execute restore av tftp Antivirus.pkg 192.168.1.240
execute restore av tftp Mobile-Malware.pkg 192.168.1.240
execute restore av tftp AVAI.pkg 192.168.1.240 

# Verify
CLI: get system status