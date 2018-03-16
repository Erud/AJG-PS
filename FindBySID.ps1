$SID = "S-1-5-21-1154047922-2052080824-1991979751-3493"

#(Get-ADForest).Domains| %{Get-ADObject -IncludeDeletedObjects -Filter * -Properties * -Server $_ | where{$_.objectSid -eq $SID} }
(Get-ADForest).Domains| %{Get-ADGroup -Identity $SID -Server $_ }