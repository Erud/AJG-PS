

$domain = "smi-rps.ajgco.com"

$GPOs = Get-GPO -all -Domain $domain -Server $domain

ForEach ($GPO in $GPOs) {
$gpodnam = $GPO.DisplayName -replace '/', '_'
$gpodname = "c:\SMI-RPS XML GPO Reports\" + $gpodnam + ".xml"

Get-GPOReport -Name $GPO.DisplayName -ReportType xml -Domain $domain -Path $gpodname -Server $domain

} # end ForEach ($GPO in $GPOs)

