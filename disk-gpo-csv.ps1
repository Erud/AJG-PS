# File listing the drive mappings via GPO.
$ExportFile = "GetGPO_DriveMappings.csv"
$Pathf = "C:\Temp\fso"
# Creates .csv file for logging.
$Header = "Drive Letter,Action,Drive Path,Group"
Set-Content -Path $Pathf\$ExportFile -Value $Header




$GPOID = "{1346D210-38E5-4AA7-9BA5-67481C0A79A2}"
$GPODom = "smi-rps.ajgco.com"
$pso = "\\"+$GPODom+"\SYSVOL\"+$GPODom+"\Policies\"+$gpoid+"\User\Preferences\Drives\Drives.xml"
If (Test-Path $pso)
{
	[xml]$DriveXML = Get-Content $pso
	ForEach ( $MapDrive in $DriveXML.Drives.Drive )
	{
		
		$DriveLetter = $MapDrive.Properties.Letter + ":"
		$DrivePath = $MapDrive.Properties.Path
		$DriveAction = $MapDrive.Properties.action.Replace("U","Update").Replace("C","Create").Replace("D","Delete").Replace("R","Replace")
		$Filters = $MapDrive.Filters
		$FilterOrgUnit = $null
		$FilterGroup = $null
		$FilterUser = $null
		ForEach ($FilterGroup in $Filters.FilterGroup)
		{
			$FilterGroupName = $FilterGroup.Name
			if ($Filters.FilterOrgUnit.count -gt 0) {
				ForEach ($FilterOrgUnit in $Filters.FilterOrgUnit)
				{
					$FilterOrgUnitName = $FilterOrgUnit.Name
					$FilterOrgUnitName = $FilterOrgUnitName -Replace (",",";")
					ForEach ($FilterUser in $Filters.FilterUser)
					{
						$FilterUserName = $FilterUser.Name
						$ExportText = "$DriveLetter,$DriveAction,$DrivePath,$FilterGroupName,$FilterOrgUnitName,$FilterUserName"
						Add-Content -Path $Pathf\$ExportFile -value $ExportText
					}
				}
			}
			else {
				$ExportText = "$DriveLetter,$DriveAction,$DrivePath,$FilterGroupName"
				Add-Content -Path $Pathf\$ExportFile -value $ExportText
			}
		}
	}
}

