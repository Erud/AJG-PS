Import-Csv “C:\Temp\GroupsN.txt” -Delimiter "`t" | ForEach-Object {
	$GName = $_.GroupName
	$gdomain = $_.domain
	$name = $GName + "_" + $gdomain
	$gdomain = $_.domain + ".ajgco.com"
	
	# SamAccountName
    $GNameA = $null
    $GNameA = (Get-ADGroup -Filter {(cn -eq $GName) -or (SamAccountName -eq $GName)} -Server $gdomain).SamAccountName
	If ($GNameA)
	{
		$aUsers = @()
		Get-ADGroupMember -Identity $GNameA -Server $gdomain -Recursive |  %{
			
			
			$adn = $_.distinguishedName.split("{,}")
			$udc = $adn[-3].Split("=")[1] + "." + $adn[-2].Split("=")[1] + "." + $adn[-1].Split("=")[1]
			$ou1 = $null
			$ou2 = $null 
			$ou3 = $null 
			$ou4 = $null 
			$ou5 = $null 
			$ou6 = $null  
			$aou = $adn[-4].Split("=")
			if ($aou[0] -eq "OU") { $ou1 = $aou[1]}
			$aou = $adn[-5].Split("=")
			if ($aou[0] -eq "OU") { $ou2 = $aou[1]} 
			if ($adn.Count -gt 5) {
				$aou = $adn[-6].Split("=")
				if ($aou[0] -eq "OU") { $ou3 = $aou[1]} } 
			if ($adn.Count -gt 6) {
				$aou = $adn[-7].Split("=")
				if ($aou[0] -eq "OU") { $ou4 = $aou[1]} } 
			if ($adn.Count -gt 7) {
				$aou = $adn[-8].Split("=")
				if ($aou[0] -eq "OU") { $ou5 = $aou[1]} }
			if ($adn.Count -gt 8) { 
				$aou = $adn[-9].Split("=")
				if ($aou[0] -eq "OU") { $ou6 = $aou[1]} } 
			if ($_.objectClass -eq "user") {
				$uad = Get-ADUser $_ -Server $udc -Properties DistinguishedName,SamAccountName,userPrincipalname,name,mail,enabled,LockedOut,StreetAddress,city,State,Country,Department,company
				$hash = [ordered]@{
					Domain = $udc
					Group = $GName
					objectClass = "user"
					DistinguishedName = $uad.DistinguishedName
					SamAccountName = $uad.SamAccountName
					userPrincipalname = $uad.userPrincipalname
					name = $uad.name
					mail = $uad.mail				
					enabled = $uad.enabled
					LockedOut = $uad.LockedOut
					StreetAddress = $uad.StreetAddress
					city = $uad.city
					State = $uad.State
					Country = $uad.Country
					Department = $uad.Department
					company = $uad.company
					ou1 = $ou1
					ou2 = $ou2
					ou3 = $ou3
					ou4 = $ou4
					ou5 = $ou5
					ou6 = $ou6
				}
				$GP_user =  New-Object PSObject -Property $hash
				$aUsers += $GP_user
				
			}
			else {
				
				$hash = [ordered]@{
					Domain = $udc
					Group = $GName
					objectClass = "computer"
					DistinguishedName = $_.DistinguishedName
					SamAccountName = $_.SamAccountName
					userPrincipalname = $null
					name = $_.name
					mail = $null			
					enabled = $null
					LockedOut = $null
					StreetAddress = $null
					city = $null
					State = $null
					Country = $null
					Department = $null
					company = $null
					ou1 = $ou1
					ou2 = $ou2
					ou3 = $ou3
					ou4 = $ou4
					ou5 = $ou5
					ou6 = $ou6
				}
				$GP_user =  New-Object PSObject -Property $hash
				$aUsers += $GP_user
			}	
		}
		if ($aUsers.Count -eq 0) {
			Write-Host $gdomain $GName " <->  empty"
		}
		else { 
			$aUsers | Export-Excel -Path C:\temp\GroupsN.xlsx -WorkSheetname $Name -AutoSize -BoldTopRow 
		}
	}
	Else
	{
		
		Write-Host $gdomain $GName 
		
	}
}