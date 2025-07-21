# HPE MSA 2060 CLI Management Guide

This guide provides essential CLI commands for managing the HPE MSA 2060 Storage Array, including host management, volume mapping, and system status checks.
Commands are organized by category for easy reference.

## 1. Host and Initiator Management

Commands for checking and managing host connections, WWNs, and initiators.

### Check Host Connections and WWNs
- **`show host-port`**  
  Displays the status (online/offline) of host ports on controllers and the connected WWNs.

- **`show host-initiators`**  
  Lists all detected WWNs (initiators) connected to the storage array.

- **`show host`**  
  Displays all defined hosts and their associated initiators (WWNs).

- **`show initiator`**  
  Lists initiators and their online/offline status.

- **`show host-name-mapping`**  
  Shows custom name mappings for initiators, if configured.

### Host Management Commands
- **`create host <host-name> initiators <wwn1> <wwn2>`**  
  Creates a new host object with specified WWNs.  
  *Example:* `create host Host_G10A initiators 51:40:2e:c0:17:31:0a:78 51:40:2e:c0:17:31:0a:7a`

- **`delete host <host-name>`**  
  Deletes a specified host object.  
  *Example:* `delete host Host_G10A`

- **`add host-initiators <host-name> <wwn>`**  
  Adds a WWN to an existing host.  
  *Example:* `add host-initiators Host_G10A 51:40:2e:c0:17:31:0a:7c`

- **`remove host-initiators <host-name> <wwn>`**  
  Removes a WWN from an existing host.  
  *Example:* `remove host-initiators Host_G10A 51:40:2e:c0:17:31:0a:7c`

## 2. Volume Mapping (LUN Mapping)

Commands for mapping volumes to hosts and checking volume status.

- **`map volume <volume-name> host <host-name> lun <lun-id>`**  
  Maps a volume to a host with a specific LUN number.  
  *Example:* `map volume Volume1 host Host_G10A lun 1`

- **`unmap volume <volume-name> host <host-name>`**  
  Unmaps a volume from a host.  
  *Example:* `unmap volume Volume1 host Host_G10A`

- **`show volume`**  
  Lists all volumes configured on the array.

- **`show volume-maps`**  
  Displays which volumes are mapped to which hosts and ports.

- **`show volume-statistics`**  
  Shows I/O statistics for each volume (e.g., read/write operations).

## 3. System and Controller Status

Commands for checking system health, configuration, and managing controllers.

- **`show system`**  
  Displays overall system status, including controllers, fans, power supplies, and temperature.

- **`show controllers`**  
  Shows detailed status of Controller A and Controller B (e.g., operational, down).

- **`show ports`**  
  Lists all physical ports (FC, SAS, etc.) and their status.

- **`show configuration`**  
  Displays the full configuration, including hosts, ports, volumes, and mappings.

- **`show events`**  
  Shows the system event log for hardware/software alerts and errors.

## 4. System Shutdown and Restart

Commands for safely shutting down or restarting the storage array.

- **`shutdown both`**  
  Shuts down both Controller A and Controller B safely.  
  *Note:* Ensure no active I/O operations are running before executing.

- **`restart sc both`**  
  Restarts both Controller A and Controller B.  
  *Note:* Use for maintenance or to apply configuration changes.

---

## Notes
- **Prerequisites:** Ensure you have SSH access to the MSA 2060 management port and appropriate credentials.
- **Safety:** Before shutting down or restarting, verify that no hosts (e.g., ESXi servers) are accessing volumes to prevent data loss.
- **Firmware:** Regularly check for firmware updates on the HPE support website to avoid issues with commands or system behavior.
- **Logs:** Use `show events` to troubleshoot issues after executing commands.