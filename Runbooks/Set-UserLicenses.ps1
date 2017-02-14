$domainName = "mrhodes.net"
$azureCredentialName = "mod272526"
$Location = "AU"

$cred = Get-AutomationPSCredential -Name $azureCredentialName
Connect-MsolService -Credential $cred

$users = get-msoluser -all -DomainName $domainName
$groups = get-msolgroup | Where-Object { 
    $_.displayname -like "LICENSE*" 
}

foreach ($group in $groups) {
    $members = Get-MsolGroupMember -GroupObjectId $group.ObjectId
    foreach ($user in $users) {
        if ($members.emailaddress -contains $user.userprincipalname) 
        {
            # check to see if license needs to be assigned
            if ($user.licenses.accountskuid -notcontains $group.description) 
            {
                # NEED TO ADD LICENSE
                # Check for Usage Location Set First          
                if (!$user.UsageLocation) {
                    Set-MsolUser $user.UserPrincipalName $user.UserPrincipalName -UsageLocation $Location
                }
                Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -AddLicenses $group.description
                Write-Output "$($user.userprincipalname) - $($group.description) License has been added"
            }
        } 
        else 
        {
            # check to see if license needs to be remove
            if ($user.licenses.accountskuid -contains $group.description) 
            {
                # LICENSE ALREADY THERE
                Write-Output "$($user.userprincipalname) - $($group.description) License has been removed"
                Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -RemoveLicenses $group.description
            }
        } 
    }
}
