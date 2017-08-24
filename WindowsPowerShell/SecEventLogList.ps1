$events = Get-EventLog -Log Security | Where-Object {$_.InstanceID -eq 5152}
$events | ForEach-Object {$_.message -match "Source Address:\s+(\S+)">$null;$_ | Add-Member -membertype noteproperty -name "SrcIP" -value $matches[1]}
$events | ForEach-Object {$_.message -match "Destination Address:\s+(\S+)">$null;$_ | Add-Member -membertype noteproperty -name "DstIP" -value $matches[1]}
$events | ForEach-Object {$_.message -match "Source Port:\s+(\S+)">$null;$_ | Add-Member -membertype noteproperty -name "SrcPort" -value $matches[1]}
$events | ForEach-Object {$_.message -match "Destination Port:\s+(\S+)">$null;$_ | Add-Member -membertype noteproperty -name "DstPort" -value $matches[1]}
$events | ForEach-Object {$_.message -match "Application Name:\s+(\S+)">$null;$_ | Add-Member -membertype noteproperty -name "AppName" -value $matches[1]}
$events | ft SrcIP, SrcPort, DstIP, DstPort, AppName -autosize