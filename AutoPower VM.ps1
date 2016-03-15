## Skyscape PowerCLI example script
## Date written: December 2015 by Skyscape Cloud Services
##
## Purpose:Power on or off vApps based on metadata and time of day
## 
## StopTime set to 24 hour clock hour value (eg 18 or 20)
## StartTime set to 24 hour clock hour value (eg 06 or 08)
## Days set to list of 3 letter abbreviated days (eg MonWed or SatSun or Every for all week)
## AutoOnOff (Yes or No)
## Username, password, Org name
##
##
# Uncomment line below when running as a scheduled task
# Add-PSSnapin VMware.VimAutomation.Cloud
# Functions required not included in base PowerCLI
Function Get-CIMetaData {
<#
.SYNOPSIS
Retrieves all Metadata Key/Value pairs.
.DESCRIPTION
Retrieves all custom Metadata Key/Value pairs on a specified vCloud object
.PARAMETER CIObject
The object on which to retrieve the Metadata.
.PARAMETER Key
The key to retrieve.
.EXAMPLE
PS C:\> Get-CIMetadata -CIObject (Get-Org Org1)
#>
param(
[parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
[PSObject[]]$CIObject,
$Key
)
Process {
Foreach ($Object in $CIObject) {
If ($Key) {
($Object.ExtensionData.GetMetadata()).MetadataEntry | Where {$_.Key -eq $key } | Select @{N="CIObject";E={$Object.Name}}, Key, @{N="value";E={$_.TypedValue.value}}
} Else {
($Object.ExtensionData.GetMetadata()).MetadataEntry | Select @{N="CIObject";E={$Object.Name}}, Key, @{N="value";E={$_.TypedValue.value}}
}
}
}
}
# End of additional functions
#
#
#
#
### Connect to customer's Org (need Org admin user/password and Org name)
### There are two options; Prompt and Script Stored - uncomment as needed
### -Org details will need to be replaced
### $vApps can be aimed at specific vAPP | "name"
#
#
# Uncomment below for connection with username/password prompted for
#$creds = Get-Credential
#Connect-CIServer -server api.vcd.portal.skyscapecloud.com -Org "ORGNAME" -Credential $creds
#
#
#
# Uncomment below for connection using a stored password 
Connect-CIServer -server api.vcd.portal.skyscapecloud.com -Org "ORGNAME" -Username "USERNAME" -Password "PASSWORD"
#
#
#
#
# Get the current time, and specifically hour in 24 hour format
$time = Get-Date -DisplayHint Time
$today = Get-Date -UFormat %a
$hour = $time.Hour
# Debug
# Write-Host 'Time now',$hour
# Get a list of all the VMs in the Org
$VM = Get-CIVM
foreach ($VM in $VM) {
# Get the metadata key/value pairs for all VMs
$Metadatas = Get-CIMetaData -CIObject $VM
# Get the individual key/value pairs for each VM
$StopTime = -2
$StartTime = -999
$Day = "Not specified"
foreach ($Metadata in $Metadatas) {
$Key = ''
$Value = ''
$VNname = $Metadata.CIObject
$Key = $Metadata.Key
$Value = $Metadata.Value
# Debug
# Write-Host $VMname,$Key,$Value
if ($Key -eq 'AutoOnOff') {$AutoOnOff = $Value}
if ($Key -eq 'StopTime') {$StopTime = $Value}
if ($Key -eq 'StartTime') {$StartTime = $Value}
if ($Key -eq 'Days') {$Day = $Value}
if ($Day -like 'Every') {$Day = $today}
}
# Debug
# Write-Host $VM,$StartTime,$StopTime,$Day,$AutoOnOff
# For testing purposes, just write out the action
#if (($hour -ge $StopTime) -and ($VM.Status -eq 'PoweredOn') -and ($Day -like '*'+$today+'*') -and ($AutoOnOff -eq 'Yes')) {write-host 'Stopping...',$VM, $StartTime, $StopTime, $Day}
#if (($hour -ge $StartTime) -and ($VM.Status -eq 'PoweredOff') -and ($Day -like '*'+$today+'*') -and ($AutoOnOff -eq 'Yes')) {write-host 'Starting...',$VM, $StartTime, $StopTime, $Day}
# Carry out the PowerOn or PowerOff task
if (($hour -ge $StopTime) -and ($VM.Status -eq 'PoweredOn') -and ($Day -like '*'+$today+'*') -and ($AutoOnOff -eq 'Yes')) {Stop-CIVM -VM $VM -Confirm:$false}
if (($hour -ge $StartTime) -and ($VM.Status -eq 'PoweredOff') -and ($Day -like '*'+$today+'*') -and ($AutoOnOff -eq 'Yes')) {Start-CIVM -VM $VM -Confirm:$false}
}
