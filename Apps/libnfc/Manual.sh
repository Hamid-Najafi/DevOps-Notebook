# -------==========-------
# Binary Install
# -------==========-------
sudo apt-get update
sudo apt install libnfc-bin libnfc-dev libnfc-examples  mfoc mfcuk

# Check that the device is correctly recognized by system:
dmesg

# -------==========-------
# Config Ways
# -------==========-------
# 1. 
/etc/nfc/libnfc.conf
echo -e "device.connstring = \"pn532_uart:/dev/ttyUSB0\"" | tee -a /etc/nfc/libnfc.conf

# 2. 
nano /etc/nfc/devices.d/pn532_uart_on_rpi.conf
## Typical configuration file for PN532 device on R-Pi connected using UART
## Note: to use UART port on R-Pi, you have to disable linux serial console:
##   http://learn.adafruit.com/adafruit-nfc-rfid-on-raspberry-pi/freeing-uart-on-the-pi
name = "PN532 board via UART"
connstring = pn532_uart:/dev/ttyUSB0
allow_intrusive_scan = true
# -------==========-------
# Examples
# -------==========-------
# List NFC Device
nfc-list
# PollS Card UID
nfc-poll
# Mifare Tool Clone Card
mfoc -O dump.img
mfoc -f Mifare/default_keys.dic -O dump.img
# -------==========-------
# Build fron source
# -------==========-------
mkdir ~/dev
cd  ~/dev
# https://github.com/nfc-tools/libnfc/releases
wget https://github.com/nfc-tools/libnfc/releases/download/libnfc-1.8.0/libnfc-1.8.0.tar.bz2
tar -xvjf libnfc-1.8.0.tar.bz2
cd libnfc-1.8.0
sudo mkdir /etc/nfc
sudo mkdir /etc/nfc/devices.d
sudo cp contrib/libnfc/pn532_uart_on_rpi.conf.sample /etc/nfc/devices.d/pn532_uart_on_rpi.conf

sudo nano /etc/nfc/devices.d/pn532_uart_on_rpi.conf
allow_intrusive_scan = true

sudo apt-get install autoconf libtool libpcsclite-dev libusb-dev
apt-get install libglib2.0-dev
autoreconf -vis
./configure --with-drivers=pn532_uart --sysconfdir=/etc --prefix=/usr
sudo make clean
sudo make install all
# Test
cd examples
sudo ./nfc-poll