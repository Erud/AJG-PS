$filename = "C:\Temp\fso\AMER - new - RPS Master Logon Script Data - DO NOT REMOVE.xml"
$xml = [xml](gc $filename)
$nsmgr = New-Object System.XML.XmlNamespaceManager($xml.NameTable)
$nsmgr.AddNamespace('root','http://www.microsoft.com/GroupPolicy/Settings')
$settings = [array]$xml.SelectNodes('//root:Extension',$nsmgr)
$types = $settings|select -ExpandProperty type|%{$_.split(":")[1]}
#$settings|?{$_.type -match "RegistrySettings"}|%{$_.RegistrySettings.Registry}|select -expand Properties

$aDrives = @()
$settings|?{$_.type -match "DriveMapSettings"}|%{$_.DriveMapSettings.Drive}|%{
	
	
	$filters = $_.Filters.FilterGroup
	if ($filters.HasAttributes) {
		#$_.Filters | Get-Member
		foreach ($filter in $filters) {
			
			$hash = [ordered]@{
				GPOSettingOrder = $_.GPOSettingOrder
				action = $_.Properties.action
				path = $_.Properties.path
				label = $_.Properties.label
				letter = $_.Properties.letter
				bool = $filter.bool
				not = [int]$filter.not
				name = $filter.name
				sid = $filter.sid
			}
			
			$drive =  New-Object PSObject -Property $hash
			$aDrives += $drive
			
		}
	}
	else {
		$hash = [ordered]@{
			GPOSettingOrder = $_.GPOSettingOrder
			action = $_.Properties.action
			path = $_.Properties.path
			label = $_.Properties.label
			letter = $_.Properties.letter
			bool = $null
			not = $null
			name = $null
			sid = $null
		}
		
		$drive =  New-Object PSObject -Property $hash
		$aDrives += $drive
	}
}
$aDrives | Export-Excel -Path C:\Temp\fso\Drives_AMER-new-ML.xlsx -WorkSheetname "Drive Maps" -AutoSize -BoldTopRow 