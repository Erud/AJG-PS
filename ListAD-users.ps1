$line = "SAMAccountName" + "`t"+ "DisplayName" + "`t"+ "Name" + "`t"+ "UserPrincipalName" + "`t"+ "Enabled"
$line
Import-Csv “C:\Temp\CGM\kusers.txt” -Delimiter "`t" | ForEach-Object {
	$user = $_.users
	$aduser = get-aduser -Server "emea.ajgco.com" -f {displayName -eq $user } -Properties *
	$line = $aduser.SAMAccountName + "`t"+ $aduser.DisplayName + "`t"+ $aduser.Name + "`t"+ $aduser.UserPrincipalName + "`t"+ $aduser.Enabled
	$line
}