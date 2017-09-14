$GPOs = @('A','F','G','I','J','K','L','M','N','O','P','Q','R','S','T','X','Z')

foreach ($GPO in $GPOs) {
	$name = "RPS Master Logon Map " + $GPO
	$gpperm = Get-GPPermission -Name $name -Server "amer.ajgco.com" -DomainName "amer.ajgco.com" -all
	$fname = "D:\Temp\fso\"+$name+".txt"
	$outarray = @()

	foreach ($gpp in $gpperm) {
		if (($gpp.Trustee.Domain -ne 'NT AUTHORITY') -and ($gpp.Trustee.Name -ne 'Enterprise Admins') -and ($gpp.Trustee.Name -ne 'Domain Admins') ){
			$outarray +=  New-Object PsObject -property @{
				'Domain' = $gpp.Trustee.Domain
				'Name' = $gpp.Trustee.Name
				'Type' = $gpp.Trustee.SidType
				'Permission' = $gpp.Permission
			}
		}
	} 
 
	$outarray |export-csv -Path $fname -NoTypeInformation -Delimiter "`t"
}
