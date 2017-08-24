$users = @()
$aGroups = @()
$users = Import-Csv “C:\Temp\CGM\kusers-8-21-171.txt” -Delimiter "`t"

foreach ($usern in $users) { 	
    $userName = $usern.SamAccountNam
	$groups = Get-ADPrincipalGroupMembership -Server "CGMJCA-DC1.cgmbrokers.local" -Identity $userName 
	$aGroups += $groups
    $usern = $null
}
$aGroups | Export-Excel -Path C:\Temp\CGM\JamGroups0821.xlsx -WorkSheetname "Jam Groups 0821s" -AutoSize -BoldTopRow 