##########################################################
#
#This PowerShell script moves files older than 90 days in the folder 
#\\Its-bo4srv\ods_reports\PROD\DIP_IMPORT to \\Its-bo4srv\ods_reports\PROD\DIP_IMPORT_GT90DAYS
#
#Nehru Chedella		02-22-2021		Initial version
#
##########################################################

$DaysLimit = (Get-Date).AddDays(-30)
$Source_Folder = "C:\Nehru\source_files"
$Destination_Folder = "C:\Nehru\files_gt_90day_old"
$Log_Folder = "C:\Nehru\log\"

Get-Date | Out-File $Log_Folder\movedlog.txt -Append

Foreach($file in (Get-ChildItem $Source_Folder))
{
	If($file.LastWriteTime -lt $DaysLimit)
	{
		$file.fullname | Out-File $Log_Folder\movedlog.txt -Append
		Move-Item -Path $file.fullname -Destination $Destination_Folder
		#####Write-Host "Hello!!!!!";
	}
}
