<#
    Created by  : Tim Haintz
    Date Created: 4/09/2017

    Description : Create Azure RM Resource Group and deploy .json template file to create Azure environment.
                  This is intended to be used to create a green fields environment. Once testing is completed,
                  Remove-AzureRMResourceGroup should be used to delete the entire environment and start fresh.

    URLs used   :
    https://blogs.msdn.microsoft.com/azuredev/2017/02/11/iac-on-azure-an-introduction-of-infrastructure-as-code-iac-with-azure-resource-manager-arm-template/
    https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-authoring-templates
    https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-manager-create-first-template
    https://blogs.msdn.microsoft.com/azuredev/2017/02/25/iac-on-azure-windows-server-virtual-machine-deployment-made-easy-with-arm-template/
    https://azure.microsoft.com/en-gb/regions/services/
    https://docs.microsoft.com/en-gb/azure/virtual-machines/windows/sizes
    https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-manager-template-best-practices
    https://azurestack.blog/2015/06/azure-resource-manager-templates-json/
    https://blogs.technet.microsoft.com/paulomarques/2016/05/27/safeguarding-your-passwords-when-deploying-azure-virtual-machines-with-azure-powershell-module-and-arm-templates-by-using-azure-key-vault/
    https://stackoverflow.com/questions/28105095/how-to-detect-if-azure-powershell-session-has-expired
    https://docs.microsoft.com/en-us/powershell/module/azurerm.resources/get-azurermlocation?view=azurermps-4.4.1
    https://docs.microsoft.com/en-us/powershell/module/azurerm.automation/new-azurermautomationaccount?view=azurermps-4.4.1
    https://technet.microsoft.com/en-us/library/gg675931.aspx
    https://docs.microsoft.com/en-us/azure/virtual-machines/windows/cli-ps-findimage
    https://github.com/Azure/azure-quickstart-templates/tree/master/201-vm-copy-index-loops
    https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-multiple-ip-addresses-template
    https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-vm-multiple-ipconfig/azuredeploy.json
    https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/disksent
    https://azure.microsoft.com/en-us/resources/templates/101-vm-customdata/
    https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-template-deploy
    https://docs.microsoft.com/en-us/azure/automation/automation-dsc-onboarding
    https://docs.microsoft.com/en-us/powershell/dsc/azuredsc
    https://docs.microsoft.com/en-gb/azure/virtual-machines/windows/extensions-dsc-overview
    https://docs.microsoft.com/en-gb/azure/automation/automation-dsc-overview
    https://docs.microsoft.com/en-us/azure/automation/automation-credentials
    https://azure.microsoft.com/en-us/blog/authoring-integration-modules-for-azure-automation/
    https://docs.microsoft.com/en-us/azure/automation/automation-integration-modules
    https://powershell.org/2017/07/25/using-powershell-azure-automation-and-oms-part-i/
    https://blogs.msdn.microsoft.com/powershell/2014/04/25/understanding-import-dscresource-keyword-in-desired-state-configuration/
    https://github.com/Azure/azure-powershell/issues/4369
    https://docs.microsoft.com/en-us/azure/automation/automation-credentials
    https://docs.microsoft.com/en-us/azure/automation/automation-variables
    https://ramblingcookiemonster.wordpress.com/2014/12/01/powershell-splatting-build-parameters-dynamically/
    https://docs.microsoft.com/en-us/azure/automation/tutorial-configure-servers-desired-state
    https://docs.microsoft.com/en-gb/powershell/module/azurerm.automation/register-azurermautomationdscnode?view=azurermps-5.0.0&viewFallbackFrom=azurermps-4.3.1
    https://docs.microsoft.com/en-us/azure/virtual-machines/windows/using-managed-disks-template-deployments
    https://docs.microsoft.com/en-us/azure/virtual-machines/windows/attach-disk-ps
    https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/virtualmachines
    https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/virtualmachines#DataDisk
    https://stackoverflow.com/questions/39964455/how-to-change-cd-rom-letter
    https://github.com/PowerShell/xNetworking/wiki/xDNSServerAddress
    https://powershell.org/forums/topic/how-do-you-use-dsc-to-declaratively-change-the-drive-letter-of-the-cdrom/
    https://blogs.msdn.microsoft.com/timomta/2016/04/23/how-to-use-powershell-dsc-to-prepare-a-data-drive-on-an-azure-vm/
    https://github.com/PowerShell/xStorage
    https://www.powershellgallery.com/packages/cCDROMdriveletter/1.2.0
    https://github.com/PowerShell/StorageDsc/issues/140
    https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-template-functions-string#uniquestring
    https://social.msdn.microsoft.com/Forums/en-US/a60f83ee-c1a6-4ff0-931d-6dafb84c30ef/appending-resource-name-with-random-number-in-arm-teamplates?forum=WAVirtualMachinesforWindows

    Pre execution :
    1. How to get AzureRM modules installed: https://docs.microsoft.com/en-us/powershell/azure/install-azurerm-ps?view=azurermps-5.0.0
    2. Create free Azure account: https://azure.microsoft.com/en-au/free/
    3. Once account is setup, open PowerShell window as Administrator
    4. Run Login-AzureRMAccount and follow the login prompts
    5. Run Get-AzureRMContext to get the top three variables information
        a. The Name return value has $azureRMAcctName and $subscriptionID information
        b. The TenantID return value has $tenantID information
    6. If you want a domain other than timhaintz.com, change the $dscDomainName from timhaintz.com.
        a. Please don't use a publicly registered domain. DNS can get confused.
       ***Please only use a .com extension. .com.au or .net for example are not supported***
    7. Run the script
        a. .\1-Create-aate.ps1
    8. Username and password when you have to login to dc1 before DSC has applied:
        a. UserName: localhost\azureadmin
        b. Password: Azure12345678
    9. After setting up the E drive. Please wait 5 minutes. There is no feedback from AzureRM into the PowerShell window.
       It looks like it isn't doing anything. It is setting up the Domain Controller communication to the AzureRM Pull server.
       If you browse the web interface:
        a. https://portal.azure.com
        b. Automation Accounts
        c. TestAutomationAcct
        d. DSC nodes
       You will see that it is running the DSC configuration on the server
    Post execution
    10. Username and password to login to the server once DSC has applied:
        a. UserName: DomainNameChosen\azureadmin
            i. Default is: timhaintz\azureadmin
        b. Password: Azure12345678
    11. Remove-AzureRMResourceGroup -Name $resourceGroupName should be used to delete the entire environment and start fresh.
        *** Deletion takes about 5 - 10 minutes ***
