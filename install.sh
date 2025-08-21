#!/bin/bash
DEFAULT_VERSION="1.20.12"
DEFAULT_GAME_DIR="$HOME/.local/share"
DEFAULT_GAME_DATA_DIR="$HOME/.config/VintagestoryData"

if [[ "$INTERACTIVE" -eq 1 ]]; then
    if [[ -z "$VERSION" ]]; then
        read -r -p "Which version will be installed [Default: ${DEFAULT_VERSION}]: " VERSION
    fi

    if [[ -z "$GAME_DIR" ]]; then
        read -r -p "Installation location [Default: ${DEFAULT_GAME_DIR}]: " GAME_DIR
    fi

    if [[ -z "$GAME_DATA_DIR" ]]; then
        read -r -p "Game data location [Default: ${DEFAULT_GAME_DATA_DIR}]: " GAME_DATA_DIR
    fi
fi

if [[ -z "$VERSION" ]]; then
    VERSION=${VERSION:-${DEFAULT_VERSION}}
fi

if [[ -z "$GAME_DIR" ]]; then
    GAME_DIR=${GAME_DIR:-${DEFAULT_GAME_DIR}}

fi

if [[ -z "$GAME_DATA_DIR" ]]; then
    GAME_DATA_DIR=${GAME_DATA_DIR:-${DEFAULT_GAME_DATA_DIR}}
fi

if awk "BEGIN {exit !($VERSION <= 1.21.0)}"; then
    DOTNET_VERSION="7.0.20"
else
    DOTNET_VERSION="8.0.19"
fi

STABLE_URL="https://cdn.vintagestory.at/gamefiles/stable/vs_client_linux-x64_"
UNSTABLE_URL="https://cdn.vintagestory.at/gamefiles/unstable/vs_client_linux-x64_"


STABLE_FULL_URL="${STABLE_URL}${VERSION}.tar.gz"
UNSTABLE_FULL_URL="${UNSTABLE_URL}${VERSION}.tar.gz"


if wget --spider -q "$STABLE_FULL_URL" 2>/dev/null; then
    echo "Downloading Vintage Story version ${VERSION} from stable..."
    DOWNLOAD_URL="$STABLE_FULL_URL"
elif wget --spider -q "$UNSTABLE_FULL_URL" 2>/dev/null; then
    echo "Downloading Vintage Story version ${VERSION} from unstable..."
    DOWNLOAD_URL="$UNSTABLE_FULL_URL"
else
    echo "ERROR: Version ${VERSION} not found in either stable or unstable channels"
    exit 1
fi


mkdir -p "$GAME_DIR"
cd "$GAME_DIR"

if [ -d "$GAME_DIR/vintagestory" ]; then
    echo "Removing existent folder..."
    bash "$GAME_DIR/vintagestory/uninstall.sh"
fi

wget -q ${DOWNLOAD_URL}
tar xzf vs_client_linux-x64_${VERSION}.tar.gz
rm -f vs_client_linux-x64_${VERSION}.tar.gz

mkdir -p "$GAME_DIR/vintagestory/dotnet"
cd "$GAME_DIR/vintagestory/dotnet"

#download .NET
if [[ $(uname -m) == "aarch64" ]]; then
  ARCH="arm64"
else
  ARCH="x64"
fi

echo "Downloading .NET Runtime ${DOTNET_VERSION}..."
wget -q https://builds.dotnet.microsoft.com/dotnet/Runtime/${DOTNET_VERSION}/dotnet-runtime-${DOTNET_VERSION}-linux-${ARCH}.tar.gz
tar xf dotnet-runtime-${DOTNET_VERSION}-linux-${ARCH}.tar.gz
rm -f dotnet-runtime-${DOTNET_VERSION}-linux-${ARCH}.tar.gz

DESKTOP_ENTRY_NAME=$(echo $GAME_DIR | sed 's|/||g')

#uninstaller
cat > "$GAME_DIR/vintagestory/uninstall.sh" <<UNINSTALLER
#!/bin/bash
rm -Rf "$GAME_DIR/vintagestory"
rm -f $HOME/.local/share/applications/vintagestory${DESKTOP_ENTRY_NAME}.desktop 
rm -f $HOME/.local/share/applications/Vintagestory_url_connect${DESKTOP_ENTRY_NAME}.desktop
rm -f $HOME/.local/share/applications/Vintagestory_url_mod${DESKTOP_ENTRY_NAME}.desktop

UNINSTALLER
chmod +x "$GAME_DIR/vintagestory/uninstall.sh"


#update
cat > "$GAME_DIR/vintagestory/update.sh" <<UPDATER
#!/bin/bash
export GAME_DIR="${GAME_DIR}"
export GAME_DATA="${GAME_DATA}"
export INTERACTIVE=1
curl https://raw.githubusercontent.com/zicstardust/Vintage-Story-Installer/main/install.sh | bash

UPDATER
chmod +x "$GAME_DIR/vintagestory/update.sh"

#Create desktop shortcut
mkdir -p $HOME/.local/share/applications/
cat > $HOME/.local/share/applications/vintagestory${DESKTOP_ENTRY_NAME}.desktop <<DESKTOP
#!/usr/bin/xdg-open
[Desktop Entry]
Categories=Game;
Comment=Wilderness survival sandbox game
Encoding=UTF-8
Exec=env DOTNET_ROOT="${GAME_DIR}/vintagestory/dotnet" PATH="\$PATH:${GAME_DIR}/vintagestory/dotnet" ${GAME_DIR}/vintagestory/run.sh --dataPath "${GAME_DATA_DIR}"
GenericName=Sandbox Game
Icon=${GAME_DIR}/vintagestory/assets/gameicon.xpm
Name=Vintage Story ${VERSION}
NoDisplay=false
Path=${GAME_DIR}/vintagestory
StartupNotify=false
Type=Application
Terminal=false
Actions=Uninstall;Update;
[Desktop Action Uninstall]
Name=Uninstall
Exec=${GAME_DIR}/vintagestory/uninstall.sh
[Desktop Action Update]
Name=Update/Change Version
Exec=${GAME_DIR}/vintagestory/update.sh
Terminal=true
DESKTOP


cat > $HOME/.local/share/applications/Vintagestory_url_connect${DESKTOP_ENTRY_NAME}.desktop <<DESKTOP
#!/usr/bin/xdg-open
[Desktop Entry]
Name=Vintage Story URI connect ${VERSION}
Exec=bash -c "export DOTNET_ROOT="${GAME_DIR}/vintagestory/dotnet" && ${GAME_DIR}/vintagestory/Vintagestory --dataPath "${GAME_DATA_DIR}" -c %U"
Terminal=false
NoDisplay=true
Type=Application
StartupNotify=false
Categories=Game;
Path=${GAME_DIR}/vintagestory
MimeType=x-scheme-handler/vintagestoryjoin;
DESKTOP


cat > $HOME/.local/share/applications/Vintagestory_url_mod${DESKTOP_ENTRY_NAME}.desktop <<DESKTOP
#!/usr/bin/xdg-open
[Desktop Entry]
Name=Vintage Story URI mod install ${VERSION}
Exec=bash -c "export DOTNET_ROOT="${GAME_DIR}/vintagestory/dotnet" && ${GAME_DIR}/vintagestory/Vintagestory --dataPath "${GAME_DATA_DIR}" -i %U"
Terminal=false
NoDisplay=true
Type=Application
StartupNotify=false
Categories=Game;
Path=${GAME_DIR}/vintagestory
MimeType=x-scheme-handler/vintagestorymodinstall;
DESKTOP
