$users = @()
$users = Import-Csv “C:\Temp\CGM\kusers-8-21-171.txt” -Delimiter "`t"

foreach ($usern in $users) { 	
    $userName = $usern.SamAccountNam
	Get-ADPrincipalGroupMembership -Server "CGMJCA-DC1.cgmbrokers.local" -Identity $userName | ForEach-Object {
		$adGroup =	Get-ADGroup -Identity $_.SamAccountName  -Server "CGMJCA-DC1.cgmbrokers.local" -Properties * 
		$line = $adGroup.SamAccountName + "`t" + $adGroup.DisplayName
		$line	
	}
    $usern = $null
}