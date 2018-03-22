﻿<#
.SYNOPSIS
Retrieve data from multiple computers

.DESCRIPTION
This script will execute whatever is specified by $scriptPath on each machine in $targetList
What sets this script apart is that it uses jobs, so queries run in parallel

.EXAMPLE
.\GetThreadedResults.ps1 -targetList (get-content .\targetList.txt) -scriptPath .\JobScript.ps1 -Verbose
#>

Param(
    [Parameter(Mandatory=$True,ValueFromPipeline=$True,HelpMessage="List of computer names.")]
    [string[]]$targetList,

    [Parameter(Mandatory=$True)]
    [string]$scriptPath
)

Begin {

    #initialize variables
    $aggregate = @()

    #remove any existing jobs
    Get-Job | Remove-Job -Force

    Write-Verbose "Launching Jobs..."
} 

Process {

    $targetList | % {
        $boxName = $_
        #$boxName
        Start-Job -FilePath $scriptPath -ArgumentList $boxName -Name $boxName | Out-Null
    }
} 

End {

    Write-Verbose "Waiting for jobs to complete..."

    $aggregate = Get-Job | % {
        [PSCustomObject](Receive-Job $_ -AutoRemoveJob -Wait)
    }    

    $aggregate
}