$SIDs = Get-Content -Path D:\Temp\stevel\sids.txt
foreach ($sid in $SIDs) {
	
	$objSID = New-Object System.Security.Principal.SecurityIdentifier ($sid) 
	try {
		$objUser = $objSID.Translate( [System.Security.Principal.NTAccount])
		$uid = $objUser.Value
	}
	catch {
		$uid = "error"
	}
	
	$line = $sid + "`t" + $uid
	$line
}