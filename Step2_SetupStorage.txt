$rgname='AzPSFunctionSAS-rg'
$location='westeurope'
$storageaccountname='storagesas001'
$azurefunctionappname='azpsfuncapp01'
$containername='containersas01'
$subscription= az account show --query id -o tsv


# create storage Account
az storage account create `
    --name $storageaccountname `
    --resource-group $rgname `
    --location $location `
    --sku Standard_ZRS `
    --encryption-services blob

# get current signed in user and grant it storage blob contributor role
# might need to double check the min permissions needed to generate a SAS token
$signedInuserObjectId= az ad signed-in-user show --query objectId -o tsv
az role assignment create `
    --role "Storage Blob Data Contributor" `
    --assignee $signedInuserObjectId `
    --scope "/subscriptions/$subscription/resourceGroups/$rgname/providers/Microsoft.Storage/storageAccounts/$storageaccountname"

# create a container in the storage account
az storage container create `
    --account-name $storageaccountname `
    --name $containername `
    --auth-mode login

# upload sample file
az storage blob upload `
    --account-name $storageaccountname `
    --container-name $containername `
    --name helloworld `
    --file helloworld `
    --auth-mode login

