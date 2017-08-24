$content = Get-Content C:\erudakov\rps\groupsRPS.txt
foreach ($sline in $content) 
{
	$aline = $sline.split('\')
	$strGroup = $aline[1] 
	
	$dn = New-Object System.DirectoryServices.DirectoryEntry ("LDAP://RPSUSHC1DC02PP.smi-rps.ajgco.com/dc=smi-rps,dc=ajgco,dc=com")
	#$dn = New-Object System.DirectoryServices.DirectoryEntry ("LDAP://crpilrlmdc01vp.corp.ajgco.com/dc=corp,dc=ajgco,dc=com")
	
	$strGDN = (Get-ADGroup -filter { name -eq $strGroup}  -Server "RPSUSHC1DC02PP.smi-rps.ajgco.com").DistinguishedName
	#$strGDN = (Get-ADGroup -filter { name -eq $strGroup}  -Server "crpilrlmdc01vp.corp.ajgco.com").DistinguishedName
	
	$dsLookFor = new-object System.DirectoryServices.DirectorySearcher($dn)
	$dsLookFor.Filter = "(&(memberof:1.2.840.113556.1.4.1941:=$strGDN)(objectCategory=user))"; 
	$dsLookFor.SearchScope = "subtree"; 
	$n = $dsLookFor.PropertiesToLoad.Add("cn"); 
	$n = $dsLookFor.PropertiesToLoad.Add("distinguishedName");
	$n = $dsLookFor.PropertiesToLoad.Add("sAMAccountName");
	
	$lstUsr = $dsLookFor.findall()
	
	foreach ($usrTmp in $lstUsr) 
	{
		#Write-Host $strGroup "`t" $usrTmp.Properties["samaccountname"] 
		
		$strdn =  $usrTmp.Properties["distinguishedName"]
		if ($strdn[0] -match 'ChicAgo')
		{
			$sline + "`t"+  'Chicago'
			break 
		}
		
		
	}
	
}