#>

#Enter username and password to connect to AzureRM. Can also use Add-AzureRmAccount. If not logged in, prompt for login
try
{
    $azureRMContext = Get-AzureRmContext -ErrorAction Stop
    if($azureRMContext.Account.id)
    {
        Write-Output "Already logged in"
    }
}
catch
{
    if ($_ -like "*Login-AzureRmAccount to login*")
    {
        Login-AzureRmAccount
    }
}

##################Setup variables and splatting paramaters##################
$resourceGroupName = 'TestRG01'
$location = 'southeastasia' #Using this location as australiasoutheast isn't supported for VM creation
$automationAccountName = 'TestAutomationAcct'
$automationAccountPlan = 'Basic'
$storageName = 'st' + (Get-Random)
$storageSKU = 'Standard_LRS'
$storageKind = 'Storage'
$storageContainer = 'templates'
$storagePermission = 'Container'
$createVMJSON = "$PSScriptRoot\ARMTemplate.json"
$createVMJSONleaf = $createVMJSON | Split-Path -Leaf
$createVMparamatersJSON = "$PSScriptRoot\parameters.json"
$createVMparamatersJSONleaf = $createVMparamatersJSON | Split-Path -Leaf
$dscDomainName = 'timhaintz.com'
$dscDomainNameNB = $dscDomainName.TrimEnd('.com')
$dscDomainUser = "$dscDomainNameNB\azureadmin"
$dscSafemodeUser = 'administrator'
$dscPw = ConvertTo-SecureString "Azure12345678" -AsPlainText -Force
$dscDomainCred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $dscDomainUser, $dscPw
$dscSafemodeCred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $dscSafemodeUser, $dscPw
$automationDomainName = 'domainName'
$automationDomainNameNB = 'domainNameNB'
$automationCredDomain = 'domainCred'
$automationCredSafeMode = 'safemodeCred'
#DSC Module names must be in lowercase to search and download them correctly
$dscModulesToImport = 'xactivedirectory', `
                      'xnetworking', `
                      'xdnsserver', `
                      'xadcsdeployment', `
                      'xcomputermanagement', `
                      'storagedsc'
$dscConfigNameDC = "$PSScriptRoot\BuildFirstDC.ps1"
$buildFirstDC = 'BuildFirstDC'
$dscConfigNameCA = "$PSScriptRoot\BuildFirstCA.ps1"
$buildFirstCA = 'BuildFirstCA'
$dscConfigData = # Configuration Data for AD - https://msdn.microsoft.com/en-us/powershell/dsc/configdata
@{
    AllNodes = @(
        @{
            NodeName = "*"
            PSDscAllowPlainTextPassword = $True
        },
        @{
            Nodename = "dc1"
            Role = "Primary DC"
            DomainName = $dscDomainName
            RetryCount = 20
            RetryIntervalSec = 30
            PSDscAllowDomainUser = $true
        },
        @{
            Nodename = "dc2"
            Role = "Replica DC"
            DomainName = $dscDomainName
            RetryCount = 20
            RetryIntervalSec = 30
        },
        @{
            Nodename = "ca1"
            Role = "Enterprise Root Certificate Authority"
            DomainName = $dscDomainName
            RetryCount = 20
            RetryIntervalSec = 30
            PSDscAllowDomainUser = $true
        }
    )
}

#Splatting section
$azureRMRGParams = @{'Name'=$resourceGroupName;
                     'Location'=$location
                    }

$azureRMRGAutoAcct = @{'ResourceGroupName'=$resourceGroupName;
                       'AutomationAccountName'=$automationAccountName
                      }

$newAzureRMAutoAcctParams = @{'Name'=$automationAccountName;
                              'ResourceGroupName'=$resourceGroupName;
                              'Location'=$location;
                              'Plan'=$automationAccountPlan
                             }

$newAzureRMStorageAcctParams = @{'ResourceGroupName'=$resourceGroupName;
                                 'AccountName'=$storageName;
                                 'Location'=$Location;
                                 'SkuName'=$storageSKU;
                                 'Kind'=$storageKind
                                }

$newAzureRMStorageContainer = @{'Name'=$storageContainer;
                                'Permission'=$storagePermission
                               }

$newAzureRMAutomationVariableDomName = @{'ResourceGroupName'=$resourceGroupName;
                                         'AutomationAccountName'=$automationAccountName;
                                         'Name'=$automationDomainName;
                                         'Value'=$dscDomainName;
                                         'Encrypted'=$False
                                        }

$newAzureRMAutomationVariableDomNameNB = @{'ResourceGroupName'=$resourceGroupName;
                                           'AutomationAccountName'=$automationAccountName;
                                           'Name'=$automationDomainNameNB;
                                           'Value'=$dscDomainNameNB;
                                           'Encrypted'=$False
                                          }

$newAzureRMAutomationCredDomain = @{'ResourceGroupName'=$resourceGroupName;
                                    'AutomationAccountName'=$automationAccountName;
                                    'Name'=$automationCredDomain;
                                    'Value'=$dscDomainCred
                                   }

$newAzureRMAutomationCredSafeMode = @{'ResourceGroupName'=$resourceGroupName;
                                      'AutomationAccountName'=$automationAccountName;
                                      'Name'=$automationCredSafeMode;
                                      'Value'=$dscSafemodeCred
                                     }

$importAzureRMDSCConfigDC = @{'ResourceGroupName'=$resourceGroupName;
                              'AutomationAccountName'=$automationAccountName;
                              'SourcePath'=$dscConfigNameDC
                             }

$importAzureRMDSCConfigCA = @{'ResourceGroupName'=$resourceGroupName;
                              'AutomationAccountName'=$automationAccountName;
                              'SourcePath'=$dscConfigNameCA
                             }

$startAzureRMDSCConfigDC = @{'ResourceGroupName'=$resourceGroupName;
                             'AutomationAccountName'=$automationAccountName;
                             'ConfigurationName'=$buildFirstDC;
                             'ConfigurationData'=$dscConfigData
                            }

$startAzureRMDSCConfigCA = @{'ResourceGroupName'=$resourceGroupName;
                             'AutomationAccountName'=$automationAccountName;
                             'ConfigurationName'=$buildFirstCA;
                             'ConfigurationData'=$dscConfigData
                            }
#END Splatting section

##################END Setup variables and splatting paramaters##################

#Create a new resource group as per name if it doesn't already exist
try
{
    Get-AzureRmResourceGroup -Name $ResourceGroupName -ErrorAction Stop
}
catch
{
    if ($_ -like "*Login-AzureRmAccount to login*")
    {
        Login-AzureRmAccount
        New-AzureRmResourceGroup @AzureRMRGParams
    }
    else
    {
        New-AzureRmResourceGroup @AzureRMRGParams
    }

}

#Create new AzureRMAutomationAccount if it doesn't already exist.
#Try/catch didn't work as Get-AzureRmAutomationAccount doesn't error if it doesn't exist.
#Using if statement instead
$checkAzureAutomationAcct = Get-AzureRmAutomationAccount -ResourceGroupName $resourceGroupName
if ($checkAzureAutomationAcct.AutomationAccountName -ne $automationAccountName)
{
    New-AzureRmAutomationAccount @NewAzureRMAutoAcctParams
}

#The below sections create the storage account and upload the JSON files to there.
#As Get-Random is used for a variable, I'm not checking to see
#if storage already exists as it is random.
New-AzureRmStorageAccount @NewAzureRMStorageAcctParams
$storageAccountKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $resourceGroupName -Name $storageName).Value[0]
$storageContext = New-AzureStorageContext -StorageAccountName $storageName -StorageAccountKey $storageAccountKey
New-AzureStorageContainer @NewAzureRMStorageContainer -Context $storageContext

Set-AzureStorageBlobContent -File $createVMJSON -Context $storageContext -Container $storageContainer
Set-AzureStorageBlobContent -File $createVMparamatersJSON -Context $storageContext -Container $storageContainer

$templatePath = "https://" + $storageName + ".blob.core.windows.net/templates/$createVMJSONleaf"
$parametersPath = "https://" + $storageName + ".blob.core.windows.net/templates/$createVMparamatersJSONleaf"
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -Name "$resourceGroupName`VMs" -TemplateUri $templatePath -TemplateParameterUri $parametersPath

