#!/bin/bash

set -e
: "${DOTNET_VERSION:=7.0.20}"
: "${GAME_VERSION:=1.20.12}"
: "${GAME_DIR:=$HOME/.local}"

mkdir -p "$GAME_DIR"
cd "$GAME_DIR"

wget https://cdn.vintagestory.at/gamefiles/stable/vs_client_linux-x64_${GAME_VERSION}.tar.gz
tar xf vs_client_linux-x64_${GAME_VERSION}.tar.gz
rm -f vs_client_linux-x64_${GAME_VERSION}.tar.gz

mkdir -p "$GAME_DIR/vintagestory/dotnet"
cd "$GAME_DIR/vintagestory/dotnet"

#download .NET
wget https://builds.dotnet.microsoft.com/dotnet/Runtime/${DOTNET_VERSION}/dotnet-runtime-${DOTNET_VERSION}-linux-x64.tar.gz
tar xf dotnet-runtime-${DOTNET_VERSION}-linux-x64.tar.gz
rm -f dotnet-runtime-${DOTNET_VERSION}-linux-x64.tar.gz


#uninstaller
cat > "$GAME_DIR/vintagestory/uninstall.sh" <<UNINSTALLER
#!/bin/bash
rm -Rf "$GAME_DIR/vintagestory"
rm -f \$HOME/.local/share/applications/vintagestory.desktop 

UNINSTALLER
chmod +x "$GAME_DIR/vintagestory/uninstall.sh"

#Create desktop shortcut
mkdir -p $HOME/.local/share/applications/
cat > $HOME/.local/share/applications/vintagestory.desktop <<DESKTOP
[Desktop Entry]
Categories=Game;
Comment=Wilderness survival sandbox game
Encoding=UTF-8
Exec=env DOTNET_ROOT="${GAME_DIR}/vintagestory/dotnet" PATH="\$PATH:${GAME_DIR}/vintagestory/dotnet" ${GAME_DIR}/vintagestory/run.sh
GenericName=Vintage Story
Icon=${GAME_DIR}/vintagestory/assets/gameicon.xpm
Name=Vintage Story
NoDisplay=false
Path=${GAME_DIR}/vintagestory
StartupNotify=true
Terminal=false
Actions=Uninstall;
[Desktop Action Uninstall]
Name=Uninstall
Exec=${GAME_DIR}/vintagestory/uninstall.sh
DESKTOP


