import-module ActiveDirectory

#Set the domain to search at the Server parameter. Run powershell as a user with privilieges in that domain to pass different credentials to the command.
#Searchbase is the OU you want to search. By default the command will also search all subOU's. To change this behaviour, change the searchscope parameter. Possible values: Base, onelevel, subtree
#Ignore the filter and properties parameters

$ADUserParams=@{
'Server' = 'corp.ajgco.com'
'Searchbase' = 'OU=Users,OU=CIS,OU=Itasca,OU=LOCATIONS,DC=corp,DC=ajgco,DC=com'
'Searchscope'= 'Subtree'
'Filter' = '*'
'Properties' = '*'
}

#This is where to change if different properties are required.

$SelectParams=@{
'Property' = 'SAMAccountname', 'CN', 'title', 'DisplayName', 'userPrincipalName', 'Description', 'EmailAddress', 'mobilephone',@{name='businesscategory';expression={$_.businesscategory -join '; '}}, 'office', 'officephone', 'state', 'streetaddress', 'city', 'employeeID', 'Employeenumber','employeeType', 'enabled', 'lockedout', 'lastlogondate', 'badpwdcount', 'passwordlastset', 'created'
}

get-aduser @ADUserParams | select-object @SelectParams  | export-csv "c:\temp\users.csv" -NoTypeInformation