$Props = @()
$aGPOs = @()

$Searcher = New-Object -TypeName System.DirectoryServices.DirectorySearcher
$Searcher.SearchRoot = "LDAP://DC=amer,DC=ajgco,DC=com"
$Searcher.SearchScope = "subtree"
$Searcher.Filter = "(objectClass=organizationalUnit)"
$Searcher.PropertiesToLoad.Add('Distinguishedname') | Out-Null
$LDAP_OUs = $Searcher.FindAll()
$OUs = $LDAP_OUs.properties.distinguishedname
$OUs += "DC=amer,dc=ajgco,dc=com"

# Loop through each OU 
foreach ($OU in $OUs) {
	
	$gpolinks = (Get-GPInheritance -Target $OU).GPOlinks
	$aArr = $ou -split ','
	[array]::Reverse($aArr)
	for($i = $aArr.Count; $i -le 12; $i++){$aArr += 'AAA'}
	foreach ($GPO in $gpolinks) {
		$Props = [ordered]@{
			OU = $OU
			GpoId = $GPO.GpoId
			DisplayName = $GPO.DisplayName
			Enabled = $GPO.Enabled
			Enforced = $GPO.Enforced
			GpoDomain = $GPO.GpoDomainName
			Order = $GPO.Order
			dc0 = $aArr[0]
			dc1 = $aArr[1]
			dc2 = $aArr[2]
			ou0 = $aArr[3]
			ou1 = $aArr[4]
			ou2 = $aArr[5]
			ou3 = $aArr[6]
			ou4 = $aArr[7]
			ou5 = $aArr[8]
			ou6 = $aArr[9]
			ou7 = $aArr[10]
			ou8 = $aArr[11]
			ou9 = $aArr[12]
			
		}
		$aGPOs += New-Object -TypeName PSObject -Property $Props
	}
}
$aGPOs | Export-Excel -Path D:\Temp\GPOlinks.xlsx -WorkSheetname "GPO_Links" -AutoSize -BoldTopRow
#$aGPOs | Export-Csv -Path C:\Temp\enumLinksA.txt