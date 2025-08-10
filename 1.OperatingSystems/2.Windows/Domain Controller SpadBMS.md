🧩 Windows Server 2025 – Domain Controller Setup Documentation

Domain: C1Tech.local
Hostname: MWS-DC
Server IP: 172.25.10.11
<!-- PowerShell  -->

1. 🛠️ Initial Configuration
Task	Value
Rename Server	MWS-DC
Static IP	172.25.30.4
Subnet Mask	255.255.255.0
Gateway	172.25.20.1
Preferred DNS	172.25.30.4 (self)
Workgroup	Leave default (will be joined to domain)
Windows Updates	✅ Fully updated

New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress 172.25.30.4 -PrefixLength 24 -DefaultGateway 172.25.30.1
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 127.0.0.1

2. Rename the Server
Rename-Computer -NewName "WS-SRV" -Restart

3. 📦 Install Required Roles
Install-WindowsFeature AD-Domain-Services, DNS, DHCP, GPMC -IncludeManagementTools

3. 🌐 Promote to Domain Controller
Install-ADDSForest `
  -DomainName "SP-BMS.local" `
  -DomainNetbiosName "SP-BMS" `
  -SafeModeAdministratorPassword (ConvertTo-SecureString "Admindc$$DSRM" -AsPlainText -Force) `
  -InstallDNS:$true `
  -Force:$true

3.1. Verify Domain Controller Status
Get-ADDomain
Get-ADForest

4. 📡 Configure DHCP
4.1 Authorize DHCP in Active Directory
Add-DhcpServerInDC -DnsName "WS-SRV.SP-BMS.local" -IpAddress 172.25.30.4

4.2 Create DHCP Scope
Add-DhcpServerv4Scope -Name "LAN Scope" -StartRange 172.25.30.100 -EndRange 172.25.30.200 -SubnetMask 255.255.255.0

4.3 Set DHCP Options (Gateway & DNS)
Set-DhcpServerv4OptionValue -OptionId 3 -Value 172.25.30.1       # Default Gateway
Set-DhcpServerv4OptionValue -OptionId 6 -Value 172.25.30.4      # DNS Server (DC)


5. 🕒 Configure NTP with Tehran Time
Set-TimeZone -Id "Iran Standard Time"
w32tm /config /manualpeerlist:"pool.ntp.org" /syncfromflags:manual /reliable:yes /update
Restart-Service w32time
w32tm /resync

6. Create OU Structures
7. 🧱 Create Organizational Units (OUs)
8. 👥 Create Security Groups per Team
Set-ExecutionPolicy RemoteSigned -Scope Process
.\Create-C1Tech-OUs.ps1
