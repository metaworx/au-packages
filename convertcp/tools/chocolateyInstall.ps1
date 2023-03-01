$ErrorActionPreference = 'Stop'

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition

$packageArgs = @{
    PackageName    = $env:chocolateyPackageName
    FileFullPath   = "$toolsPath\convertcp_v3.1_x86.zip"
    FileFullPath64 = "$toolsPath\convertcp_v3.1_x64.zip"
    Destination    = $toolsPath
}

Get-ChildItem $toolsPath\* | Where-Object { $_.PSISContainer } | Remove-Item -Recurse -Force #remove older package dirs
Get-ChocolateyUnzip @packageArgs
Remove-Item $toolsPath\*.zip -ea 0
