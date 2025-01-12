## this is Azurecli script
az group create --location australiaeast --name $(terraformrg)

az storage account create --name $(terraformstorageaccount) --resource-group $(terraformrg) --location australiaeast --sku Standard_LRS

az storage container create --name terraformstate --account-name $(terraformstorageaccount)

az storage account keys list -g $(terraformrg) -n $(terraformstorageaccount)

## this is Azure PowerShell script: InlineScript task script
# You can write your azure powershell scripts inline here. 
# You can also pass predefined and custom variables to this script using arguments

$key = (Get-AzStorageAccountKey -ResourceGroupName $(terraformrg) -AccountName $(terraformstorageaccount))[0].Value

Write-Host "##vso[task.setvariable variable=storagekey]$key"