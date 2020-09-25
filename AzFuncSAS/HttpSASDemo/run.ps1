using namespace System.Net



# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)
        $StorageAccountName = "storagesas001"
        $ResourceGroupName = "AzPSFunctionSAS-rg"
        $LocationName = 'westeurope'
        $StorageContainerName = 'containersas01'
        $PolicyName = "saspolicydemo"

        Write-Host $ResourceGroupName
        Write-Host $StorageAccountName



        $AccountKeys = Get-AzStorageAccountKey -ResourceGroupName $ResourceGroupName -Name $StorageAccountName
        Write-Host $AccountKeys



        $URL = "https://$StorageAccountName.blob.core.windows.net/$StorageContainerName"
        $StorageContext = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $($AccountKeys[0].Value)

        $StoredAccessPolicy = $(Get-AzStorageContainerStoredAccessPolicy -Context $StorageContext -Container $StorageContainerName -Policy $PolicyName)
        If(!$StoredAccessPolicy){
        $StoredAccessPolicy = New-AzStorageContainerStoredAccessPolicy -Context $StorageContext -Container $StorageContainerName -Permission "rdwl" -ExpiryTime $(Get-Date).AddYears(10) -Policy $PolicyName
        }
        $ContainerSASTokenWithPolicy = New-AzStorageContainerSASToken -Context $StorageContext -Container $StorageContainerName -Policy $PolicyName -FullUri ;
        Write-Host $ContainerSASTokenWithPolicy
        Write-Host $URL$ContainerSASTokenWithPolicy
        $returnresult="$ContainerSASTokenWithPolicy&comp=list&restype=container"

        Write-Host $returnresult



        Get-AzStorageContainerStoredAccessPolicy -Container $StorageContainerName -Context $StorageContext

















############### old
# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
#$name = $Request.Query.Name
##if (-not $name) {
 #   $name = $Request.Body.Name
#}

#$body = "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response."

#if ($name) {
#    $body = "Hello, $name. This HTTP triggered function executed successfully."
#}

$body=$returnresult
$body="test"
# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
