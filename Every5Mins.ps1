# Enable Advanced Functions including Verbose switch, eg. ".\Every5Mins.ps1 -Verbose"
[CmdletBinding()]
param ()

# Variables - PLEASE UPDATE THESE
$vCloudFQDN = 'api.vcd.portal.skyscapecloud.com'
$OrgName = 'ORGNAME' # eg. 1-2-3-abcdef
$Username = 'USERNAME' # eg. 1234.5.6789ab
$Password = 'PASSWORD'
# Use .\AutoPowerVAPP.ps1 or .\AutoPowerVM.ps1
$ScriptName = '.\AutoPowerVAPP.ps1'

# Import modules
# You will need PowerCLI installed from https://www.vmware.com/support/developer/PowerCLI/
Get-Module -Name VMware.VimAutomation.Cloud -ListAvailable | Import-Module
# See https://www.powershellgallery.com/packages/PowerShellLogging/1.2.1
Import-Module ./PowerShellLogging/PowerShellLogging.psm1

# Set log path
$Timestamp = (Get-Date -Format ("yyyy-MM-dd_HH-mm"))
$LogPath = Join-Path -Path $env:TEMP -ChildPath "/AutoStartStop/AutoStartStop_$($Timestamp).log"

# Enable logging
$LogFile = Enable-LogFile -Path $LogPath
Write-Host "Logging to [$LogPath]" -ForegroundColor Yellow

# Connect to vCloud
Connect-CIServer -Server $vCloudFQDN -Org $OrgName -Username $Username -Password $Password

Write-Host "AutoPower script will execute every 5 minutes, CTRL+C will terminate script." -ForegroundColor Cyan
try {
    # Run script until cancelled
    while ($true) {
        Write-Host "`nExecuting $ScriptName"
        & $ScriptName
        Start-Sleep -Seconds 30
    }
}
catch {
    Write-Output $_
}
# Finally block runs if user cancels with CTRL+C
finally {
    Write-Host "Stopping [$ScriptName]..." -ForegroundColor Cyan
    Disconnect-CIServer -Server $vCloudFQDN -Confirm:$false

    # Disable logging gracefully
    $LogFile | Disable-LogFile

    Write-Host "View full log here: [$LogPath]" -ForegroundColor Yellow
}