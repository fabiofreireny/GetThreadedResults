$boxName = $args[0]

if ((Test-Connection -ComputerName $boxname -Count 1 -Quiet -ErrorAction SilentlyContinue)) {

    $hash = [ordered]@{
        "Hostname"   = (gwmi -ComputerName $boxName -Class Win32_ComputerSystem).Name
        "RAM (MB)"   = [math]::round((gwmi -ComputerName $boxName -Class Win32_ComputerSystem).TotalPhysicalMemory / 1MB, 2)
        "OS Version" = (gwmi -ComputerName $boxName -Class Win32_OperatingSystem).Version
    }

} else {

    $hash = [ordered]@{
        "Hostname"   = $boxName
        "RAM (MB)"   = "Unknown"
        "OS Version" = "Unknown"
    }
}

$hash