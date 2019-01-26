# Configuration Data for AD - https://msdn.microsoft.com/en-us/powershell/dsc/configdata
@{
    AllNodes = @(
        @{
            Nodename = "dc1"
            Role = "Primary DC"
            DomainName = "timhaintz.com"
            RetryCount = 20
            RetryIntervalSec = 30
            PSDscAllowDomainUser = $true
        },
        @{
            Nodename = "dc2"
            Role = "Replica DC"
            DomainName = "timhaintz.com"
            RetryCount = 20
            RetryIntervalSec = 30
        },
        @{
            Nodename = "ca1"
            Role = "Enterprise Root Certificate Authority"
            DomainName = "timhaintz.com"
            RetryCount = 20
            RetryIntervalSec = 30
            PSDscAllowDomainUser = $true
        }
    )
}