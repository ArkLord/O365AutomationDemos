param (
    [object]
    $WebhookData
)

$requestBody = ConvertFrom-Json $WebhookData.RequestBody

Write-Output "Request received via webhook '$($WebhookData.WebhookName)' by user '$($WebhookData.RequestHeader.From)' at $($WebhookData.RequestHeader.Date)"

$credential = Get-AutomationPSCredential -Name 'mod272526'
$domainName = Get-AutomationVariable -Name 'Office365DomainName'

$upn = "$($requestBody.Alias)@$domainName"

Connect-MsolService -Credential $credential

Write-Output "Adding license '$($requestBody.License)' to user $upn"
Set-MsolUserLicense -UserPrincipalName $upn -AddLicenses $requestBody.License

Write-Output "Runbook complete"
