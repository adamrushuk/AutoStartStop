## Skyscape PowerCLI example script 
## Date written: December 2015 by Skyscape Cloud Services
##
## Purpose: Read metadata from vApps in an Org, collect metadata relevant to AutoOnOff and write out to a csv file
##
### Define Functions that will be used in the script
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
($Object.ExtensionData.GetMetadata()).MetadataEntry | Where {$_.Key -eq $key } | Select @{N="CIObject";E={$Object.Name}}, Key, Value
} Else {
($Object.ExtensionData.GetMetadata()).MetadataEntry | Select @{N="CIObject";E={$Object.Name}}, Key, Value
}
}
}
}
### End of function definitions
### Start of script !!
### Connect to customer's Org (need Org admin user/password and Org name)
### There are two oprtions; Prompt and Script Stored - uncomment as needed
### -Org details will need to be replaced
### Output location for CSV will need to be changed
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
# Set up an array for the final report
$report = @()
# Get all vApp from the Org
$vApps = Get-CIVApp 
foreach ($vApp in $vApps) {
# Get the metadata key/value pairs for all vApps
$Metadatas = Get-CIMetaData -CIObject $vApp
# Get the individual key/value pairs for each vApp
$StopTime = "Not specified"
$StartTime = "Not specified"
$Day = "Not specified"
$AutoOnOff = "Not specified"
foreach ($Metadata in $Metadatas) {
$Key = ''
$Value = ''
$vAppName = $Metadata.CIObject
$Key = $Metadata.Key
$Value = $Metadata.Value
if ($Key -eq 'StopTime') {$StopTime = $Value}
if ($Key -eq 'StartTime') {$StartTime = $Value}
if ($Key -eq 'Days') {$Day = $Value}
if ($Key -eq 'AutoOnOff') {$AutoOnOff = $Value}
}
Write-Host "vApp ",$vApp
Write-Host "Days ",$Day
Write-Host "StopTime",$StopTime
Write-Host "StartTime",$StartTime
Write-Host "AutoOnOff",$AutoOnOff
write-host ""
$row= " " | select vApp,Days,StopTime,StartTime,AutoOnOff
$row.vApp = $vApp
$row.Days = $Day
$row.StopTime = $StopTime
$row.StartTime = $StartTime
$row.AutoOnOff = $AutoOnOff
# Add this row to the report array
$report += $row
}
# Write out the report array to the file in CSV format
$outfile = "C:\temp\metadata.csv"
#$outfile = Read-Host -prompt 'Please enter a file path to write out to'
$report | Export-Csv $outfile -NoTypeInformation
