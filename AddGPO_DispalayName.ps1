# read txt file converd GPO GUI to dispaly Name or empty wher no GPO and add it to the new file
$csv = Import-Csv -Path "D:\Temp\erudakov\GPMC\ExtmlinkGPO.txt" -Delimiter "`t"

foreach($gpo in $csv) { 
	
	try {
		$gpoattr = Get-GPO -Guid $gpo.GPO -Domain $gpo.GPO_Domain -Server $gpo.GPO_Domain
		$line = $gpo.SOM + "`t" + $gpo.GPO + "`t" + $gpoattr.DisplayName + "`t" + $gpo.GPO_Domain
	}
	catch {
		# something went wrong 
		$line = $gpo.SOM + "`t" + $gpo.GPO + "`t" + "" + "`t" + $gpo.GPO_Domain
	}
	
	$line
}