dir H:\aa -Recurse -File|
 % {
  $ph = $_.PSPath.substring(38); 
  $aph = $ph.Split('\')
  $fname = -join($aph[$aph.Count-3],"-",$aph[$aph.Count-2],"-",$aph[$aph.Count-1])
  Rename-Item -Path $ph -NewName $fname -WhatIf
  } 
  <#
  # Load the assembly. I used a relative path so I could off using the Resolve-Path cmdlet 
[Reflection.Assembly]::LoadFrom( "C:\Users\erudakov\Documents\WindowsPowerShell\Modules\taglib\taglib-sharp.dll")

# Load up the MP3 file. Again, I used a relative path, but an absolute path works too 
$media = [TagLib.File]::Create("C:\Users\Public\Music\Sample Music\Kalimba.mp3")

# set the tags 
#$media.Tag.Album = "Todd Klindt's SharePoint Netcast" 
#$media.Tag.Year = "2014" 
#$media.Tag.Title = "Netcast 185 - Growing Old with Todd" 
#$media.Tag.Track = "185" 
#$media.Tag.AlbumArtists = "Todd Klindt" 
#$media.Tag.Comment = "http://www.toddklindt.com/blog"

# Load up the picture and set it 
#$pic = [taglib.picture]::createfrompath("c:\Dropbox\Netcasts\Todd Netcast 1 - 480.jpg") 
#$media.Tag.Pictures = $pic

# Save the file back 
#$media.Save() 


$media.tag | Get-Member | Out-GridView

  #>