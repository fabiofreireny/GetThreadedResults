<#
.SYNOPSIS
Retrieve data from multiple computers

.DESCRIPTION
This script will scan all machines in a given list and whatever is specified by $scriptPath
What sets this script apart is that it uses jobs, so multiple queries run in parallel

.EXAMPLE
Get-Content computerList.txt | GetThreadedResults -scriptPath .\jobScript.ps1
#>

Param(
    [Parameter(Mandatory=$True,ValueFromPipeline=$True,Position=0,
    HelpMessage="Array of computer names.")]
        [string[]]$targetList,

    [Parameter(Mandatory=$True,Position=1)]
        [string]$scriptPath
)

#initialize variables
$aggregate = @()

#remove any existing jobs
Get-Job | Remove-Job -Force

Write-Verbose "Launching Jobs..."
$targetList | % {
    $boxName = $_
    #$boxName
    Start-Job -FilePath $scriptPath -ArgumentList $boxName -Name $boxName | Out-Null
}

Write-Verbose "Waiting for jobs to complete..."
get-job | Wait-Job | Out-Null

Write-Verbose "Assembling results..."
Get-Job | % {
    $result = Receive-Job  $_
    
    $hash = [ordered]@{
        "Hostname" = $result[0]
        "RAM (MB)" = $result[1]
    }
    
    $aggregate += (New-Object PSObject -Property $hash)
}    

$aggregate

