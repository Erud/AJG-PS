$domain = "bsd.ajgco.com" 
$GPOname = "Copy of CVG - Default Policy"

Get-GPOReport -Name $GPOName -ReportType xml -Domain $domain -Server $domain -Path "C:\Temp\$gponame.xml"