function Get-filesbyDate
{
 Param(
 [string[]]$filetypes =@("*.ps1", "*.psm1"),
 [int]$month,
 [int]$year,
 [Parameter(Mandatory=$true)]
 [string[]]$path)
 Get-ChildItem -Path $path -Include $filetypes -Recurse | Where-Object { $_.LastWriteTime.Month -eq $month -and $_.LastWriteTime.Year -eq $year} 
}

get-filesbydate  -month 2 -year 2017 -path H:\Scripts\PS