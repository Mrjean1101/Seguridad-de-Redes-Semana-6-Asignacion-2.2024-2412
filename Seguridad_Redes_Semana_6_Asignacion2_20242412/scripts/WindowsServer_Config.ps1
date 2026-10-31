New-NetIPAddress -InterfaceAlias "Ethernet1" -IPAddress 10.24.12.10 -PrefixLength 24 -DefaultGateway 10.24.12.1
Set-DnsClientServerAddress -InterfaceAlias "Ethernet1" -ServerAddresses ("127.0.0.1")
netsh advfirewall firewall add rule name="Permitir Ping IPv4" protocol=icmpv4:8,any dir=in action=allow

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
$secPassword = ConvertTo-SecureString "Admin12345*" -AsPlainText -Force
Install-ADDSForest -DomainName "seguridad.local" -SafeModeAdministratorPassword $secPassword -Force

Install-WindowsFeature NPAS -IncludeManagementTools
netsh ras add registeredserver

New-ADGroup -Name "Grupo nivel 0" -GroupScope Global -GroupCategory Security
New-ADGroup -Name "Grupo nivel 5" -GroupScope Global -GroupCategory Security
New-ADGroup -Name "Grupo nivel 10" -GroupScope Global -GroupCategory Security

$Password = ConvertTo-SecureString "ClaveSegura2024*" -AsPlainText -Force

New-ADUser -Name "User Nivel 0" -SamAccountName "user0" -UserPrincipalName "user0@seguridad.local" -AccountPassword $Password -Enabled $true -PasswordNeverExpires $true
Add-ADGroupMember -Identity "Grupo nivel 0" -Members "user0"

New-ADUser -Name "User Nivel 5" -SamAccountName "user5" -UserPrincipalName "user5@seguridad.local" -AccountPassword $Password -Enabled $true -PasswordNeverExpires $true
Add-ADGroupMember -Identity "Grupo nivel 5" -Members "user5"

New-ADUser -Name "User Nivel 10" -SamAccountName "user10" -UserPrincipalName "user10@seguridad.local" -AccountPassword $Password -Enabled $true -PasswordNeverExpires $true
Add-ADGroupMember -Identity "Grupo nivel 10" -Members "user10"