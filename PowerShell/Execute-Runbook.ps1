$uri = "https://s3events.azure-automation.net/webhooks?token=rDt4ODcsFSgtoT6xtK9Bnq%2bgtkFXTD8CD9gFRVU5Rqw%3d"
$headers = @{"From"="brian.farnhill@contoso.com";"Date"=[DateTime]::Now.ToString("MM/dd/yyyy hh:mm:ss")}

$details  = @{
    alias = "jeffh"
    license = "MOD272526:ENTERPRISEPREMIUM"
}
$body = ConvertTo-Json -InputObject $details

$response = Invoke-RestMethod -Method Post -Uri $uri -Headers $headers -Body $body
$jobid = $response.JobIds

Write-Output -InputObject "The job ran with ID '$jobid'"
