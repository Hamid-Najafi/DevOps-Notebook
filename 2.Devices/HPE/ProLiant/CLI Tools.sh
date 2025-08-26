# -------==========-------
# 	HPE Smart Array 
# -------==========-------
# Enable Drive Write Cache - P408i-a SR Gen10
# https://support.hpe.com/connect/s/product?language=en_US&kmpmoid=1010026791&tab=driversAndSoftware
# Smart Storage Administrator CLI

/opt/smartstorageadmin/ssacli/bin/ssacli
/opt/smartstorageadmin/ssacli/bin/ssacli ctrl all show config detail
/opt/smartstorageadmin/ssacli/bin/ssacli ctrl all show status

# Disable SSD Smart Path
/opt/smartstorageadmin/ssacli/bin/ssacli ctrl slot=0 array A modify ssdsmartpath=disable

# Enable Drive Write Cache
/opt/smartstorageadmin/ssacli/bin/ssacli ctrl slot=0 ld 1 modify caching=enable

# Verify
/opt/smartstorageadmin/ssacli/bin/ssacli ctrl slot=0 ld 1 show detail