$uri = "https://s3events.azure-automation.net/webhooks?token=C6ly%2fuW%2fUq4vcboi0NO7DHOmTYWM0ZCH3XOTOG4%2bD1s%3d"
$headers = @{"From"="user@contoso.com";"Date"="05/28/2015 15:47:00"}

$vms  = @(
            @{ Name="vm01";ServiceName="vm01"},
            @{ Name="vm02";ServiceName="vm02"}
        )
$body = ConvertTo-Json -InputObject $vms

$response = Invoke-RestMethod -Method Post -Uri $uri -Headers $headers -Body $body
$jobid = $response.JobIds

Write-Output -InputObject "The job ran with ID '$jobid'"
