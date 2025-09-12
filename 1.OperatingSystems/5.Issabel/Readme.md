=======================================
# Asterisk Commands
=======================================
          +-----------------+
          |   Asterisk Core |
          +-----------------+
                   |
                   v
          +-----------------+
          |   PJSIP Stack   |
          +-----------------+
                   |
        +----------+----------+
        |                     |
  +-------------+       +-------------+
  | Transport   |       | Endpoint    |
  | (UDP/TCP/   |       | (SIP User)  |
  |  TLS)       |       +-------------+
  +-------------+              |
                               v
                        +---------------+
                        | Auth          |
                        +---------------+
                               |
                               v
                        +---------------+
                        | AOR (Address) |
                        +---------------+
                               |
                               v
                        +---------------+
                        | Contacts      |
                        | - sip:1001@192.168.1.10:5060
                        | - sip:1001@10.0.0.5:5060
                        +---------------+
                               |
                               v
                        +---------------+
                        | Channel Driver|
                        +---------------+
                               |
                               v
                        +---------------+
                        |   RTP Media   |
                        +---------------+

# Connect to Asterisk CLI
sudo asterisk -r
asterisk -rx "COMMAND"

# PJSIP Info (chan_pjsip)
# Endpoint → AOR → Contacts → Call flow
PJSIP Transports – Defines how Asterisk listens for SIP traffic (UDP, TCP, TLS).
pjsip show transports

PJSIP Registrations – Shows outgoing SIP registrations to remote servers/trunks.
pjsip show registrations


PJSIP Endpoints – Represents SIP devices or trunks that can make/receive calls. (a device, trunk, or user).
pjsip show endpoints

PJSIP Contacts – Tracks the actual registered location(s) of an endpoint. IP/URI
<!-- Example: sip:120@172.25.10.240:64015 -->
pjsip show contacts

PJSIP Auths – Authentication objects used by endpoints or registrations. (Username or password)
pjsip show auths

PJSIP AORs (Address of Record) – Stores where to reach the endpoint (contacts).
pjsip show aors

pjsip reload
# ================
# Logging Control
# ================
sudo asterisk -r
logger reload

# Show miscellaneous core system settings.
core show settings
# List configured logger channels.
logger show channels


# PJSIP message logging (INVITE, REGISTER, etc.)
# raw SIP packet logs
pjsip set logger on
pjsip set logger off

# completely mute/unmute console logging:
logger mute console

# CLI Runtime Filtering
core set verbose 0
core set debug 0
core set trace 0

core set verbose 9
core set debug 9
core set trace 9

# Logs are stored in /var/log/asterisk/full.
sudo tail -f /var/log/asterisk/full