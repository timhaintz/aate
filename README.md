# aate - Azure Automated Test Environment

## INTRODUCTION

This Open Source Project is designed to create an automatically built Active Directory domain and
Certificate Authority in Azure Resource Manager.
This is intended to be used to create a green fields environment. Once testing is completed,
`Remove-AzureRMResourceGroup` should be used to delete the entire environment and start fresh.

**Please note, the default username and password are weak. They can be changed if required.**

## PRE EXECUTION

1. [Install AzureRM modules](https://docs.microsoft.com/en-us/powershell/azure/install-azurerm-ps?view=azurermps-5.0.0)
2. Create a [Free Azure Account](https://azure.microsoft.com/en-au/free/)
3. Once account is setup, open a PowerShell window as Administrator
4. If you want to pre-login, run Login-AzureRMAccount and follow the login prompts.
5. If you want a domain other than timhaintz.com, change the $dscDomainName from timhaintz.com.
    1. Please don't use a publicly registered domain. DNS can get confused.
    2. *Please only use a .com extension. .com.au or .net for example are not supported*

## EXECUTION

1. Clone the repository from git
![Git Clone](/assets/gitClone.png)
2. From the administrative PowerShell window, change to a local directory
you want to save the repository to and then clone the remote repository.
```powershell
git clone https://github.com/timhaintz/aate.git
```
3. Change Directory into the newly created repository and then Change Directory
again into the AzureRM directory.
4. Run the script
    1. .\1-Create-aate.ps1
5. Username and password if you have to login to dc1 before DSC has applied:
    1. UserName: localhost\azureadmin
    2. Password: Azure12345678
6. Browse the web interface:
    1. [Portal](https://portal.azure.com)
        1. All resources
        2. Choose the correct subscription
7. You can observe the environment being built.
![All resources](/assets/allResources.png)

## POST EXECUTION

1. Username and password to login to the server once DSC has applied:
    1. UserName: DomainNameChosen\azureadmin
        1. Default is: timhaintz\azureadmin
    2. Password: Azure12345678

## REMOVE ENVIRONMENT

1. `Remove-AzureRMResourceGroup -Name $resourceGroupName` should be used to delete the entire environment and start fresh.
    1. *Deletion takes about 5 - 10 minutes*
2. Login to [Portal](https://portal.azure.com)
    1. Resource groups
    2. TestRG01
3. Watch the Resource Group delete the objects

## URLs used to build initial environment

* https://blogs.msdn.microsoft.com/azuredev/2017/02/11/iac-on-azure-an-introduction-of-infrastructure-as-code-iac-with-azure-resource-manager-arm-template/
* https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-authoring-templates
* https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-manager-create-first-template
* https://blogs.msdn.microsoft.com/azuredev/2017/02/25/iac-on-azure-windows-server-virtual-machine-deployment-made-easy-with-arm-template/
* https://azure.microsoft.com/en-gb/regions/services/
* https://docs.microsoft.com/en-gb/azure/virtual-machines/windows/sizes
* https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-manager-template-best-practices
* https://azurestack.blog/2015/06/azure-resource-manager-templates-json/
* https://blogs.technet.microsoft.com/paulomarques/2016/05/27/safeguarding-your-passwords-when-deploying-azure-virtual-machines-with-azure-powershell-module-and-arm-templates-by-using-azure-key-vault/
* https://stackoverflow.com/questions/28105095/how-to-detect-if-azure-powershell-session-has-expired
* https://docs.microsoft.com/en-us/powershell/module/azurerm.resources/get-azurermlocation?view=azurermps-4.4.1
* https://docs.microsoft.com/en-us/powershell/module/azurerm.automation/new-azurermautomationaccount?view=azurermps-4.4.1
* https://technet.microsoft.com/en-us/library/gg675931.aspx
* https://docs.microsoft.com/en-us/azure/virtual-machines/windows/cli-ps-findimage
* https://github.com/Azure/azure-quickstart-templates/tree/master/201-vm-copy-index-loops
* https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-multiple-ip-addresses-template
* https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-vm-multiple-ipconfig/azuredeploy.json
* https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/disksent
* https://azure.microsoft.com/en-us/resources/templates/101-vm-customdata/
* https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-template-deploy
* https://docs.microsoft.com/en-us/azure/automation/automation-dsc-onboarding
* https://docs.microsoft.com/en-us/powershell/dsc/azuredsc
* https://docs.microsoft.com/en-gb/azure/virtual-machines/windows/extensions-dsc-overview
* https://docs.microsoft.com/en-gb/azure/automation/automation-dsc-overview
* https://docs.microsoft.com/en-us/azure/automation/automation-credentials
* https://azure.microsoft.com/en-us/blog/authoring-integration-modules-for-azure-automation/
* https://docs.microsoft.com/en-us/azure/automation/automation-integration-modules
* https://powershell.org/2017/07/25/using-powershell-azure-automation-and-oms-part-i/
* https://blogs.msdn.microsoft.com/powershell/2014/04/25/understanding-import-dscresource-keyword-in-desired-state-configuration/
* https://github.com/Azure/azure-powershell/issues/4369
* https://docs.microsoft.com/en-us/azure/automation/automation-credentials
* https://docs.microsoft.com/en-us/azure/automation/automation-variables
* https://ramblingcookiemonster.wordpress.com/2014/12/01/powershell-splatting-build-parameters-dynamically/
* https://docs.microsoft.com/en-us/azure/automation/tutorial-configure-servers-desired-state
* https://docs.microsoft.com/en-gb/powershell/module/azurerm.automation/register-azurermautomationdscnode?view=azurermps-5.0.0&viewFallbackFrom=azurermps-4.3.1
* https://docs.microsoft.com/en-us/azure/virtual-machines/windows/using-managed-disks-template-deployments
* https://docs.microsoft.com/en-us/azure/virtual-machines/windows/attach-disk-ps
* https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/virtualmachines
* https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/virtualmachines#DataDisk
* https://stackoverflow.com/questions/39964455/how-to-change-cd-rom-letter
* https://github.com/PowerShell/xNetworking/wiki/xDNSServerAddress
* https://powershell.org/forums/topic/how-do-you-use-dsc-to-declaratively-change-the-drive-letter-of-the-cdrom/
* https://blogs.msdn.microsoft.com/timomta/2016/04/23/how-to-use-powershell-dsc-to-prepare-a-data-drive-on-an-azure-vm/
* https://github.com/PowerShell/xStorage
* https://www.powershellgallery.com/packages/cCDROMdriveletter/1.2.0
* https://github.com/PowerShell/StorageDsc/issues/140
* https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-template-functions-string#uniquestring
* https://social.msdn.microsoft.com/Forums/en-US/a60f83ee-c1a6-4ff0-931d-6dafb84c30ef/appending-resource-name-with-random-number-in-arm-teamplates?forum=WAVirtualMachinesforWindows