$ErrorActionPreference = 'Stop'

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition

$packageArgs = @{
    PackageName    = $env:chocolateyPackageName
    FileFullPath   = "$toolsPath\"
    FileFullPath64 = "$toolsPath\"
    Destination    = $toolsPath
}

Get-ChildItem $toolsPath\* | Where-Object { $_.PSISContainer } | Remove-Item -Recurse -Force #remove older package dirs
Get-ChocolateyUnzip @packageArgs
Remove-Item $toolsPath\*.zip -ea 0
