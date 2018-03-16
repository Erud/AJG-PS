$pathToCSFile = 'H:\Scripts\PS\PolFileEditor.cs' 
 
# To import on PowerShell v3, you can use this command: 
Add-Type -Path $pathToCSFile -ErrorAction Stop 
 
# To make it work on PowerShell v2, use this command instead: 
#Add-Type -Language CSharpVersion3 -TypeDefinition ([System.IO.File]::ReadAllText($pathToCSFile)) -ErrorAction Stop 
 
$pf = New-Object TJX.PolFileEditor.PolFile 
 
# Show the methods and properties available in the PolFile class 
$pf | Get-Member 
 
try 
{ 
    $pf.LoadFile("C:\Temp\registry.pol") 
} 
catch 
{ 
    throw 
} 
 
# The basic SetXXXValue methods work basically the same as in the VBScript, except UInt64 values and Byte[] arrays are used when setting QWORD and REG_BINARY values, respectively (instead of strings containing hex characters). 
 
$pf.SetDWORDValue("Software\TJX\Testing", "Test DWORD Value", 1) 
$pf.SetQWORDValue("Software\TJX\Testing", "Test QWORD Value", 0x1F000F000L) 
$pf.SetStringValue("Software\TJX\Testing", "Test String Value", "The quick brown fox.") 
$pf.SetMultiStringValue("Software\TJX\Testing", "Test Multi String Value", @("String 1", "String 2")) 
$pf.SetBinaryValue("Software\TJX\Testing", "Test Binary Value", @(123,127,204,012,237,209)) 
 
# Just to show that a string value will have numeric output from the DWORDValue and QWORDValue properties later. 
$pf.SetStringValue("Software\TJX\Testing", "Test Numeric String Value", "12345") 
 
<# 
You can list the entries in the PolFile object with its Entries property.  Each PolEntry object has several property getters to attempt to convert the underlying binary data into whatever type you want (though the QWORDValue and DWORDValue properties will be null if you're working with a string value that does not contain numeric data, or a binary value that has the wrong nmber of bytes for those types).  
#> 
 
$pf.Entries 
 
try 
{ 
    $pf.SaveFile("C:\Users\dwyatt\desktop\new_registry.pol") 
} 
catch 
{ 
    throw 
} 
 
<# 
Just as with the VBScript version, if you want to modify a live local GPO on the system, you'll need to add code to increment the Version number in the GPO's GPT.ini file. 
#> 