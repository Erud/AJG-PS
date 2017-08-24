Get-ADGroup -ResultSetSize $null -Filter * -Properties GroupType |
Where-Object {$_.SID -like "S-1-5-21-516949104*"} |
Format-Table Name,GroupScope,GroupCategory,GroupType,SID

Get-ADGroup -ResultSetSize $null -Filter * -Properties GroupType -Server "bsd.ajgco.com"| Out-GridView # all groups in domain

Get-ADuser -ResultSetSize $null -Filter * -Server "bsd.ajgco.com"| Out-GridView # all users in domain