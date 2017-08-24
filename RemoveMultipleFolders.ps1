$intFolders =10
$intPad
$i = 1
New-Variable -Name strPrefix -Value "testFolder" -Option Constant -Force
do {
	if ($i -lt 10)
	{
		$intPad=0
		remove-Item -Path c:\test\$strPrefix$intPad$i 
	}
	else
	{ 
		remove-Item -Path c:\test\$strPrefix$i
	}
	$i++
} until ($i -eq $intFolders+1)
