configuration BuildFirstCA
{
    $domainName = Get-AutomationVariable -Name "domainname"
    $domainCred = Get-AutomationPsCredential -Name "domaincred"

    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DscResource -ModuleName 'xAdcsDeployment'
    Import-DscResource -ModuleName 'ComputerManagementDsc'
    Import-DscResource -ModuleName 'NetworkingDsc'

    Node $AllNodes.Where{$_.Role -eq "Enterprise Root Certificate Authority"}.Nodename
    {
        DnsServerAddress DnsServerAddress
        {
            Address = '10.0.0.4'
            InterfaceAlias = "Ethernet"
            AddressFamily = 'IPv4'
            Validate = $true
        }
        xComputer JoinDomain
        {
            Name          = 'ca1'
            DomainName    = $domainName
            Credential    = $domainCred
            DependsOn = '[xDnsServerAddress]DnsServerAddress'
        }
        WindowsFeature ADCS-Cert-Authority
        {
           Ensure = 'Present'
           Name   = 'ADCS-Cert-Authority'
           DependsOn = '[xComputer]JoinDomain'
        }
        xADCSCertificationAuthority ADCS
        {
            Ensure = 'Present'
            Credential = $domainCred
            CAType = 'EnterpriseRootCA'
            CACommonName = "$(($domainName).split('.')[0])-root"
            CADistinguishedNameSuffix = 'C=AU,L=Victoria,S=Ballarat,O=TimHaintz'
            CryptoProviderName = 'RSA#Microsoft Software Key Storage Provider'
            HashAlgorithmName = 'SHA256'
            KeyLength = 4096
            DatabaseDirectory = 'C:\Windows\system32\CertLog'
            LogDirectory = 'C:\Windows\system32\CertLog'
            ValidityPeriod = 'Years'
            ValidityPeriodUnits = 5
            DependsOn = '[WindowsFeature]ADCS-Cert-Authority'
        }
        WindowsFeature ADCS-Web-Enrollment
        {
            Ensure = 'Present'
            Name = 'ADCS-Web-Enrollment'
            DependsOn = '[WindowsFeature]ADCS-Cert-Authority'
        }
        xADCSWebEnrollment CertSrv
        {
            Ensure = 'Present'
            IsSingleInstance = 'Yes'
            Credential = $domainCred
            DependsOn = '[WindowsFeature]ADCS-Cert-Authority','[xADCSCertificationAuthority]ADCS'
        }
    }
}