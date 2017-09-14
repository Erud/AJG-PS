$GPOs = @('A','F','G','I','J','K','L','M','N','O','P','Q','R','S','T','X','Z')
$line = "Letter" +"`t" + "Trustee Domain" +"`t" + "Trustee Name" +"`t"+ "Trustee Type" +"`t"+ "Permission"
$line
foreach ($GPO in $GPOs) {
	$name = "RPS Master Logon Map " + $GPO
	$gpperm = Get-GPPermission -Name $name -Server "amer.ajgco.com" -DomainName "amer.ajgco.com" -all
	$fname = "D:\Temp\fso\"+$name+".txt"
	$agpp = @()
	
	foreach ($gpp in $gpperm) {
		
		$line = $GPO +"`t" + $gpp.Trustee.Domain +"`t" + $gpp.Trustee.Name +"`t"+ $gpp.Trustee.SidType +"`t"+ $gpp.Permission
		$line
	}  
	
}