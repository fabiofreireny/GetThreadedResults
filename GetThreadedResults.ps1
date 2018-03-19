<#
.SYNOPSIS
Retrieve data from multiple computers

.DESCRIPTION
This script will scan all machines in a given list and whatever is specified by $scriptPath
What sets this script apart is that it uses jobs, so multiple queries run in parallel

.EXAMPLE
.\GetThreadedResults.ps1 -targetList (get-content .\targetList.txt) -scriptPath .\JobScript.ps1
#>

Param(
    [string[]]$targetList,
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
    $result = Receive-Job $_ -AutoRemoveJob -Wait
    
    $aggregate += (New-Object PSObject -Property $result)
}    

$aggregate

