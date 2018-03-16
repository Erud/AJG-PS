$pathToCSFile = 'D:\Temp\erudakov\rps\PS\PolFileEditor.cs' 

# To import on PowerShell v3, you can use this command: 
Add-Type -Path $pathToCSFile -ErrorAction Stop 

$pf = New-Object TJX.PolFileEditor.PolFile 

$files = Get-ChildItem -Path "\\amer.ajgco.com\sysvol\amer.ajgco.com\Policies" -Filter registry.pol -Recurse 
$PCData = @()

foreach($file in $files) { 
	$strfile = $file.DirectoryName + '\Registry.pol'
	$pf.LoadFile($strfile) 
	
	foreach($entry in $pf.Entries) {
		
		$Props = [ordered]@{
			DirectoryName    = $file.DirectoryName
			Type             = $entry.Type
			KeyName          = $entry.KeyName
			ValueName        = $entry.ValueName
			DWORDValue       = $entry.DWORDValue
			QWORDValue       = $entry.QWORDValue
			StringValue      = $entry.StringValue
			MultiStringValue = $entry.MultiStringValue
			BinaryValue      = $entry.BinaryValue	
		} 
		
		$PCData += New-Object -TypeName PSObject -Property $Props
	}	
}
$PCData | Export-Csv -Delimiter `t -NoTypeInformation -Path d:\temp\allPolicy.txt