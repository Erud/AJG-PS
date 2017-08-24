# Get-GPO -All | Format-Table Displayname,Owner,GPOstatus,ModificationTime,WmiFilter -AutoSize >c:\gpo.txt
Get-GPO -All | export-csv -delimiter "`t" -path c:\allGpos.csv