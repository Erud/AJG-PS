function show-menu {

[void][reflection.assembly]::Load('System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$formShowmenu = New-Object 'System.Windows.Forms.Form'
$combobox1 = New-Object 'System.Windows.Forms.ComboBox'
$label1 = New-Object 'System.Windows.Forms.Label'


$combobox1_SelectedIndexChanged = {
$script:var = $combobox1.SelectedItem
$formShowmenu.Close()
}

$label1.Text = 'try label'
$label1.Anchor = 'Top' 
#$label1.Location = '12,97'
$label1.c

$formShowmenu.Controls.Add($label1)
$formShowmenu.Controls.Add($combobox1)
$formShowmenu.AutoScaleDimensions = '6, 13'
$formShowmenu.AutoScaleMode = 'Font'
$formShowmenu.ClientSize = '284, 470'

#add array of items
[void]$combobox1.Items.Addrange(1 .. 10)

#add single item
#[void]$combobox1.Items.Add('Single Item')

$combobox1.Location = '45, 25'
$combobox1.Size = '187, 21'
$combobox1.add_SelectedIndexChanged($combobox1_SelectedIndexChanged)

$formShowmenu.ShowDialog() | out-null

write-output $var
}
show-menu