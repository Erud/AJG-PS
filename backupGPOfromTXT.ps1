$GPOs = Get-Content -Path D:\Temp\stevel\gpos.txt
$domain = ""

foreach ($GPO in $GPOs) {
	
	Backup-GPO -Name $gpo -Path c:\gpobackups -Domain $domain -Server $domain
	
}