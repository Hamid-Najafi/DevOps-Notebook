# -------==========-------
# Firmware update via MQTT 
# -------==========-------
# China Region Lock
1. You need bambulab china handy app %from china appStore% Or Bambustudio with china region set
2. printer must have china vpn

https://cafe.naver.com/bambulab/3353?tc=shared_link
Command payload repository
The bottom command payload is no longer managed. Please refer to Naver Cafe and the bottom link
https://github.com/lunDreame/user-bambulab-firmware
## Prepare

Mqtt connection program
Etc. https://mqttx.app/downloads
Printer Local Address and Access Code

## Run a program (Based on MQTTX)
Connections -> New Connection
Name: Bambu_Local (Set up whatever you want)
Host: mqtts://{Printer Local Address}
Port: 8883
Username: bblp
Password: {Printer Access Code}
SSL/TLS: True
SSL Secure: False

Advanced
MQTT Version: 3.1.1

# Subscribe to a topic (Not required)
By subscribing to the report topic, you can determine whether the update is successful or not

New Subscription -> Topic
How do I get SN? (SN is an eight-digit number.)
https://wiki.bambulab.com/en/general/find-sn

device/{SN}/report

## Command subscription

Change the Qos setting to 1

In the lower right command tab, type a topic.

device/{SN}/request

Enter the command payload in the bottom column.

# Bambu P1 (If P1S, change C11 of url part to C12)
{
    "upgrade": {
        "sequence_id": "0",
        "command": "start",
        "src_id": 1,
        "url": "https://public-cdn.bambulab.cn/upgrade/device/C11/01.05.01.00/product/f7faad4e47/ota-p003_v01.05.01.00-20240104183353.json.sig",
        "module": "ota",
        "version": "01.05.01.00"
    }
}
# Bambu P1S 
{
    "upgrade": {
        "sequence_id": "0",
        "command": "start",
        "src_id": 1,
        "url": "https://public-cdn.bambulab.cn/upgrade/device/C12/01.05.01.00/product/f7faad4e47/ota-p003_v01.05.01.00-20240104183353.json.sig",
        "module": "ota",
        "version": "01.05.01.00"
    }
}

# Bambu A1 / Mini (Not working, "Failed to parse cmd" appears and fails.)
## A1 Mini
{
    "upgrade": {
        "sequence_id": "0",
        "command": "start",
        "src_id": 1,
        "url": "https://public-cdn.bambulab.cn/upgrade/device/N1/01.01.03.00/product/9ec2391154/ota-n1_v01.01.03.00-20231222183921.json.sig",
        "module": "ota",
        "version": "01.01.03.00"
    }
}
## A1
{
    "upgrade": {
        "sequence_id": "0",
        "command": "start",
        "src_id": 1,
        "url": "https://public-cdn.bambulab.cn/upgrade/device/N2S/01.01.01.00/product/d2863c89d0/ota-n2s_v01.01.01.00-20231222183908.json.sig",
        "module": "ota",
        "version": "01.01.01.00"
    }
}