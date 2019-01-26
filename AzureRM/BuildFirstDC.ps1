configuration BuildFirstDC
{

    $domainName = Get-AutomationVariable -Name "domainname"
    $domainNameNB = Get-AutomationVariable -Name "domainnamenb"
    $domainCred = Get-AutomationPsCredential -Name "domaincred"
    $safemodeAdministratorCred = Get-AutomationPsCredential -Name "safemodecred"

    Import-DscResource -ModuleName 'xActiveDirectory'
    Import-DscResource -ModuleName 'NetworkingDsc'
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DscResource -ModuleName 'xDnsServer'
    Import-DscResource -ModuleName 'StorageDsc'

    Node $AllNodes.Where{$_.Role -eq "Primary DC"}.Nodename
    {
        OpticalDiskDriveLetter SetFirstOpticalDiskDriveLettertoZ
        {
            DiskId  = 1
            DriveLetter = 'Z'
        }
        WaitForDisk Disk2
        {
            DiskId = 2
            RetryIntervalSec = 15
            RetryCount = 20
        }
        Disk EVolume
        {
            DiskId = 2
            DriveLetter = 'E'
            FSLabel = 'Data'
            FSFormat = 'NTFS'
            DependsOn = "[OpticalDiskDriveLetter]SetFirstOpticalDiskDriveLettertoZ","[WaitForDisk]Disk2"
        }
        WindowsFeature ADDSInstall
        {
           Ensure = 'Present'
           Name   = 'AD-Domain-Services'
        }
        xADDomain FirstDS
        {
            DomainName = $domainName
            DomainAdministratorCredential = $domainCred
            SafemodeAdministratorPassword = $safemodeAdministratorCred
            DnsDelegationCredential = $DNSDelegationCred
            DatabasePath = 'e:\Windows\NTDS'
            LogPath = 'e:\Windows\NTDS'
            SysvolPath = 'e:\Windows\SYSVOL'
            DependsOn = "[WindowsFeature]ADDSInstall"
        }
        xWaitForADDomain DscForestWait
        {
            DomainName = $domainNameNB
            DomainUserCredential = $domainCred
            RetryCount = 2
            RetryIntervalSec = 30
            DependsOn = "[xADDomain]FirstDS"
        }
        xDnsServerForwarder SetForwarders
        {
            IsSingleInstance = 'Yes'
            IPAddresses = '168.63.129.16'

        }
    }
}