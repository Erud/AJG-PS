$stream = [System.IO.StreamWriter] "c:\temp\t.txt"
1..10000 | % {
      $stream.WriteLine($_)
}
$stream.close()