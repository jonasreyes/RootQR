#!/bin/bash
# RootQR Installer v0.1
# Licencia: GPLv3

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuración
APP_NAME="RootQR"
REPO_URL="https://github.com/jonasreyes/rootqr.git"
INSTALL_DIR="/opt/$APP_NAME"
BIN_DIR="/usr/local/bin"
DESKTOP_DIR="$HOME/.local/share/applications"
CONFIG_DIR="$HOME/.config"
WRAPPER_SCRIPT="$INSTALL_DIR/rootqr-wrapper.sh"

# 1. Verificar dependencias
echo -e "${YELLOW}[+] Verificando dependencias...${NC}"
if ! command -v git &> /dev/null; then
    echo -e "${RED}[-] Git no está instalado. Instalando...${NC}"
    sudo apt install -y git
fi

# 2. Clonar repositorio
echo -e "${YELLOW}[+] Clonando repositorio...${NC}"
sudo rm -rf $INSTALL_DIR 2>/dev/null
sudo git clone $REPO_URL $INSTALL_DIR
sudo chown -R $USER:$USER $INSTALL_DIR

# 3. Crear entorno virtual e instalar dependencias
echo -e "${YELLOW}[+] Configurando entorno Python...${NC}"
cd $INSTALL_DIR
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install --upgrade 'flet[full]' 'qrcode[pil]'

# 4. Crear base de datos
echo -e "${YELLOW}[+] Inicializando base de datos...${NC}"
mkdir -p $INSTALL_DIR/src/database
python3 -c "from src.database import init_db; init_db()"

# 5. Crear wrapper script
echo -e "${YELLOW}[+] Creando wrapper de ejecución...${NC}"
cat > $WRAPPER_SCRIPT <<EOL
#!/bin/bash
cd $INSTALL_DIR
source venv/bin/activate
python3 src/main.py
EOL
chmod +x $WRAPPER_SCRIPT

# 6. Crear lanzador .desktop
echo -e "${YELLOW}[+] Creando acceso directo...${NC}"
cat > $DESKTOP_DIR/RootQR.desktop <<EOL
[Desktop Entry]
Version=1.0
Name=RootQR
Comment=Generador de códigos QR
Exec=$WRAPPER_SCRIPT
Icon=$INSTALL_DIR/src/assets/icon.png
Terminal=false
Type=Application
Categories=Utility;Development;
StartupWMClass=RootQR
EOL

# 7. Crear alias en bashrc/zshrc
echo -e "${YELLOW}[+] Configurando alias...${NC}"
for RC_FILE in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [ -f "$RC_FILE" ]; then
        grep -q "alias rootqr=" $RC_FILE || echo "alias rootqr='$WRAPPER_SCRIPT'" >> $RC_FILE
    fi
done

# 8. Permisos
sudo chmod -R 755 $INSTALL_DIR

echo -e "${GREEN}[✔] Instalación completada!${NC}"
echo -e "Ejecuta la aplicación con: ${YELLOW}rootqr${NC} o desde el menú de aplicaciones"
