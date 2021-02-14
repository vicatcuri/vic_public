#Grab name and number from AD 
Get-AdUser -Filter * -Properties OfficePhone, DisplayName |`
Select-Object DisplayName, `
@{Name = "OfficePhone";Expression = {($_.OfficePhone -replace '[^0-9]')}} |`
#Export to CSV
Export-Csv -notypeinformation -Path $env:USERPROFILE\Desktop\phonelist.csv
#Create 'clean' copy with no white space
Import-Csv -Path "$env:USERPROFILE\Desktop\phonelist.csv" | Where-Object { $_.PSObject.Properties.Value -ne '' } | Export-Csv -Path "$env:USERPROFILE\Desktop\phonelist_clean.csv" -NoTypeInformation
#Remove orignal file
Remove-Item $env:USERPROFILE\Desktop\phonelist.csv
