param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$Action
)

function Disable-DefenderAndFirewall {
    Write-Host "[*] Disabling Microsoft Defender Protections..." -ForegroundColor Yellow

    Set-MpPreference -DisableRealtimeMonitoring $true
    Set-MpPreference -DisableBehaviorMonitoring $true
    Set-MpPreference -DisableBlockAtFirstSeen $true
    Set-MpPreference -DisableIOAVProtection $true
    Set-MpPreference -DisablePrivacyMode $true
    Set-MpPreference -DisableScriptScanning $true
    Set-MpPreference -SubmitSamplesConsent 2  
    Set-MpPreference -MAPSReporting 0      

    Write-Host "[*] Disabling Windows Firewall (Domain, Private, Public)..." -ForegroundColor Yellow
    Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled False

    Write-Host "[+] Defender and Firewall are now fully disabled." -ForegroundColor Green
}

function Enable-DefenderAndFirewall {
    Write-Host "[*] Enabling Microsoft Defender Protections..." -ForegroundColor Cyan

    Set-MpPreference -DisableRealtimeMonitoring $false
    Set-MpPreference -DisableBehaviorMonitoring $false
    Set-MpPreference -DisableBlockAtFirstSeen $false
    Set-MpPreference -DisableIOAVProtection $false
    Set-MpPreference -DisablePrivacyMode $false
    Set-MpPreference -DisableScriptScanning $false
    Set-MpPreference -SubmitSamplesConsent 1  
    Set-MpPreference -MAPSReporting 2        
    Write-Host "[*] Enabling Windows Firewall (Domain, Private, Public)..." -ForegroundColor Cyan
    Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled True

    Write-Host "[+] Defender and Firewall are now enabled." -ForegroundColor Green
}

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
