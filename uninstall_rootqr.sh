#!/bin/bash
# RootQR Uninstaller v0.1
# Licencia: GPLv3

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Configuración
APP_NAME="RootQR"
INSTALL_DIR="/opt/$APP_NAME"
DESKTOP_DIR="$HOME/.local/share/applications"

# 1. Eliminar directorio de instalación
echo -e "${RED}[-] Eliminando archivos...${NC}"
sudo rm -rf $INSTALL_DIR

# 2. Eliminar acceso directo
rm -f $DESKTOP_DIR/RootQR.desktop

# 3. Eliminar alias
echo -e "${RED}[-] Eliminando alias...${NC}"
for RC_FILE in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [ -f "$RC_FILE" ]; then
        sed -i '/alias rootqr=/d' $RC_FILE
    fi
done

echo -e "${GREEN}[✔] Desinstalación completada!${NC}"
