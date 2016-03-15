$period = [timespan]::FromMinutes(5)
$lastRunTime = [DateTime]::MinValue 
while (1)
{
    # If the next period isn't here yet, sleep so we don't consume CPU
    while ((Get-Date) - $lastRunTime -lt $period) { 
        Start-Sleep -Milliseconds 300000
    }
    $lastRunTime = Get-Date
    write-host "AutoPower script will execute every 5 minutes, ctrl-c will terminate script." | c:\temp\AutoPower.ps1
}
