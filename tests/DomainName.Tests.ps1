$ErrorActionPreference = 'Stop'

# Parse the deployment script and run only its domain-name assignment expression.
# No Azure cmdlets, authentication, deployment, or DSC configuration execute.
$tokens = $null
$parseErrors = $null
$scriptPath = Join-Path $PSScriptRoot '../AzureRM/1-Create-aate.ps1'
$ast = [System.Management.Automation.Language.Parser]::ParseFile($scriptPath, [ref]$tokens, [ref]$parseErrors)
if ($parseErrors.Count -ne 0) { throw ($parseErrors | Out-String) }

$assignments = @($ast.FindAll({
    param($node)
    $node -is [System.Management.Automation.Language.AssignmentStatementAst] -and
    $node.Left -is [System.Management.Automation.Language.VariableExpressionAst] -and
    $node.Left.VariablePath.UserPath -eq 'dscDomainNameNB'
}, $true))
if ($assignments.Count -ne 1) { throw 'Expected one domain-name assignment.' }
$expression = [scriptblock]::Create($assignments[0].Right.Extent.Text)

$cases = @(
    @{ Domain = 'timhaintz.com'; Expected = 'timhaintz' },
    @{ Domain = 'demo.com'; Expected = 'demo' },
    @{ Domain = 'com.com'; Expected = 'com' },
    @{ Domain = 'comic.com'; Expected = 'comic' },
    @{ Domain = 'DEMO.COM'; Expected = 'DEMO' }
)
foreach ($case in $cases) {
    $dscDomainName = $case.Domain
    $actual = & $expression
    if ($actual -cne $case.Expected) {
        throw "Expected '$($case.Expected)' from '$dscDomainName', got '$actual'."
    }
}

Write-Output 'PASS: all five domain suffix cases; no deployment script execution.'