#Need to have the module in Azure Automation for Import-DscResource in the DSC files.
#This part is a bit clunky. Speaking with Microsoft about a PowerShell module to import directly from powershellgallery.com.
#Microsoft were a great help. Gave me the -ContentLink option
#https://feedback.azure.com/forums/246290-automation/suggestions/32470921-equivalent-of-import-dscresource-directly-from-pow

#Download the DSC modules via ContentLink rather than ZIPing and then uploading.
#Thanks Stanley from Microsoft for the ContentLink option
foreach ($dscModuleToImport in $dscModulesToImport)
{
    $dscModule = $null
    $dscModule = Find-Module -Name $dscModuleToImport -Repository PSGallery
    $dscModuleVersion = "$($dscModule.Version.major).$($dscModule.Version.Minor).$($dscModule.Version.Build)"
    New-AzureRmAutomationModule @azureRMRGAutoAcct -Name $dscModuleToImport -ContentLink "https://devopsgallerystorage.blob.core.windows.net/packages/$dscModuleToImport.$dscModuleVersion.nupkg"
}


#Before compiling DSC, Azure Automation credential assests are required
New-AzureRmAutomationVariable @newAzureRMAutomationVariableDomName
New-AzureRmAutomationVariable @newAzureRMAutomationVariableDomNameNB
New-AzureRmAutomationCredential @newAzureRMAutomationCredDomain
New-AzureRmAutomationCredential @newAzureRMAutomationCredSafeMode

