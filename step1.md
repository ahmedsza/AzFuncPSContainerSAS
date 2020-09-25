## Prereqs
#### ### **=== PREREQ, Assumes windows ==== ******

*1.  Install Azure Function v3*
https://go.microsoft.com/fwlink/?linkid=2135274

Details at https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local

*2. Make sure you have Azure CLI installed *
https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?view=azure-cli-latest

More info at https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest

*3. Install .NET Core SDK 3.1*
https://www.microsoft.com/net/download

#### Verify -  command prompt/powershell 

1) Az version check 
`az --version `
needs to be 2.0.76 or hiher

2) check azure function version
`func --version `
 2.7.1846 or later


## Create the function project

### Init the function
`func init AzFuncSAS --powershell
cd .\AzFuncSAS\`

### add the function the project
`func new --name HttpSASDemo --template "HTTP trigger"`

### test it 
`func start`

browse to http://localhost:7071/api/HttpSASDemo
or with paramaters - http://localhost:7071/api/HttpSASDemo?name=hello


## Deploy to Azure

login to Azure with Azrure CLI
`az login`

#### setup variables. Change names appropriately 

```
$rgname='AzPSFunctionSAS-rg'
$location='westeurope'
$storageaccountname='azfnstorage003'
$azurefunctionappname='azpsfuncapp01'
```




#### create the resource group
`az group create --name $rgname --location $location`

#### create the Azure Storage account for the Azure function (not for SAS token)
`az storage account create --name $storageaccountname --location $location --resource-group $rgname --sku Standard_LRS`

#### create the Azure Function App 
`az functionapp create --resource-group $rgname --consumption-plan-location $location --runtime powershell --functions-version 3 --name $azurefunctionappname --storage-account $storageaccountname`

#### deploy the function 
`func azure functionapp publish $azurefunctionappname`
make note of the URL with the key included 

## Test It


#### Test it (with URL from above) eg 
https://azpsfuncapp01.azurewebsites.net/api/httpsasdemo?code=AZIJU7SWA450emQynqosxp4CmzZexqZ5e7hAmxWx6ZVwVG0HZkAwOQ==

#### Check appinsights output

```bash
`$azurefunctionappname='azpsfuncapp01'
func azure functionapp logstream $azurefunctionappname --browser
````
