$Folder = "G:\Downloads"
 
#Delete files older than 6 months
Get-ChildItem $Folder -Recurse -Force -ea 0 |
Where-Object {!$_.PsIsContainer -and $_.LastWriteTime -lt (Get-Date).AddDays(-180)} |
ForEach-Object {
   $_ | Remove-Item -Force
   $_.FullName | Out-File C:\log\deletedlog.txt -Append
}
get-childitem -path \\server\folder  | where-object {
    $_.extension -eq ".pdf" -and ($_.LastWriteTime -gt (get-date).AddDays(-31))} | move-item -destination C:\test\test
     
     