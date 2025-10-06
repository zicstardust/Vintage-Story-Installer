# Vintage Story Installer
Install any version of vintage story on Linux with .NET included

## Dependencies
- wget
- bash
- tar
- curl
- awk

## Install
Open any shell and execute:
```bash
#export VERSION="x.x.x" #set specific version
#export GAME_DIR="/path/to/install" #set specific game install directory
#export GAME_DATA="/path/to/data" #set specific game data directory
#export INTERACTIVE=1 #set "1" to interactive setup
curl https://raw.githubusercontent.com/zicstardust/Vintage-Story-Installer/main/install.sh > /tmp/vs_installer.sh; bash /tmp/vs_installer.sh
```

## Environment variables

| variables | Function | Default |
| :----: | --- | --- |
| `VERSION` | Set game version | 1.21.4 |
| `GAME_DIR` | Set game install directory | $HOME/.local/share |
| `GAME_DATA` | Set game data directory | $HOME/.config |
| `INTERACTIVE` | set `1` to interactive setup | |

## Uninstall
right click on shortcut icon: "Uninstall"
