$boxName = $args[0]

if ((Test-Connection -ComputerName $boxname -Count 1 -Quiet -ErrorAction SilentlyContinue)) {

    $os = (Get-CimInstance -ComputerName $boxName -Class Win32_OperatingSystem)
    $cs = (Get-CimInstance -ComputerName $boxName -Class Win32_ComputerSystem)

    $hash = [ordered]@{
        "Hostname"   =               $cs.Name
        "RAM (MB)"   = [math]::round($cs.TotalPhysicalMemory / 1MB, 2)
        "OS Version" =               $os.Version
        "Last Boot"  =               $os.LastBootUpTime
    }

} else {

    $hash = [ordered]@{
        "Hostname"   = $boxName
        "RAM (MB)"   = "Unknown"
        "OS Version" = "Unknown"
        "Last Boot"  = "Unknown"
    }
}

$hash