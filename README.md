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
#export GAME_DIR="/path/to/install" #set specific game directory install
curl https://raw.githubusercontent.com/zicstardust/Vintage-Story-Installer/main/install.sh | bash
```


### Environment variables

| variables | Function | Default |
| :----: | --- | --- |
| `VERSION` | Set game version | 1.20.12 |
| `GAME_DIR` | Set game directory install | $HOME/.local |

### Uninstall
right click on shortcut icon: "Uninstall"

## Windows
### Install
Open Powershell and execute:
```powershell
#$env:VERSION="x.x.x" #set specific version
#$env:GAMEDIR="X:\path\to\install" #set specific version
Invoke-Expression (new-object Net.Webclient).DownloadString('https://raw.githubusercontent.com/zicstardust/Vintage-Story-Installer/refs/heads/main/install.ps1')
```

### Environment variables

| variables | Function | Default |
| :----: | --- | --- |
| `$env:VERSION` | Set game version | 1.20.12 |
| `$env:GAMEDIR` | Set game directory install | $env:APPDATA |
