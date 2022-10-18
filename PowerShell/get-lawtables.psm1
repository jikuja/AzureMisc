<#
.Description
Gathers table names from Microsoft.Insights/diagnosticSettings type resources from Bicep files
* properties.logs.category is being gathered
  * all configured categories, does not check if it turned off or on
#>
function Get-LawTables {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [SupportsWildcards()]
        [string[]]
        $Path
    )

    $files = Resolve-Path $Path
    $result = $()
    if ($files) {
        foreach ($file in $files) {
            Write-Debug "Building $file"
            $x = Build-BicepNetFile -path $file
            $y = ConvertFrom-Json -InputObject $x[0]
            $tables = $y.resources | Where-Object { $_.type -eq "Microsoft.Insights/diagnosticSettings" } | ForEach-Object {$_.properties.logs.category}
            $result += $tables
        }
    }

    $result = $result | Sort-Object | Get-Unique
    $resultStr = ConvertTo-Json $result
    Write-Host "JSON Array"
    Write-Host $resultStr
}