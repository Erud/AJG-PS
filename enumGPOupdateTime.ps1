

$domain = "bsd.ajgco.com"

$GPOs = Get-GPO -all -Domain $domain -Server $domain
#$gpo = Get-GPO -Name "Copy of CVG - Default Policy" -Server "bsd.ajgco.com" -Domain "bsd.ajgco.com"


$strline = "GPO" + "`t" + "Description" + "`t" + "Owner" + "`t" + "Computer" + "`t" + "GpoStatus" + "`t" + "CreationTime" + "`t" + "ModificationTime" 
$strline

ForEach ($GPO in $GPOs) {

	$gpo.DisplayName + "`t" +  $gpo.Description + "`t" + $GPO.Owner + "`t" +  $GPO.Computer + "`t" +  $gpo.GpoStatus + "`t" +  $gpo.CreationTime + "`t" + $gpo.ModificationTime 

} # end ForEach ($GPO in $GPOs)