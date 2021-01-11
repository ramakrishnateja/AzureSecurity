#az login
$resourceGroupName = 'udacity'
$location = 'eastus'
$aksSPNName = 'AKS-SPN'
$subscriptionID = 'ab1a7875-684c-4793-a814-bbc20aa6a0e2'
az account set --subscription $subscriptionID
az group create --name $resourceGroupName --location $location

$aksSpnClientId = ""
$aksSpnClientSecret = ""
$aksSPN = az ad sp list --display-name $aksSPNName -o json | ConvertFrom-Json
Write-Host $aksSPN
if ($aksSPN) {
    Write-Host 'AKS-SPN exists resetting credentials'
    $aksSpnOutput = az ad sp credential reset --name $aksSPNName --password rbac --query '{ClientId:appId,ClientSecret:password}' -o json | ConvertFrom-Json
    $aksSpnClientId =$aksSpnOutput.ClientId
    $aksSpnClientSecret = $aksSpnOutput.ClientSecret
} else {
    Write-Host 'AKS-SPN does not exist creating one'
    $aksSpnOutput = az ad sp create-for-rbac --name $aksSPNName `
                            --role Contributor `
                            --scopes /subscriptions/$subscriptionID/resourceGroups/$resourceGroupName `
                            --query '{ClientId:appId,ClientSecret:password}' -o json | ConvertFrom-Json
    $aksSpnClientId =$aksSpnOutput.ClientId
    $aksSpnClientSecret = $aksSpnOutput.ClientSecret
}

az deployment group create --resource-group $resourceGroupName --template-file ./before/azuredeploy.json `
                           --parameters aksSpnClientId=$aksSpnClientId `
                           --parameters aksSpnClientSecret=$aksSpnClientSecret


