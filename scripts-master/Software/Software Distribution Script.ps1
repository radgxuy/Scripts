
$source = "C:\Users\mmitchell\OneDrive - DSA Technologies\Software"
$filename = "TreeSizeFreeSetup.exe"
$destdir = "$env:SystemDrive\Temp\TreeSize"
$softwarename = "Treesize Free"

function downloadFile {
    Param (
        [Parameter(Mandatory = $true)]$source,
        [Parameter(Mandatory = $true)]$destdir,
        [Parameter(Mandatory = $true)]$filename
    )
    If (!(Test-Path -Path $destdir)) {
        Write-Host "Creating local destination directory $destdir"
        Try {
            New-Item -Path $destdir -ItemType Directory | Out-Null
        } Catch {
            Write-Error "Failed to create the destination directory $destdir with the following error: $($_.ErrorMessage)."
            break
        }
    } else {
        Remove-Item -Path "$destdir\$filename" -Force -ErrorAction SilentlyContinue
    }
    Write-Host "Downloading $filename from $source to $destdir"
    $webclient = New-Object System.Net.WebClient
    Try {
        $webclient.DownloadFile("$source/$filename","$destdir\$filename")
    } Catch {
        Write-Host "Failed to download $filename from $source with the following error: $($_.ErrorMessage)."
        break
    }
    return
}
function unZip {
    Param (
        [Parameter(Mandatory = $true)]$source,
        [Parameter(Mandatory = $true)]$destdir
    )
    If (!(Test-Path -Path $destdir)) {
        Write-Host "Creating local destination directory $destdir"
        Try {
            New-Item -Path $destdir -ItemType Directory | Out-Null
        } Catch {
            Write-Error "Failed to create the destination directory $destdir with the following error: $($_.ErrorMessage)."
            break
        }
    } else {
        Remove-Item -Path "$destdir\*.*" -Exclude "*.zip"
    }
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $void = [System.IO.Compression.ZipFile]::ExtractToDirectory($source,$destdir)
}

Write-Host "Starting $softwarename Installation."
downloadFile -source $source -destdir $destdir -filename $filename

$exec = "$destdir\$filename"
$args = "/verysilent"

If (Test-Path -Path $exec) {
    Write-Host "Installing with arguments $args."
    Start-Process -FilePath $exec -ArgumentList $args -wait
 
}
 else {
    Write-Host "The file $filename failed to download or save. Cannot continue."
 }