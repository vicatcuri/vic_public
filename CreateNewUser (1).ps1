$samaccountname = Read-Host -Prompt "Enter SamAccountName (pre-2000 logon)"
$givenname = Read-Host -Prompt "Input user's first name"
$surname = Read-Host -Prompt "Input user's last name"
$displayname = $givenname + ' ' + $surname
$upn = "$givenname.$surname@curi.com".tolower()
$mail = "$upn"
$mailnickname = $samaccountname
$proxyaddresses = "SMTP:$upn"
$telephonenumber = Read-Host -Prompt "Input user's desk phone extension in XXX-XXX-XXXX format"
$fax = Read-Host -Prompt "Input user's fax extension in XXX-XXX-XXXX format"
$ipphone = $telephonenumber.Substring($telephonenumber.Length - 4)
#$mobile = Read-Host -Prompt "Input user's mobile number in XXX-XXX-XXXX format"         #This is not needed currently. We don't usually get mobile numbers until after they've started.

#START address choice code.
$office = Read-Host -Prompt "Choose from the following options:`n1) Raleigh`n2)Camp Hill`n3)Philadelphia`n4)Other (manual entry)"
if ($office -eq 1)
   {
   $office = "Raleigh"
   $streetaddress = "700 Spring Forest Road, Suite 400"
   $state = "NC"
   $postalcode = 27609
   }
elseif ($office -eq 2)
   {
   $office = "Camp Hill"
   $streetaddress = "1250 Camp Hill Bypass, Suite 108"
   $state = "PA"
   $postalcode = 17011
   }
elseif ($office -eq 3)
   {
   $office = "Philadelphia"
   $streetaddress = "1818 Market Street, Suite 2710"
   $state = "PA"
   $postalcode = 19103
   }
else
   {
   $office = Read-Host -Prompt "Input user's office location (e.g., Raleigh, Camp Hill, Philadelphia)"
   $streetaddress = Read-Host -Prompt "Input user's street address (minus city, state, zip)"
   $state = Read-Host -Prompt "Input user's state in XX format"
   $postalcode = Read-Host -Prompt "Input user's 5 digit zip"
   }

$city = "$office"
$country = "US"
$homepage = "https://curi.com"
#END address choice code.


#START department choice code
$choice = 0
$department = "GU-Guest"

Write-Host "Choose from the following options:`n1) AD-Administration`n2)EB-Employee Benefits Division`n3)CM-Claims Management`n4)FI-Finance`n5)HR-Human Resources`n6)IT-Information Technologies`n7)MC-Communications`n8)MK-Marketing`n9)PM-Policy Management`n10)RA-Regulatory Affairs`n11)RM-Risk Management"
$choice = Read-Host -Prompt "Type the number of the desired OU"

if ($choice -eq 1)
   {$department = "AD-Administration"}
elseif ($choice -eq 2)
   {$department = "EB-Employee Benefits Division"}
elseif ($choice -eq 3)
    {$department = "CM-Claims Management"}
elseif ($choice -eq 4)
    {$department = "FI-Finance"}
elseif ($choice -eq 5)
    {$department = "HR-Human Resources"}
elseif ($choice -eq 6)
    {$department = "IT-Information Technology"}
elseif ($choice -eq 7)
    {$department = "MC-Communications"}
elseif ($choice -eq 8)
    {$department = "MK-Marketing"}
elseif ($choice -eq 9)
    {$department = "PM-Policy Management"}
elseif ($choice -eq 10)
    {$department = "RA-Regulatory Affairs"}
elseif ($choice -eq 11)
    {$department = "RM-Risk Management"}
else
    {$department = "GU-Guest"}

Write-Host "'$department' selected."
#END Department choice code

if ($department -eq "EB-Employee Benefits Division")
    {
    $deptName = "Employee Benefits Division"
    $department = "AG-Agency"
    }
else
    {
    $deptName = $($department.substring(3))
    }


$title = Read-Host -Prompt "Input user's job title"
$company = Read-Host -Prompt "Input company name"
$manager = Read-Host -Prompt "Input user's manager's SamAccountName (pre-2000 logon)"

$OU = Get-ADOrganizationalUnit -Filter {name -eq $department} -Properties distinguishedname | where {$_.distinguishedname -like "*OU=MMIC*"}| select -ExpandProperty distinguishedname
#$OU="OU=Remote Risk Consultants,OU=RM-Risk Management,OU=MMIC,DC=mmicnc,DC=local"
$manager = get-aduser $manager | select -ExpandProperty distinguishedname
$distinguishedname = "CN=$displayname," + $OU


$defaultpassword = ConvertTo-SecureString -String "W3lc0me12345" -AsPlainText -Force

New-ADUser $samaccountname -Path "$OU" -OtherAttributes @{distinguishedname="$distinguishedname";givenname="$givenname";sn="$surname";displayname="$displayname";userprincipalname="$upn";mail="$mail";mailnickname="$mailnickname";proxyaddresses="$proxyaddresses";telephonenumber="$telephonenumber";facsimileTelephoneNumber="$fax";ipphone="$ipphone";<#mobile="$mobile";#>physicalDeliveryOfficeName="$office";streetaddress="$streetaddress";l="$city";st="$state";postalcode="$postalcode";c="$country";WWWHomePage="$homepage";title="$title";department="$deptName";company="$company";manager="$manager"} -AccountPassword $defaultpassword -Enabled $True
