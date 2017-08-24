Import-Csv “C:\temp\Groups.csv” -Delimiter "`t" | ForEach-Object {
	$GName = $_.GroupName
	$gdomain = $_.domain
	$name = $GName + "_" + $gdomain
	$gdomain = $_.domain + ".ajgco.com"
	
	
	If (Get-ADGroup -Filter {SamAccountName -eq $GName } -Server $gdomain )
	{
		Get-ADGroupMember -Identity $GName -Server $gdomain -Recursive | Export-Excel -Path C:\temp\Groups.xlsx -WorkSheetname $Name -AutoSize
	}
	Else
	{
		If (Get-ADGroup -Filter {name -eq $GName } -Server $gdomain )
		{
			Get-ADGroupMember -Identity $GName -Server $gdomain -Recursive  | Export-Excel -Path C:\temp\Groups.xlsx -WorkSheetname $Name -AutoSize
		}
		Else
		{
			Write-Host $gdomain $GName 
		}
	}
}