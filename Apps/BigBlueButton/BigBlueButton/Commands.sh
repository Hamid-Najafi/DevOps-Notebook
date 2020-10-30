# -------==========-------
# PDF Conversion
# -------==========-------
pdf2swf
----
#!/bin/bash
INPUT=$1
pdf2djvu --bg-subsample=1 -d 300 "$INPUT" -o "$INPUT.djvu"
ddjvu -format=pdf "$INPUT.djvu" "$INPUT.rasterized.pdf"
# -------==========-------
# $ BBB Config
# -------==========-------
https://docs.bigbluebutton.org/admin/bbb-conf.html

sudo bbb-conf --restart
sudo bbb-conf --start
sudo bbb-conf --stop
sudo bbb-conf --check
sudo bbb-conf --status
sudo bbb-conf --debug
sudo bbb-conf --network
# -------==========-------
# BBB Record
# -------==========-------
https://docs.bigbluebutton.org/dev/recording.html

 bbb-record --watch --withDesc  

