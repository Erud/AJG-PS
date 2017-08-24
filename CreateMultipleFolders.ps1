$intFolders =10
$intPad
$i = 1
New-Variable -Name strPrefix -Value "testFolder" -Option Constant
do {
	if ($i -lt 10)
	{
		$intPad=0
		New-Item -Path c:\test -Name $strPrefix$intPad$i -ItemType directory
	}
	else
	{ 
		New-Item -Path c:\test -Name $strPrefix$i -ItemType directory
	}
	$i++
} until ($i -eq $intFolders+1)
