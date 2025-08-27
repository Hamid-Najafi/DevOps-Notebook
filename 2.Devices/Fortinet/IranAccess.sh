# -------==========-------
# FortiGate IranAccess
# -------==========-------
# Enable multi-VDOM mode
config system global
    set vdom-mode multi-vdom
end
# ⚠️ After this, log in again.

# Create MGMT VDOM
config vdom
    edit MGMT
end

# Set MGMT as the management VDOM
config global
    config system global
        set management-vdom MGMT
    end
end
# ✅ After this, MGMT will be marked with a small red icon in the GUI

# Route FortiGuard / Update Service tunneling to no where
config global
config system autoupdate tunneling
show
set address 192.168.0.0
set port 54714
set username Null
set password null
set status enable
show
end 

# Set custom DNS servers (override Fortinet defaults)
config system dns
    set primary 8.8.8.8
    set secondary 1.1.1.1
end

# Disable FortiGuard auto-update schedule
config global
    config system autoupdate schedule
        set status disable
    end
end

# Disable FortiGuard caches and forced checks
config system fortiguard
    show
    set antispam-force-off enable
    set antispam-cache disable
    set webfilter-force-off enable
    set webfilter-cache disable
    show
end

# Block Fortinet update servers using static blackhole routes
# Must be applied on both MGMT and root VDOM

# 1. MGMT VDOM
config vdom
edit MGMT
config router static
# Paste Static Routes for MGMT
# (Each edit <ID> sets a destination to blackhole)
# Example:
edit 201
set dst 67.217.100.26/32
set blackhole enable
next

# ... repeat for all other IPs ...
end
end


# 2. root VDOM
config vdom
edit root
config router static
# Paste Static Routes for root
edit 201
set dst 67.217.100.26/32
set blackhole enable
next

# ... repeat for all other IPs ...
edit 246
set dst 96.45.32.0/22
set blackhole enable
next
end
end

# -------==========-------
# Static Routes
# -------==========-------
edit 201
set dst 67.217.100.26/32
set blackhole enable
next

edit 202
set dst 69.195.205.0/24
set blackhole enable
next

edit 203
set dst 76.223.10.41/32
set blackhole enable
next

edit 204
set dst 149.5.232.0/24
set blackhole enable
next

edit 205
set dst 111.108.191.0/24
set blackhole enable
next

edit 206
set dst 173.243.128.0/20
set blackhole enable
next

edit 207
set dst 154.52.0.0/19
set blackhole enable
next

edit 208
set dst 13.248.128.0/17
set blackhole enable
next

edit 209
set dst 206.47.184.0/24
set blackhole enable
next

edit 210
set dst 208.91.112.0/22
set blackhole enable
next

edit 211
set dst 194.69.172.0/22
set blackhole enable
next

edit 212
set dst 121.111.236.0/24
set blackhole enable
next

edit 213
set dst 76.223.2.16/32
set blackhole enable
next

edit 214
set dst 65.210.95.0/24
set blackhole enable
next

edit 215
set dst 76.223.68.60/32
set blackhole enable
next

edit 216
set dst 80.85.69.0/24
set blackhole enable
next

edit 217
set dst 66.117.56.0/24
set blackhole enable
next

edit 218
set dst 66.35.16.0/21
set blackhole enable
next

edit 219
set dst 208.184.237.0/24
set blackhole enable
next

edit 220
set dst 173.140.138.0/24
set blackhole enable
next
edit 221
set dst 210.7.96.0/24
set blackhole enable
next

edit 222
set dst 184.94.112.0/22
set blackhole enable
next

edit 223
set dst 3.65.237.68/32
set blackhole enable
next

edit 224
set dst 3.66.0.0/17
set blackhole enable
next

edit 225
set dst 63.137.229.12/32
set blackhole enable
next

edit 226
set dst 83.231.212.0/24
set blackhole enable
next

edit 227
set dst 64.26.151.0/24
set blackhole enable
next

edit 228
set dst 54.190.240.168/32
set blackhole enable
next

edit 229
set dst 61.204.170.252/32
set blackhole enable
next

edit 230
set dst 35.81.23.238/32
set blackhole enable
next

edit 231
set dst 44.232.12.97/32
set blackhole enable
next

edit 232
set dst 3.64.76.84/32
set blackhole enable
next

edit 233
set dst 3.67.24.12/32
set blackhole enable
next

edit 234
set dst 44.232.194.238/32
set blackhole enable
next

edit 235
set dst 35.82.216.214/32
set blackhole enable
next

edit 236
set dst 140.174.22.0/24
set blackhole enable
next

edit 237
set dst 54.68.77.39/32
set blackhole enable
next

edit 238
set dst 45.75.200.0/24
set blackhole enable
next

edit 239
set dst 64.26.135.0/24
set blackhole enable
next

edit 240
set dst 209.222.128.0/19
set blackhole enable
next

edit 241
set dst 12.34.97.0/24
set blackhole enable
next

edit 242
set dst 76.223.64.5/32
set blackhole enable
next

edit 243
set dst 54.200.215.134/32
set blackhole enable
next

edit 244
set dst 54.200.120.146/32
set blackhole enable
next

edit 245
set dst 3.66.98.79/32
set blackhole enable
next

edit 246
set dst 96.45.32.0/22
set blackhole enable
next

end
end