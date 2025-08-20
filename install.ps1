if ($null -eq $env:version){
    $version="1.20.12"
} else {
    $version=$env:version
}


if ($version -lt "1.21.0"){
    $dotnet_desktop_version="7.0.20"
} else {
    $dotnet_desktop_version="8.0.19"
}


#Download and install .NET
$url="https://builds.dotnet.microsoft.com/dotnet/WindowsDesktop/$($dotnet_desktop_version)/windowsdesktop-runtime-$($dotnet_desktop_version)-win-x64.exe"
$dest="$($env:TEMP)\windowsdesktop-runtime-$($dotnet_desktop_version)-win-x64.exe"
Write-Output "Downloading .NET Desktop Runtime $($dotnet_desktop_version)..."
Invoke-WebRequest -Uri $url -OutFile $dest
Write-Output "Installing .NET Desktop Runtime $($dotnet_desktop_version)..."
Start-Process -FilePath $dest -ArgumentList "/install /quiet /norestart" -Wait
Remove-Item -Path $dest -Force


#Download and install Vintage Story

if (invoke-webrequest "https://cdn.vintagestory.at/gamefiles/stable/vs_install_win-x64_$($version).exe" -DisableKeepAlive -UseBasicParsing -Method head){
    Write-Output "Downloading Vintage Story version $($version) from stable..."
    $download_url="https://cdn.vintagestory.at/gamefiles/stable/vs_install_win-x64_$($version).exe"
} elseif (invoke-webrequest "https://cdn.vintagestory.at/gamefiles/unstable/vs_install_win-x64_$($version).exe" -DisableKeepAlive -UseBasicParsing -Method head){
    Write-Output "Downloading Vintage Story version $($version) from unstable..."
    $download_url="https://cdn.vintagestory.at/gamefiles/unstable/vs_install_win-x64_$($version).exe"
} else {
    Write-Output "ERROR: Version $($version) not found in either stable or unstable channels"
    exit 1
}


$dest="$($env:TEMP)\vs_install_win-x64_$($version).exe"
Invoke-WebRequest -Uri $download_url -OutFile $dest
Write-Output "Installing Vintage Story version $($version)..."
Start-Process -FilePath $dest -ArgumentList "/Silent" -Wait
Remove-Item -Path $dest -Force

