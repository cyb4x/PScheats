param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$Action
)

function Disable-DefenderAndFirewall {
    Write-Host "[*] Disabling Microsoft Defender Real-time Protection..." -ForegroundColor Yellow
    Set-MpPreference -DisableRealtimeMonitoring $true

    Write-Host "[*] Disabling Windows Firewall (Domain, Private, Public)..." -ForegroundColor Yellow
    Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled False

    Write-Host "[+] Defender and Firewall are now disabled." -ForegroundColor Green
}

function Enable-DefenderAndFirewall {
    Write-Host "[*] Enabling Microsoft Defender Real-time Protection..." -ForegroundColor Cyan
    Set-MpPreference -DisableRealtimeMonitoring $false

    Write-Host "[*] Enabling Windows Firewall (Domain, Private, Public)..." -ForegroundColor Cyan
    Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled True

    Write-Host "[+] Defender and Firewall are now enabled." -ForegroundColor Green
}

# Normalize the action input
$ActionNormalized = $Action.ToLower().Replace("-", "").Replace("--", "")

switch ($ActionNormalized) {
    "enable" { Enable-DefenderAndFirewall }
    "e"      { Enable-DefenderAndFirewall }
    "disable" { Disable-DefenderAndFirewall }
    "d"      { Disable-DefenderAndFirewall }
    default {
        Write-Host "[!] Invalid action. Use Enable, Disable, -e, -d, --enable, --disable" -ForegroundColor Red
    }
}
