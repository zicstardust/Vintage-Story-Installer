# Vintage Story Installer
Install any version of vintage story on Linux and Windows with .NET included

## Linux
### Dependencies
- wget
- bash
- tar
- curl
- awk
### Install
Open any shell and execute:
```bash
#export VERSION="x.x.x" #set specific version
#export GAME_DIR="/path/to/install" #set specific game install directory
#export GAME_DATA="/path/to/data" #set specific game data directory
#export INTERACTIVE=1 #set "1" to interactive setup
curl https://raw.githubusercontent.com/zicstardust/Vintage-Story-Installer/main/install.sh > /tmp/vs_installer.sh; bash /tmp/vs_installer.sh
```


### Environment variables

| variables | Function | Default |
| :----: | --- | --- |
| `VERSION` | Set game version | 1.21.0 |
| `GAME_DIR` | Set game install directory | $HOME/.local/share |
| `GAME_DATA` | Set game data directory | $HOME/.config |
| `INTERACTIVE` | set `1` to interactive setup | |

### Uninstall
right click on shortcut icon: "Uninstall"

## Windows
### Install
Open Powershell and execute:
```powershell
#$env:VERSION="x.x.x" #set specific version
#$env:GAME_DIR="X:\path\to\install" #set specific version
#$env:GAME_DATA="/path/to/data" #set specific game data directory
#$env:INTERACTIVE=1 #set "1" to interactive setup
Invoke-Expression (new-object Net.Webclient).DownloadString('https://raw.githubusercontent.com/zicstardust/Vintage-Story-Installer/refs/heads/main/install.ps1')
```

### Environment variables

| variables | Function | Default |
| :----: | --- | --- |
| `$env:VERSION` | Set game version | 1.21.0 |
| `$env:GAME_DIR` | Set game install directory | $env:APPDATA |
| `$env:GAME_DATA` | Set game data directory | $env:APPDATA |
| `$env:INTERACTIVE` | set `1` to interactive setup | |
