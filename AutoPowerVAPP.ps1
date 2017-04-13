## UKCloud PowerCLI example script
## Date written: December 2015 by UKCloud Ltd
## Date updated: 13 April 2017 by Adam Rush
##
## Purpose:Power on or off vApps based on metadata and time of day
## See https://github.com/UKCloud/AutoStartStop
##
## StopTime set to 24 hour clock hour value (eg 18 or 20)
## StartTime set to 24 hour clock hour value (eg 06 or 08)
## Days set to list of 3 letter abbreviated days (eg MonWed or SatSun or Every for all week)
## AutoOnOff (Yes or No)
##
# Uncomment line below when running as a scheduled task
# Get-Module -Name VMware.VimAutomation.Cloud -ListAvailable | Import-Module -Verbose
Import-Module ./CIMetadata.psm1

# Get the current time, and specifically hour in 24 hour format
$time = Get-Date -DisplayHint Time
$today = Get-Date -UFormat %a
$hour = $time.Hour

# Get a list of all the vApps in the Org
## You can target specific vAPPs eg. Get-CIVApp -Name "AR*" # find all vApps starting with "AR"
$vApps = Get-CIVApp

foreach ($vApp in $vApps) {
    # Get the metadata key/value pairs for all vApps
    $Metadatas = Get-CIMetaData -CIObject $vApp
    # Get the individual key/value pairs for each vApp
    $StopTime = -2
    $StartTime = -999
    $Day = "Not specified"

    foreach ($Metadata in $Metadatas) {
        $Key = ''
        $Value = ''
        $vAppName = $Metadata.CIObject
        $Key = $Metadata.Key
        $Value = $Metadata.Value

        if ($Key -eq 'AutoOnOff') {$AutoOnOff = $Value}
        if ($Key -eq 'StopTime') {$StopTime = $Value}
        if ($Key -eq 'StartTime') {$StartTime = $Value}
        if ($Key -eq 'Days') {$Day = $Value}
        if ($Day -like 'Every') {$Day = $today}
    }

    Write-Verbose "Metadata for $($vApp): (Start:$StartTime Stop:$StopTime Day:$Day)"

    # Start vApp if required
    if (($hour -ge $StartTime) -and ($hour -lt $StopTime) -and ($vApp.Status -eq 'PoweredOff') -and ($Day -like '*'+$today+'*') -and ($AutoOnOff -eq 'Yes')) {
        Write-Host "Starting $vApp (Start:$StartTime Stop:$StopTime Day:$Day)"
        $null = Start-CIVApp -VApp $vApp -Confirm:$false
    }
    # Stop vApp if required
    if (($hour -lt $StartTime) -or ($hour -ge $StopTime) -and ($vApp.Status -eq 'PoweredOn') -and ($Day -like '*'+$today+'*') -and ($AutoOnOff -eq 'Yes')) {
        Write-Host "Stopping $vApp (Start:$StartTime Stop:$StopTime Day:$Day)"
        $null = Stop-CIVApp -VApp $vApp -Confirm:$false
    }
}
