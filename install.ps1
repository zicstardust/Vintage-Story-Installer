$ErrorActionPreference= 'silentlycontinue'
$DEFAULT_VERSION="1.20.12"
$DEFAULT_GAME_DIR="$env:APPDATA"
$DEFAULT_GAME_DATA_DIR="$env:APPDATA\VintagestoryData"


if ($env:INTERACTIVE -eq 1){
    if ($null -eq $env:VERSION){
        $version = Read-Host "Which version will be installed [Default: $($DEFAULT_VERSION)]"
    }

    if ($null -eq $env:GAME_DIR){
        $GAME_DIR = Read-Host "Installation location [Default: $($DEFAULT_GAME_DIR)]"
    }

    if ($null -eq $env:GAME_DATA){
        $GAME_DATA = Read-Host "Game data location [Default: $($DEFAULT_GAME_DATA_DIR)]"
    }
}

if ($null -eq $env:VERSION){
    $version=$DEFAULT_VERSION
} else {
    $version=$env:VERSION
}


if ($null -eq $env:GAME_DIR){
    $GAME_DIR=$DEFAULT_GAME_DIR
} else {
    $GAME_DIR="$env:GAME_DIR"
}


if ($null -eq $env:GAME_DATA){
    $GAME_DATA=$DEFAULT_GAME_DATA_DIR
} else {
    $GAME_DATA="$env:GAME_DATA\VintagestoryData"
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
    Start-Process -FilePath $dest -ArgumentList "/VERYSILENT /DIR=`"$($GAME_DIR)`" /NOICONS /GROUP=`"Vintagestory`"" -Wait
    Remove-Item -Path $dest -Force

    $DesktopPath = [Environment]::GetFolderPath("Desktop")


    Remove-Item "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Vintage Story.lnk"
    Remove-Item "$DesktopPath\Vintage Story.lnk"


    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Vintage Story.lnk")
    $Shortcut.TargetPath = "$($GAME_DIR)\Vintagestory\Vintagestory.exe"
    $Shortcut.Arguments = "--dataPath `"$($GAME_DATA)`""
    $Shortcut.WorkingDirectory = "$($GAME_DIR)\Vintagestory"
    $Shortcut.IconLocation = "$($GAME_DIR)\Vintagestory\assets\gameicon.ico"
    $Shortcut.Save()



    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("$DesktopPath\Vintage Story.lnk")
    $Shortcut.TargetPath = "$($GAME_DIR)\Vintagestory\Vintagestory.exe"
    $Shortcut.Arguments = "--dataPath `"$($GAME_DATA)`""
    $Shortcut.WorkingDirectory = "$($GAME_DIR)\Vintagestory"
    $Shortcut.IconLocation = "$($GAME_DIR)\Vintagestory\assets\gameicon.ico"
    $Shortcut.Save()
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