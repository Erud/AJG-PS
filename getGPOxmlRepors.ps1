

$domain = "bsd.ajgco.com"

$GPOs = Get-GPO -all -Domain $domain -Server $domain

ForEach ($GPO in $GPOs) {

$gpodname = "c:\BSD Html GPO Reports\" + $GPO.DisplayName + ".Html"
Get-GPOReport -Name $GPO.DisplayName -ReportType Html -Domain bsd.ajgco.com -Path $gpodname -Server bsd.ajgco.com

} # end ForEach ($GPO in $GPOs)

