$line = "SAMAccountName" + "`t"+ "SAMAccountName" + "`t"+ "DisplayName"  + "`t"+ "DisplayName" + "`t"+ "Name" + "`t"+ "UserPrincipalName"
$line
Import-Csv “C:\Temp\CGM\kuserse1-.txt” -Delimiter "`t" | ForEach-Object {
	$user = $_.users
	$aduser = get-aduser -Server "emea.ajgco.com" -f {sAMAccountName -eq $user } -Properties *
    $Jaduser = get-aduser -Server "CGMJCA-DC1.cgmbrokers.local" -f {sAMAccountName -eq $user } -Properties *
	$line = $jaduser.SAMAccountName+"`t"+$aduser.SAMAccountName+"`t"+$jaduser.DisplayName+"`t"+$aduser.DisplayName+"`t"+$aduser.Name+"`t"+$aduser.UserPrincipalName
	$line
}
#sAMAccountName displayName