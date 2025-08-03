# LDAPS Integration with Active Directory for Nextcloud (Windows Server 2025)
## ✅ Steps Summary

### 1. Install AD Certificate Services (AD CS)
- Install the **Enterprise Root CA** role on the Domain Controller.

### 2. Issue Server Certificate for LDAPS
- Issue a certificate to the DC with:
  - Subject: `CN=your-dc-hostname`
  - Enhanced Key Usage: `Server Authentication`

### 3. Verify Certificate Placement
- Certificate must be in:
  - `Certificates (Local Computer) > Personal > Certificates`

### 4. Confirm LDAPS Certificate Usage
- Check the thumbprint in registry:
HKLM\SYSTEM\CurrentControlSet\Services\NTDS\Parameters\LDAPSSL Certificate

### 5. Export Root CA Certificate
`powershell
certutil -ca.cert C:\CAroot.cer

### 6. Install Root CA Certificate on Linux Client
sudo cp CAroot.cer /usr/local/share/ca-certificates/C1Tech_CA.crt
sudo update-ca-certificates

### 7. Test LDAPS Connectivity
openssl s_client -connect your-dc-hostname:636 -showcerts

### 8. Test LDAP Bind Over SSL
# Use userPrincipalName
ldapsearch -x \
  -H ldaps://your-dc-hostname:636 \
  -D "ServiceUser@C1Tech.local" \
  -w "password" \
  -b "DC=C1Tech,DC=local"

### 9. Create and Configure Service Bind Account
Create a dedicated AD user for Nextcloud
Assign read permissions on AD objects

### 10.  Install Root CA Certificate on Docker Container
docker cp ./C1Tech-MWS-DC-CA.cer nextcloud:/usr/local/share/ca-certificates/C1TechCA.crt 
docker exec -it  nextcloud /bin/bash
echo "172.25.10.10 MWS-DC.C1Tech.local" >> /etc/hosts
sudo update-ca-certificates

### 11. Verify
ldapsearch -x -H ldaps://MWS-DC.C1Tech.local \
  -D "NextcloudServiceUser@C1Tech.local" \
  -w '123456789' \
  -b "DC=C1Tech,DC=local"