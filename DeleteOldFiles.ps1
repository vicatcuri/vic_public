##########################################################
#
#This PowerShell script deletes files older than 180 days in the folder \\Its-bo4srv\ods_reports\PROD\DIP_IMPORT_GT90DAYS
#
#Nehru Chedella		02-22-2021		Initial version
#
##########################################################

$DaysLimit = (Get-Date).AddDays(-90)
$Folder = "C:\Nehru\files_gt_90day_old"
$Log_Folder = "C:\Nehru\log\"

Get-Date | Out-File $Log_Folder\deletedlog.txt -Append

Get-ChildItem $Folder -Force -ea 0 |
Where-Object {$_.LastWriteTime -lt $DaysLimit} |
ForEach-Object {
   $_ | Remove-Item -Force
   $_.FullName | Out-File $Log_Folder\deletedlog.txt -Append
}
