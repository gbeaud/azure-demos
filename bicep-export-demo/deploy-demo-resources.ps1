<#
.SYNOPSIS
    Deploys a set of low-cost Azure resources "by hand" (imperative az CLI, no IaC)
    so they can later be exported and taken under Bicep management.

.EXAMPLE
    ./deploy-demo-resources.ps1 -SubscriptionName sub-general-demos-swec-01
#>
param(
    [string]$SubscriptionName = "sub-general-demos-swec-01",
    [string]$ResourceGroupName = "rg-bicep-export-demo-swec-01",
    [string]$Location = "swedencentral"
)

$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

az account set --subscription $SubscriptionName
$subscriptionId = az account show --query id -o tsv

# Deterministic suffix so the script can be re-run idempotently
$md5 = [System.Security.Cryptography.MD5]::Create()
$hash = $md5.ComputeHash([Text.Encoding]::UTF8.GetBytes("$subscriptionId/$ResourceGroupName"))
$suffix = (-join ($hash | ForEach-Object { $_.ToString("x2") })).Substring(0, 6)

$tags = @("environment=demo", "purpose=bicep-export-demo", "managedBy=manual")

$stName   = "stbicepdemo$suffix"
$vnetName = "vnet-bicepdemo-swec-01"
$nsgName  = "nsg-bicepdemo-app-swec-01"
$kvName   = "kv-bicepdemo-$suffix"
$idName   = "id-bicepdemo-swec-01"
$aspName  = "asp-bicepdemo-swec-01"
$appName  = "app-bicepdemo-$suffix"

Write-Host "Resource group..." -ForegroundColor Cyan
az group create -n $ResourceGroupName -l $Location --tags $tags -o none

Write-Host "Storage account + blob container..." -ForegroundColor Cyan
az storage account create -g $ResourceGroupName -n $stName -l $Location `
    --sku Standard_LRS --kind StorageV2 --access-tier Hot `
    --min-tls-version TLS1_2 --allow-blob-public-access false --https-only true `
    --tags $tags -o none
$stId = az storage account show -g $ResourceGroupName -n $stName --query id -o tsv
az storage container-rm create --storage-account $stName -g $ResourceGroupName -n "data" -o none

Write-Host "NSG + virtual network..." -ForegroundColor Cyan
az network nsg create -g $ResourceGroupName -n $nsgName -l $Location --tags $tags -o none
az network nsg rule create -g $ResourceGroupName --nsg-name $nsgName -n "Allow-HTTPS-Inbound" `
    --priority 100 --direction Inbound --access Allow --protocol Tcp `
    --source-address-prefixes Internet --destination-port-ranges 443 -o none
az network vnet create -g $ResourceGroupName -n $vnetName -l $Location `
    --address-prefixes 10.50.0.0/16 --tags $tags -o none
az network vnet subnet create -g $ResourceGroupName --vnet-name $vnetName -n "snet-app" `
    --address-prefixes 10.50.1.0/24 --network-security-group $nsgName -o none
az network vnet subnet create -g $ResourceGroupName --vnet-name $vnetName -n "snet-data" `
    --address-prefixes 10.50.2.0/24 --service-endpoints Microsoft.Storage -o none

Write-Host "User-assigned managed identity..." -ForegroundColor Cyan
az identity create -g $ResourceGroupName -n $idName -l $Location --tags $tags -o none
$idPrincipalId = az identity show -g $ResourceGroupName -n $idName --query principalId -o tsv
$idResourceId  = az identity show -g $ResourceGroupName -n $idName --query id -o tsv

Write-Host "Key Vault (RBAC)..." -ForegroundColor Cyan
$kvExists = az keyvault list -g $ResourceGroupName --query "[?name=='$kvName'] | length(@)" -o tsv
if ($kvExists -eq "0") {
    az keyvault create -g $ResourceGroupName -n $kvName -l $Location --sku standard `
        --enable-rbac-authorization true --retention-days 7 --tags $tags -o none
}
$kvId = az keyvault show -g $ResourceGroupName -n $kvName --query id -o tsv

Write-Host "App Service plan (F1 Free) + web app..." -ForegroundColor Cyan
az appservice plan create -g $ResourceGroupName -n $aspName -l $Location --sku F1 --is-linux --tags $tags -o none
az webapp create -g $ResourceGroupName -p $aspName -n $appName --runtime "NODE:24-lts" --tags $tags -o none
az webapp update -g $ResourceGroupName -n $appName --https-only true -o none
az webapp identity assign -g $ResourceGroupName -n $appName --identities $idResourceId -o none
az webapp config appsettings set -g $ResourceGroupName -n $appName -o none `
    --settings "STORAGE_ACCOUNT_NAME=$stName" "KEY_VAULT_URI=https://$kvName.vault.azure.net/"

Write-Host "Role assignments for the managed identity..." -ForegroundColor Cyan
az role assignment create --assignee-object-id $idPrincipalId --assignee-principal-type ServicePrincipal `
    --role "Storage Blob Data Reader" --scope $stId -o none
az role assignment create --assignee-object-id $idPrincipalId --assignee-principal-type ServicePrincipal `
    --role "Key Vault Secrets User" --scope $kvId -o none

Write-Host "`nDone. Resources in $ResourceGroupName :" -ForegroundColor Green
az resource list -g $ResourceGroupName --query "[].{name:name, type:type}" -o table
