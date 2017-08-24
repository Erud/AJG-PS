$ns = New-Object System.Xml.XmlNamespaceManager($xml1.NameTable)
$ns.AddNamespace("xsi", "http://www.w3.org/2001/XMLSchema-instance")
$nodes = $xml1.SelectNodes("//gpo/User/extensiondata/extension/type[@xsi:type='q1:DriveMapSettings']", $ns)
ForEach($node in $nodes)
{
    $node.InnerText
}