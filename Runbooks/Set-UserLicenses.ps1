$domainName = "mrhodes.net"
$azureCredentialName = "mod272526"
$Location = "AU"

$cred = Get-AutomationPSCredential -Name $azureCredentialName
Connect-MsolService -Credential $cred

$users = get-msoluser -all -DomainName $domainName
$groups = get-msolgroup | ?{$_.displayname -like "LICENSE*"}
Foreach ($group in $groups) {
    $members = Get-MsolGroupMember -GroupObjectId $group.ObjectId
    Foreach ($user in $users) {
        If ($members.emailaddress -contains $user.userprincipalname) {
            # check to see if license needs to be assigned
            If ($user.licenses.accountskuid -notcontains $group.description) {
                # NEED TO ADD LICENSE
                # Check for Usage Location Set First          
                if (!$user.UsageLocation) {
                    Set-MsolUser $user.UserPrincipalName $user.UserPrincipalName -UsageLocation $Location
                }
                Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -AddLicenses $group.description
                Write-Host "$($user.userprincipalname) - $($group.description) License has been added"
            }
        } else {
            # check to see if license needs to be remove
            If ($user.licenses.accountskuid -contains $group.description) {
                # LICENSE ALREADY THERE
                Write-Host "$($user.userprincipalname) - $($group.description) License has been removed"
                Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -RemoveLicenses $group.description
            }
        } 
    }
}