#Import the DC and CA config from the .ps1 files
Import-AzureRmAutomationDscConfiguration @importAzureRMDSCConfigDC -Published -Force
Import-AzureRmAutomationDscConfiguration @importAzureRMDSCConfigCA -Published -Force

#Wait for all modules to be successfully imported before trying to compile them.
foreach ($dscModuleToImport in $dscModulesToImport)
{
    $dscImportStatus = $null
    $dscImportStatus = Get-AzureRmAutomationModule @azureRMRGAutoAcct -Name $dscModuleToImport
    While ($dscImportStatus.ProvisioningState -ne 'Succeeded')
    {
        Start-Sleep -sec 30
        Write-Warning "DSC Module $dscModuleToImport did not import successfully within 30 seconds. Will check again in 30 seconds."
        $dscImportStatus = Get-AzureRmAutomationModule @azureRMRGAutoAcct -Name $dscModuleToImport
    }
    Write-Verbose "DSC Module $dscModuleToImport imported successfully."
}

#Compile AzureRM Automation DSC files to convert the to .MOF files
Start-AzureRmAutomationDscCompilationJob @startAzureRMDSCConfigDC
Start-AzureRmAutomationDscCompilationJob @startAzureRMDSCConfigCA

##########################################################################################################################################################
<#Currently trying to work out how to automate the setup of E drive for an AzureRM VM.
The below is resolved here: https://github.com/PowerShell/StorageDsc/issues/140
Leaving the below in as it is nice to see how we have automated further.
Log on locally to the box and run the below commands to resolve this manually for the moment.
#This changes the CD drive from E to Z
powershell
Get-WmiObject -Class Win32_volume -Filter "DriveLetter = 'E:'" | Set-WmiInstance -Arguments @{DriveLetter='Z:'}
Get-Disk -Number 2 | Initialize-Disk -PassThru | New-Partition -DriveLetter E -UseMaximumSize | Format-Volume -FileSystem NTFS -Confirm:$false -Force
#>
<#
Read-Host "Please login to the AzureRM VM dc1 as localhost\azureadmin via the web interface and run the following:
powershell
Get-WmiObject -Class Win32_volume -Filter `"DriveLetter = 'E:'`" | Set-WmiInstance -Arguments @{DriveLetter='Z:'}
Get-Disk -Number 2 | Initialize-Disk -PassThru | New-Partition -DriveLetter E -UseMaximumSize | Format-Volume -FileSystem NTFS -Confirm:`$false -Force
Please press Enter once E drive is created"
#>
##########################################################################################################################################################

#Register the AzureRM VMs to be managed under DSC:
#DC1
Write-Warning "Please wait around 5 minutes. There is no feedback from AzureRM into the PowerShell window during this time.
       It is setting up the Domain Controller communication to the AzureRM Pull server.
       If you browse the web interface:
        a. https://portal.azure.com
        b. Automation Accounts
        c. TestAutomationAcct
        d. DSC nodes
       You will see that it is running the DSC configuration on the server"

Register-AzureRmAutomationDscNode -ResourceGroupName $resourceGroupName -AutomationAccountName $automationAccountName -AzureVMName 'dc1' -ConfigurationMode ApplyAndAutocorrect -ConfigurationModeFrequencyMins 15 -RefreshFrequencyMins 30 -RebootNodeIfNeeded $True -NodeConfigurationName 'BuildFirstDC.dc1' -AllowModuleOverwrite $True

$dscRegisterNode = Get-AzureRmAutomationDscNode @azureRMRGAutoAcct -Name 'dc1'
$i = 1
While ($dscRegisterNode.Status -ne 'Compliant')
{
    Start-Sleep -Seconds 60
    Write-Warning "DSC Node dc1 is not in DSC compliance. This can take around 15 minutes. It has been $i minute(s)."
    $dscRegisterNode = Get-AzureRmAutomationDscNode @azureRMRGAutoAcct -Name 'dc1'
    $i++
}
Write-Verbose "DSC Node dc1 is compliant"

#CA1
Write-Warning "Please wait around 5 minutes. There is no feedback from AzureRM into the PowerShell window during this time.
       It is setting up the Certificate Authority communication to the AzureRM Pull server.
       If you browse the web interface:
        a. https://portal.azure.com
        b. Automation Accounts
        c. TestAutomationAcct
        d. DSC nodes
       You will see that it is running the DSC configuration on the server"

Register-AzureRmAutomationDscNode -ResourceGroupName $resourceGroupName -AutomationAccountName $automationAccountName -AzureVMName 'ca1' -ConfigurationMode ApplyAndAutocorrect -ConfigurationModeFrequencyMins 15 -RefreshFrequencyMins 30 -RebootNodeIfNeeded $True -NodeConfigurationName 'BuildFirstCA.ca1' -AllowModuleOverwrite $True

$dscRegisterNode = Get-AzureRmAutomationDscNode @azureRMRGAutoAcct -Name 'ca1'
$i = 1
While ($dscRegisterNode.Status -ne 'Compliant')
{
    Start-Sleep -Seconds 60
    Write-Warning "DSC Node ca1 is not in DSC compliance. This can take around 15 minutes. It has been $i minute(s)."
    $dscRegisterNode = Get-AzureRmAutomationDscNode @azureRMRGAutoAcct -Name 'ca1'
    $i++
}
Write-Warning "DSC Node ca1 shows as compliant. Please wait around 30 minutes before getting angry as I have had early false positives with ca1.
DSC sometimes needs to run a couple of times and do a couple of reboots."
