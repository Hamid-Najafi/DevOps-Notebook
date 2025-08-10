🧩 Windows Server 2025 – Domain Controller Setup Documentation

Domain: C1Tech.local
Hostname: MWS-DC
Server IP: 172.25.10.11
<!-- PowerShell  -->

1. 🛠️ Initial Configuration
Task	Value
Rename Server	MWS-DC
Static IP	172.25.10.10
Subnet Mask	255.255.255.0
Gateway	172.25.10.1
Preferred DNS	172.25.10.10 (self)
Workgroup	Leave default (will be joined to domain)
Windows Updates	✅ Fully updated

New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress 172.25.10.10 -PrefixLength 24 -DefaultGateway 172.25.10.1
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 127.0.0.1

2. Rename the Server
Rename-Computer -NewName "MWS-DC" -Restart
Rename-Computer -NewName "DC-SRV" -Restart

3. 📦 Install Required Roles
Install-WindowsFeature AD-Domain-Services, DNS, DHCP, GPMC -IncludeManagementTools

3. 🌐 Promote to Domain Controller
Install-ADDSForest `
  -DomainName "C1Tech.local" `
  -DomainNetbiosName "C1TECH" `
  -SafeModeAdministratorPassword (ConvertTo-SecureString "C1Techpass.DSRM" -AsPlainText -Force) `
  -InstallDNS:$true `
  -Force:$true

3.1. Verify Domain Controller Status
Get-ADDomain
Get-ADForest

4. 📡 Configure DHCP
4.1 Authorize DHCP in Active Directory
Add-DhcpServerInDC -DnsName "MWS-DC.C1Tech.local" -IpAddress 172.25.10.10

4.2 Create DHCP Scope
Add-DhcpServerv4Scope -Name "LAN Scope" -StartRange 172.25.10.100 -EndRange 172.25.10.200 -SubnetMask 255.255.255.0

4.3 Set DHCP Options (Gateway & DNS)
Set-DhcpServerv4OptionValue -OptionId 3 -Value 172.25.10.1       # Default Gateway
Set-DhcpServerv4OptionValue -OptionId 6 -Value 172.25.10.10      # DNS Server (DC)

5. 🧱 Create Organizational Units (OUs)
$teams = @(
  "AI Team", "Design Team", "DevOps Team", "Hardware Team",
  "Mechanical Team", "Project Team", "Software Team", "Official Team"
)

foreach ($team in $teams) {
  New-ADOrganizationalUnit -Name "C1 $team" -Path "DC=C1Tech,DC=local"
}

6. 👥 Create Security Groups per Team
foreach ($team in $teams) {
  $groupName = "C1-" + $team.Replace(" ", "")
  $ou = "OU=C1 $team,DC=C1Tech,DC=local"
  New-ADGroup -Name $groupName -GroupScope Global -GroupCategory Security -Path $ou
}

7. 🕒 Configure NTP with Tehran Time
Set-TimeZone -Id "Iran Standard Time"
w32tm /config /manualpeerlist:"pool.ntp.org" /syncfromflags:manual /reliable:yes /update
Restart-Service w32time
w32tm /resync
New-NetFirewallRule -DisplayName "Allow NTP" -Direction Inbound -Protocol UDP -LocalPort 123 -Action Allow
w32tm /query /status
w32tm /query /configuration

8. Create OU Structures
Set-ExecutionPolicy RemoteSigned -Scope Process
.\Create-C1Tech-OUs.ps1