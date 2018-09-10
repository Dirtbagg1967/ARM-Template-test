### Define Deployment Variables
{
$location = 'West US'
$resourceGroupName = 'contoso-iaas'
$resourceDeploymentName = 'contoso-iaas-deployment'
$templatePath = $env:SystemDrive + '\' + 'Github\pluralsightjBannan\microsoft-azure-resource-manager-mastering'
$templatefile = 'Contosoiaas.json'
$template = $templatePath + '\' + $templateFile
$templatefile2 = 'Contosoiaas-sol.json'
$template2 = $templatePath + '\' + $templateFile2
$password = "P@ssword4Dave"
$securepassword = $password | ConvertTo-SecureString -AsPlainText -Force
}

### Create Resource Group
{
New-AzureRmResourceGroup `
    -Name $resourceGroupName `
    -Location $location `
    -Verbose -Force
}

### Deploy Resources
{

$additionalParameters = New-Object -TypeName Hashtable 
$additionalParameters['vmPrivateAdminPassword'] = $securepassword

New-AzureRmResourceGroupDeployment `
    -Name $resourceDeploymentName `
    -ResourceGroupName $resourceGroupName `
    -TemplateFile $template `
    @additionalParameters `
    -Verbose -Force
}

test-AzureRmResourceGroupDeployment `
   -ResourceGroupName $resourceGroupName `
   -TemplateFile $template | tee -var ops

Get-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -Name $resourceDeploymentName | tee -var ops


foreach($operation in $ops)

{
    Write-Host $operation.id
    Write-Host "Request:"
    $operation.Properties.Request | ConvertTo-Json -Depth 10
    Write-Host "Response:"
    $operation.Properties.Response | ConvertTo-Json -Depth 10
}