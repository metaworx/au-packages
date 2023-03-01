[CmdletBinding()]
param(
    [switch]$force,
    [switch]$NoCheckChocoVersion
)

import-module au

[uri]$sf        = 'https://sourceforge.net'
[uri]$dl        = 'https://master.dl.sourceforge.net'
$project        = 'convertcp'
[uri]$files     = "${sf}projects/$project/files/"
[uri]$download  = "${files}latest/download"

function global:au_SearchReplace {

    @{
        ".\legal\VERIFICATION.txt"      = @{
            "(?i)(Go to)\s*[^,]*" = "`${1} $files"
            "(?i)(\s+x32:).*"     = "`${1} $($Latest.URL32)"
            "(?i)(\s+x64:).*"     = "`${1} $($Latest.URL64)"
            "(?i)(checksum32:).*" = "`${1} $($Latest.Checksum32)"
            "(?i)(checksum64:).*" = "`${1} $($Latest.Checksum64)"
        }

        #     "$($Latest.PackageName).nuspec" = @{
        #       "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
        #     }

        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*FileFullPath\s*=\s*`"`[$]toolsPath\\).*`""   = "`${1}$($Latest.FileName32)`""
            "(?i)(^\s*FileFullPath64\s*=\s*`"`[$]toolsPath\\).*`"" = "`${1}$($Latest.FileName64)`""
        }
    }
}

function global:au_BeforeUpdate {
    Get-RemoteFiles -Purge -NoSuffix
}

function global:au_GetLatest {

    $download_latest_page = Invoke-WebRequest -Uri $download -UseBasicParsing

    [regex]$re    = 'convertcp_v([\d]+(\.[\d]+))+_x(86|64)\.zip'
    $url          = [uri]($download_latest_page.Links | Where-Object href -match $re.ToString() | Select-Object -first 1 -expand data-release-url)
    $version      = $re.Matches($url.AbsolutePath).Groups[1].Value

    #https://deac-fra.dl.sourceforge.net/project/convertcp/bin/x86/convertcp_v8.4_x86.zip
    $url32 = "${dl}project/$project/bin/x86/convertcp_v${version}_x86.zip?viasf=1"
    $url64 = "${dl}project/$project/bin/x64/convertcp_v${version}_x64.zip?viasf=1"

    $releaseNotes = "${dl}project/$project/readme.md?viasf=1"

    $stream = @{
        Version      = $version
        FileType     = "zip"
        URL32        = $url32
        URL64        = $url64
        ReleaseNotes = $releaseNotes
    }

    $message = "  " + ($stream.Keys | foreach { "$_ $($stream[$_])" }) -join "`r`n  "
    Write-Debug $message

    return $stream;
}

try {
    if ($MyInvocation.InvocationName -ne '.') {
        update -ChecksumFor none @PSBoundParameters
    }
} catch {
#    $ignore = "Unable to connect to the remote server"
#    if ($_ -match $ignore) { Write-Host $ignore; 'ignore' } else { throw $_ }
    $_
}
