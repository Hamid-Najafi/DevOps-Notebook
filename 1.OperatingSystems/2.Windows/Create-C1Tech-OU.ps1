Import-Module ActiveDirectory

$OUs = @(
    @{Name="C1Tech"; Path="DC=C1Tech,DC=local"},
    
    @{Name="Users"; Path="OU=C1Tech,DC=C1Tech,DC=local"},
    @{Name="AI Team"; Path="OU=Users,OU=C1Tech,DC=C1Tech,DC=local"},
    @{Name="Design Team"; Path="OU=Users,OU=C1Tech,DC=C1Tech,DC=local"},
    @{Name="DevOps Team"; Path="OU=Users,OU=C1Tech,DC=C1Tech,DC=local"},
    @{Name="Hardware Team"; Path="OU=Users,OU=C1Tech,DC=C1Tech,DC=local"},
    @{Name="Mechanical Team"; Path="OU=Users,OU=C1Tech,DC=C1Tech,DC=local"},
    @{Name="Project Team"; Path="OU=Users,OU=C1Tech,DC=C1Tech,DC=local"},
    @{Name="Software Team"; Path="OU=Users,OU=C1Tech,DC=C1Tech,DC=local"},
    @{Name="Official Team"; Path="OU=Users,OU=C1Tech,DC=C1Tech,DC=local"},

    @{Name="Computers"; Path="OU=C1Tech,DC=C1Tech,DC=local"},
    @{Name="Desktops"; Path="OU=Computers,OU=C1Tech,DC=C1Tech,DC=local"},
    @{Name="Laptops"; Path="OU=Computers,OU=C1Tech,DC=C1Tech,DC=local"},
    @{Name="Tablets"; Path="OU=Computers,OU=C1Tech,DC=C1Tech,DC=local"},
    @{Name="SoC"; Path="OU=Computers,OU=C1Tech,DC=C1Tech,DC=local"},

    @{Name="Servers"; Path="OU=C1Tech,DC=C1Tech,DC=local"},
    @{Name="Domain Controllers"; Path="OU=Servers,OU=C1Tech,DC=C1Tech,DC=local"},
    @{Name="File Servers"; Path="OU=Servers,OU=C1Tech,DC=C1Tech,DC=local"},
    @{Name="Application Servers"; Path="OU=Servers,OU=C1Tech,DC=C1Tech,DC=local"},
    @{Name="Linux Hosts"; Path="OU=Servers,OU=C1Tech,DC=C1Tech,DC=local"},

    @{Name="Groups"; Path="OU=C1Tech,DC=C1Tech,DC=local"},
    @{Name="Security Groups"; Path="OU=Groups,OU=C1Tech,DC=C1Tech,DC=local"},
    @{Name="Distribution Groups"; Path="OU=Groups,OU=C1Tech,DC=C1Tech,DC=local"},

    @{Name="Service Accounts"; Path="OU=C1Tech,DC=C1Tech,DC=local"},
    @{Name="Application Accounts"; Path="OU=Service Accounts,OU=C1Tech,DC=C1Tech,DC=local"},
    @{Name="System Accounts"; Path="OU=Service Accounts,OU=C1Tech,DC=C1Tech,DC=local"},

    @{Name="Admin Accounts"; Path="OU=C1Tech,DC=C1Tech,DC=local"},
    @{Name="Domain Admins"; Path="OU=Admin Accounts,OU=C1Tech,DC=C1Tech,DC=local"},
    @{Name="Helpdesk Users"; Path="OU=Admin Accounts,OU=C1Tech,DC=C1Tech,DC=local"},

    @{Name="Infrastructure"; Path="OU=C1Tech,DC=C1Tech,DC=local"},
    @{Name="Network Devices"; Path="OU=Infrastructure,OU=C1Tech,DC=C1Tech,DC=local"},
    @{Name="Printers"; Path="OU=Infrastructure,OU=C1Tech,DC=C1Tech,DC=local"},

    @{Name="Staging"; Path="OU=C1Tech,DC=C1Tech,DC=local"},
    @{Name="Users"; Path="OU=Staging,OU=C1Tech,DC=C1Tech,DC=local"},
    @{Name="Computers"; Path="OU=Staging,OU=C1Tech,DC=C1Tech,DC=local"},

    @{Name="Disabled"; Path="OU=C1Tech,DC=C1Tech,DC=local"},
    @{Name="Users"; Path="OU=Disabled,OU=C1Tech,DC=C1Tech,DC=local"},
    @{Name="Computers"; Path="OU=Disabled,OU=C1Tech,DC=C1Tech,DC=local"},

    @{Name="GPO-Testing"; Path="OU=C1Tech,DC=C1Tech,DC=local"}
)

foreach ($ou in $OUs) {
    $exists = Get-ADOrganizationalUnit -Filter "Name -eq '$($ou.Name)'" -SearchBase $ou.Path -ErrorAction SilentlyContinue
    if (-not $exists) {
        try {
            New-ADOrganizationalUnit -Name $ou.Name -Path $ou.Path -ProtectedFromAccidentalDeletion $false
            Write-Host "✅ Created OU: $($ou.Name) in $($ou.Path)"
        }
        catch {
            Write-Host "❌ Failed to create OU: $($ou.Name) in $($ou.Path) - $_"
        }
    } else {
        Write-Host "ℹ️ OU already exists: $($ou.Name) in $($ou.Path)"
    }
}

# Define the correct OU path
$OU = "OU=Security Groups,OU=Groups,OU=C1Tech,DC=C1Tech,DC=local"

# Define group names and descriptions
$groups = @{
    "GRP-AI"       = "C1 AI Team group"
    "GRP-Design"   = "C1 Design Team group"
    "GRP-DevOps"   = "C1 DevOps Team group"
    "GRP-HW"       = "C1 Hardware Team group"
    "GRP-Mech"     = "C1 Mechanical Team group"
    "GRP-Project"  = "C1 Project Team group"
    "GRP-SW"       = "C1 Software Team group"
    "GRP-Official" = "C1 Official Team group"
}

# Create the groups in the specified OU
foreach ($groupName in $groups.Keys) {
    if (-not (Get-ADGroup -Filter { Name -eq $groupName })) {
        New-ADGroup -Name $groupName `
                    -SamAccountName $groupName `
                    -GroupScope Global `
                    -GroupCategory Security `
                    -Path $OU `
                    -Description $groups[$groupName]
        Write-Host "✅ Created group: $groupName"
    } else {
        Write-Host "ℹ️ Group already exists: $groupName"
    }
}
