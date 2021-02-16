#Import AD Module
Import-Module ActiveDirectory

#Email Variables
$MailSender = " Password Reminder <helpdesk@curi.com>"
$Subject = 'FYI - Your network password will expire soon'
$SMTPServer = '10.10.0.125'



#Find accounts that are enabled and have expiring passwords (added additional where statement which filters out any accounts that aren't active employees using title, phonenumber, and company.)
#Temporarily changed the filter to only pull my AD account for now so that the script doesn't accidentally email everyone while testing.
$users = Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False -and PasswordLastSet -gt 0 } `
 -Properties "Name", "GivenName", "EmailAddress", "passwordLastSet", "msDS-UserPasswordExpiryTimeComputed", "telePhoneNumber", "Title", "Company" | `
 where {$_.telephonenumber -and $_.title -and $_.company} | `
 Select-Object -Property "Name", "GivenName", "EmailAddress", `
 @{Name = "DaysTilExp"; Expression = {(([datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")) - (get-date)).days }}, `
 @{Name = "PasswordExpiry"; Expression = {[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed") }}



#Check password expiration date and send email on match
foreach ($user in $users) {
	 #if ($user.DaysTilExp -le 2 -and $user.DaysTilExp -ge 0) {
	 if ($user.DaysTilExp -eq 14 -or $user.DaysTilExp -eq 10 -or $user.DaysTilExp -eq 7 -or $user.DaysTilExp -eq 3 -or $user.DaysTilExp -eq 2 -or $user.DaysTilExp -eq 1) {

#HTML for Body of email
$bodyHTML = @"
<html>
<head></head>
<body>
Hello $($user.GivenName),<br><br>
YOUR PASSWORD WILL EXPIRE IN <span style="color:red">$($user.DaysTilExp) DAYS </span>on $($user.PasswordExpiry.ToLongDateString()) at $($user.PasswordExpiry.toLongTimeString()).<br><br>
These notification emails will cease when your password has been changed.<br><br>
Prior to resetting your password, ensure that you are logged into your Curi issued laptop in a Curi office or connected to FortiClient VPN.<br><br>
<b>WINDOWS</b><br>
&nbsp&nbsp1.	Press <b>CONTROL+ALT+DELETE</b><br>
&nbsp&nbsp2.	Click <b>Change Password</b> and follow the prompts<br><br>
<b>MAC</b><br>
&nbsp&nbsp1.	Open System preferences <br>
&nbsp&nbsp2.	Select <b>Security and Privacy</b> <br>
&nbsp&nbsp3.	From <b>A login password has been set for this user</b> click on the <b>Change Password</b> button <br>
&nbsp&nbsp4.	Enter your old password, new password, and confirm the new password <br>
&nbsp&nbsp5.	Update the iCloud password, if prompted <br>
&nbsp&nbsp6.	Lock Screen <br>
&nbsp&nbsp7.	Verify the new password is used <br>
&nbsp&nbsp8.	Log Out and back in with new password <br>
&nbsp&nbsp9.	Restart <br>
&nbsp&nbsp10.	Login to FileVault with new password <br><br>
Your password must be a MINIMUM of 12 characters.<br><br>
Your Bitlocker PIN does NOT change when you change your network password.<br><br><br>
For additional assistance contact the Help Desk at <a href="helpdesk@curi.com">helpdesk@curi.com</a> or 919-878-7511 (x7511).<br><br>
</body>
</html>
"@

Send-MailMessage -from $MailSender -to $user.EmailAddress -subject $Subject -BodyAsHtml -Body $bodyHTML -SmtpServer $SMTPServer -Priority High
#Send-MailMessage -from $MailSender -to "vic.sweeting@curi.com" -subject $Subject -BodyAsHtml -Body $bodyHTML -SmtpServer $SMTPServer -Priority High
 	}
 }
 