$content = Get-Content C:\erudakov\rps\groupsRPS1.txt
foreach ($sline in $content) 
{
	$aline = $sline.split('\')
	$strGroup = $aline[1] 
	
	$dn = New-Object System.DirectoryServices.DirectoryEntry ("LDAP://RPSUSHC1DC02PP.smi-rps.ajgco.com/dc=smi-rps,dc=ajgco,dc=com")
	#$dn = New-Object System.DirectoryServices.DirectoryEntry ("LDAP://crpilrlmdc01vp.corp.ajgco.com/dc=corp,dc=ajgco,dc=com")
	
	$strGDN = (Get-ADGroup -filter { name -eq $strGroup}  -Server "RPSUSHC1DC02PP.smi-rps.ajgco.com").DistinguishedName
	If ($Error) {
		Write-Host $sline "`t" $strGDN
	}
	$error.clear()
	#$strGDN = (Get-ADGroup -filter { name -eq $strGroup}  -Server "crpilrlmdc01vp.corp.ajgco.com").DistinguishedName
	
	$dsLookFor = new-object System.DirectoryServices.DirectorySearcher($dn)
	If ($Error) {
		Write-Host $strGroup "`t" $strGDN
	}
	$dsLookFor.Filter = "(&(memberof:1.2.840.113556.1.4.1941:=$strGDN)(objectCategory=user))"; 
	$dsLookFor.SearchScope = "subtree"; 
	$n = $dsLookFor.PropertiesToLoad.Add("cn"); 
	$n = $dsLookFor.PropertiesToLoad.Add("distinguishedName");
	$n = $dsLookFor.PropertiesToLoad.Add("sAMAccountName");
	
	$lstUsr = $dsLookFor.findall()
	
	If ($Error) {
		Write-Host $sline "`t" $strGDN
	}
    $error.clear()
	$OutArray = @()
	foreach ($usrTmp in $lstUsr) 
	{
		#Write-Host $strGroup "`t" $usrTmp.Properties["samaccountname"] "`t" $usrTmp.Properties["distinguishedName"]
		#Construct an object
		$myobj = "" | Select "group","samaccountname","distinguishedName"
		#fill the object
		$myobj.group = $strGroup
		$smacc = $usrTmp.Properties["samaccountname"]
		$myobj.samaccountname = $smacc[0]
		$strdn =  $usrTmp.Properties["distinguishedName"]
		$myobj.distinguishedName = $strdn[0]
		
		#Add the object to the out-array
		$outarray += $myobj
		
		#Wipe the object just to be sure
		$myobj = $null
	}
	If ($Error) {
		Write-Host $sline "`t" $strGDN
	}
    $error.clear()
	$OutArray = @()
	#After the loop, export the array to CSV
	$outfile = "C:\Temp\Groups\$strGroup"+".txt"
	$outarray | export-csv $outfile -NoTypeInformation
}