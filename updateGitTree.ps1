Set-StrictMode -Version 3.0
$ErrorActionPreference = 'Stop'
#Requires -Version 7.2

foreach($port in (Get-ChildItem ports -Directory)) {
	$versionPath = "./versions/$($port.Name[0])-/$($port.Name).json"
	$portPath = "$(Resolve-Path $port -Relative)" -replace '\\','/'

	Write-Host "Version path: $($versionPath)`nPort Path: $($portPath)"

	$commit = git rev-parse "HEAD:$($portPath)"

	$versionObj = (Get-Content $versionPath | ConvertFrom-Json)
	$versionObj.versions[0].'git-tree' = $commit
	Set-Content -Path $versionPath -Value (ConvertTo-Json $versionObj)

	Write-Host "Updated $(ConvertTo-Json $versionObj)"
}
