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

function Check-Status {
    Write-Host "[*] Checking Microsoft Defender and Firewall status..." -ForegroundColor Yellow

    $realtime = (Get-MpPreference).DisableRealtimeMonitoring
    $behavior = (Get-MpPreference).DisableBehaviorMonitoring
    $blockfirstseen = (Get-MpPreference).DisableBlockAtFirstSeen
    $ioav = (Get-MpPreference).DisableIOAVProtection
    $privacy = (Get-MpPreference).DisablePrivacyMode
    $scriptscan = (Get-MpPreference).DisableScriptScanning
    $maps = (Get-MpPreference).MAPSReporting

    $domainFW = (Get-NetFirewallProfile -Profile Domain).Enabled
    $privateFW = (Get-NetFirewallProfile -Profile Private).Enabled
    $publicFW = (Get-NetFirewallProfile -Profile Public).Enabled

    Write-Host "`n[Defender Status]" -ForegroundColor Cyan
    Write-Host "Real-Time Protection Disabled: $realtime"
    Write-Host "Behavior Monitoring Disabled:  $behavior"
    Write-Host "Block At First Seen Disabled:   $blockfirstseen"
    Write-Host "IOAV Protection Disabled:      $ioav"
    Write-Host "Privacy Mode Disabled:         $privacy"
    Write-Host "Script Scanning Disabled:      $scriptscan"
    Write-Host "MAPS Reporting Level:          $maps (0=Off, 1=Basic, 2=Advanced)"

    Write-Host "`n[Firewall Status]" -ForegroundColor Cyan
    Write-Host "Domain Firewall Enabled:       $domainFW"
    Write-Host "Private Firewall Enabled:      $privateFW"
    Write-Host "Public Firewall Enabled:       $publicFW"
}

# Function to monitor Defender and Firewall status continuously
function Monitor-DefenderAndFirewall {
    Write-Host "[*] Monitoring Defender and Firewall status..." -ForegroundColor Yellow
    while ($true) {
        # Get current statuses
        $realtime = (Get-MpPreference).DisableRealtimeMonitoring
        $domainFW = (Get-NetFirewallProfile -Profile Domain).Enabled
        $privateFW = (Get-NetFirewallProfile -Profile Private).Enabled
        $publicFW = (Get-NetFirewallProfile -Profile Public).Enabled

        # Check and disable Defender and Firewall if enabled
        if ($realtime -eq $false) {
            Write-Host "[*] Defender Real-time Protection is enabled. Disabling..." -ForegroundColor Red
            Disable-DefenderAndFirewall
        }

        if ($domainFW -eq $true -or $privateFW -eq $true -or $publicFW -eq $true) {
            Write-Host "[*] Firewall is enabled. Disabling..." -ForegroundColor Red
            Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled False
        }

        Start-Sleep -Seconds 10  # Check every 10 seconds
    }
}

# Normalize the action input
$ActionNormalized = $Action.ToLower().Replace("-", "").Replace("--", "")

switch ($ActionNormalized) {
    "enable" { Enable-DefenderAndFirewall }
    "e"      { Enable-DefenderAndFirewall }
    "disable" { Disable-DefenderAndFirewall }
    "d"      { Disable-DefenderAndFirewall }
    "status" { Check-Status }
    "s"      { Check-Status }
    "monitor" { Monitor-DefenderAndFirewall }
    default {
        Write-Host "[!] Invalid action. Use Enable, Disable, Status, Monitor, or -e, -d, -s, --enable, --disable, --status, --monitor" -ForegroundColor Red
    }
}
