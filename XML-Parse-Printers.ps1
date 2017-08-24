$filename = "C:\Temp\fso\AMER-RPS Master Logon Script Data - DO NOT REMOVE.xml"
$xml = [xml](gc $filename)
$nsmgr = New-Object System.XML.XmlNamespaceManager($xml.NameTable)
$nsmgr.AddNamespace('root','http://www.microsoft.com/GroupPolicy/Settings')
$settings = [array]$xml.SelectNodes('//root:Extension',$nsmgr)
$types = $settings|select -ExpandProperty type|%{$_.split(":")[1]}
#$settings|?{$_.type -match "RegistrySettings"}|%{$_.RegistrySettings.Registry}|select -expand Properties

$aPrinters = @()
$settings|?{$_.type -match "Printers"} |%{$_.Printers.SharedPrinter}|%{
	
	
	$filters = $_.Filters.FilterGroup
	#$_.Filters | Get-Member
	foreach ($filter in $filters) {
		
		$hash = [ordered]@{
			GPOSettingOrder = $_.GPOSettingOrder
			action = $_.Properties.action
			path = $_.Properties.path
			
			bool = $filter.bool
			not = [int]$filter.not
			name = $filter.name
			sid = $filter.sid
		}

		$Printer =  New-Object PSObject -Property $hash
		$aPrinters += $Printer
		
	}
}
$aPrinters | Export-Excel -Path C:\Temp\fso\Printers_AMER-ML-new.xlsx -WorkSheetname "Printer Maps" -AutoSize -BoldTopRow 