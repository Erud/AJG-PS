$MachineList = Get-Content -Path c:\ListOfMachines.txt; # One system name per line
foreach ($Machine in $MachineList){
    ($Machine + ": " + @(Get-WmiObject -ComputerName $Machine -Namespace root\cimv2 -Class Win32_ComputerSystem)[0].UserName);
}