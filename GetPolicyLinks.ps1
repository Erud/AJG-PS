Function Get-AllGPO
{
	Get-GPOReport -all -ReportType xml | %{
		([xml]$_).gpo | select name,@{n="SOMName";e={$_.LinksTo | % {$_.SOMName}}},@{n="SOMPath";e={$_.LinksTo | %{$_.SOMPath}}}
	}
}

#Get Gpo with name Turn* and display what OU is linked.
Get-AllGPO | ? {$_.Name -match "Default*"} | %{$_.SomName, $_.Name}

