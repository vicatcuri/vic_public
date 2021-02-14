Get-AdUser -Filter * -Properties OfficePhone, DisplayName |`
Select-Object DisplayName, `
@{Name = "OfficePhone";Expression = {($_.OfficePhone -replace '[^0-9]')}} |`
Export-Csv -notypeinformation -Path $env:USERPROFILE\Desktop\phonelist.csv

Import-Csv -Path "$env:USERPROFILE\Desktop\phonelist.csv" | Where-Object { $_.PSObject.Properties.Value -ne '' } | Export-Csv -Path "$env:USERPROFILE\Desktop\phonelist_clean.csv" -NoTypeInformation

Remove-Item $env:USERPROFILE\Desktop\phonelist.csv