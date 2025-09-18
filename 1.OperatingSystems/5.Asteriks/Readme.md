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

# PJSIP message logging (INVITE, REGISTER, etc.)
# raw SIP packet logs
pjsip set logger on
pjsip set logger off

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

core reload
core restart now


# ================
# Logging Control
# ================
sudo asterisk -r
logger reload
logger mute
# Show miscellaneous core system settings.
core show settings
# List configured logger channels.
logger show channels


# completely mute/unmute console logging:
logger mute console

# CLI Runtime Filtering
core set verbose 0
core set debug 0
core set trace 0
logger reload

core set verbose 9
core set debug 9
core set trace 9
logger reload

# Logs are stored in /var/log/asterisk/full.
sudo tail -f /var/log/asterisk/full


# Direct call and playback
channel originate PJSIP/120 application Playback response


channel originate PJSIP/120 application AGI /var/lib/asterisk/agi-bin/voicebot.py


sudo apt install python3 python3-requests python3-openssl

nano /var/lib/asterisk/agi-bin/voicebot.py
# Veriify ======
cd  /var/lib/asterisk/agi-bin/
python
from voicebot import stt
text = stt("/var/lib/asterisk/sounds/recorded.wav")
print(text)
============
nano /etc/asterisk/extensions_custom.conf
[VoiceBot-AGI]
exten => s,1,NoOp(Starting Python VoiceBot AGI)
 same => n,AGI(/var/lib/asterisk/agi-bin/voicebot.py)
 same => n,Hangup()

fwconsole reload
asterisk -rx "dialplan show" | grep -i voicebot

# AGI Info
sudo asterisk -r
agi set debug on


sox response.wav -r 8000 -c 1 -t wav -e mu-law response_ulaw.wav
cmod 664 asterisk:asterisk ./response.wav