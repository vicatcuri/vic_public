$limit = (Get-Date).AddDays(-15)
$path = "C:\Some\Path"
$date = (get-date).AddDays(-31)
 
# Delete files older than the $limit.
Get-ChildItem -Path $path -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item -Force

Get-Childitem \\server\folder *.pdf | where-object {$_.LastWriteTime -gt $date} |
    move-item -destination \\server\folder\folder2