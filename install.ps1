$ErrorActionPreference= 'silentlycontinue'

if ($null -eq $env:VERSION){
    $version="1.20.12"
} else {
    $version=$env:VERSION
}


if ($null -eq $env:GAMEDIR){
    $game_dir="$env:APPDATA\Vintagestory"
} else {
    $game_dir="$env:GAMEDIR\Vintagestory"
}


if ($version -lt "1.21.0"){
    $dotnet_desktop_version="7.0.20"
} else {
    $dotnet_desktop_version="8.0.19"
}


function Install-DotNet {
    $url="https://builds.dotnet.microsoft.com/dotnet/WindowsDesktop/$($dotnet_desktop_version)/windowsdesktop-runtime-$($dotnet_desktop_version)-win-x64.exe"
    $dest="$($env:TEMP)\windowsdesktop-runtime-$($dotnet_desktop_version)-win-x64.exe"
    Write-Output "Downloading .NET Desktop Runtime $($dotnet_desktop_version)..."
    Invoke-WebRequest -Uri $url -OutFile $dest
    Write-Output "Installing .NET Desktop Runtime $($dotnet_desktop_version)..."
    Start-Process -FilePath $dest -ArgumentList "/install /quiet /norestart" -Wait
    Remove-Item -Path $dest -Force
}


function Install-VS {
    $url="https://cdn.vintagestory.at/gamefiles"
    if ($((invoke-webrequest "$($url)/stable/vs_install_win-x64_$($version).exe" -DisableKeepAlive -UseBasicParsing -Method head).StatusCode) -eq 200){
        Write-Output "Downloading Vintage Story version $($version) from stable..."
        $download_url="$($url)/stable/vs_install_win-x64_$($version).exe"
    } elseif ($((invoke-webrequest "$($url)/unstable/vs_install_win-x64_$($version).exe" -DisableKeepAlive -UseBasicParsing -Method head).StatusCode) -eq 200){
        Write-Output "Downloading Vintage Story version $($version) from unstable..."
        $download_url="$($url)/unstable/vs_install_win-x64_$($version).exe"
    } else {
        Write-Output "ERROR: Version $($version) not found in either stable or unstable channels"
        exit 1
    }


    $dest="$($env:TEMP)\vs_install_win-x64_$($version).exe"
    Invoke-WebRequest -Uri $download_url -OutFile $dest
    Write-Output "Installing Vintage Story version $($version)..."
    Start-Process -FilePath $dest -ArgumentList "/VERYSILENT /DIR=`"$($game_dir)`"" -Wait
    Remove-Item -Path $dest -Force
}

#Main
if (-not(Test-Path "$($env:PROGRAMFILES)\dotnet\shared\Microsoft.WindowsDesktop.App\$($dotnet_desktop_version)")){
    Install-DotNet
} else {
    Write-Output ".NET Desktop Runtime $($dotnet_desktop_version) installed!"
}


if ($((Get-Package | Where-Object -Property Name -Match "Vintage Story").Version) -eq $version){
    Write-Output "Vintage Story $($version) installed!"
} else {
    Install-VS
}