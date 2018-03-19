$boxName = $args[0]

if ((Test-Connection -ComputerName $boxname -Count 1 -Quiet)) {

    (gwmi -ComputerName $boxName -Class Win32_ComputerSystem).Name
    [math]::round((gwmi -ComputerName $boxName -Class Win32_ComputerSystem).TotalPhysicalMemory / 1MB, 2)

} else {

    $boxName
    "Unreachable"
}