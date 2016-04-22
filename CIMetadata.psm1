Function Get-CIMetaData {
    <#
    .SYNOPSIS
        Retrieves all Metadata Key/Value pairs.
    .DESCRIPTION
        Retrieves all custom Metadata Key/Value pairs on a specified vCloud object
    .PARAMETER  CIObject
        The object on which to retrieve the Metadata.
    .PARAMETER  Key
        The key to retrieve.
    .EXAMPLE
        Get-CIMetadata -CIObject (Get-Org Org1)
    #>
    param(
        [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
            [PSObject[]]$CIObject,
            $Key
        )
    Process {
        $version = Get-PowerCLIVersion
        $use_TypedValue = 1
        If ($version.Major -lt 5 -or 
            ($version.Major -eq 5 -and $version.Minor -lt 1) -or
            ($version.Major -eq 5 -and $version.Minor -eq 1 -and $version.revision -eq 0 -and $version.build -eq 793510) ) {

            $use_TypedValue = 0
        }

        Foreach ($Object in $CIObject) {
            If ($Key) {
                if ($use_TypedValue) {
                    ($Object.ExtensionData.GetMetadata()).MetadataEntry | Where {$_.Key -eq $key } | Select @{N="CIObject";E={$Object.Name}}, Key, @{N="Value";E={ $_.TypedValue.value }}

                } else {
                    ($Object.ExtensionData.GetMetadata()).MetadataEntry | Where {$_.Key -eq $key } | Select @{N="CIObject";E={$Object.Name}}, Key, Value
                }
            } Else {
                if ($use_TypedValue) {
                    ($Object.ExtensionData.GetMetadata()).MetadataEntry | Select @{N="CIObject";E={$Object.Name}}, Key, @{N="Value";E={ $_.TypedValue.value }}

                } else {
                    ($Object.ExtensionData.GetMetadata()).MetadataEntry | Select @{N="CIObject";E={$Object.Name}}, Key, Value
                }
            }
        }
    }
}
