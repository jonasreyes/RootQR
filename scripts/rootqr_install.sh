#!/bin/bash
# rootqr_install.sh - Instalador Oficial RootQR v0.1.0
set -eo pipefail

# --- Constantes mejoradas ---
readonly VERSION="0.1.0"
readonly TELEGRAM_ROOTQR="https://t.me/rootqr_app"
readonly TELEGRAM_CANAIMA="https://t.me/CanaimaGNULinuxOficial"
readonly REPO_URL="https://github.com/jonasreyes/rootqr.git"
readonly LOGO_ASCII=$(cat << "EOF"
██████╗  ██████╗  ██████╗ ████████╗ ██████╗ ██████╗ 
██╔══██╗██╔═══██╗██╔═══██╗╚══██╔══╝██╔═══██╗██╔══██╗
██████╔╝██║   ██║██║   ██║   ██║   ██║   ██║██████╔╝
██╔══██╗██║   ██║██║   ██║   ██║   ██║▄▄ ██║██╔══██╗
██║  ██║╚██████╔╝╚██████╔╝   ██║   ╚██████╔╝██║  ██║
╚═╝  ╚═╝ ╚═════╝  ╚═════╝    ╚═╝    ╚══▀▀═╝ ╚═╝  ╚═╝
EOF
)

# --- Configuración inicial mejorada ---
DIR_APPS="${HOME}/apps"
DIR_INSTALACION="${DIR_APPS}/rootqr"
DIR_SCRIPTS="${DIR_INSTALACION}/scripts"
DIR_CONFIG="${HOME}/.config/rootqr"
DIR_LOGS="${DIR_CONFIG}/logs"
ARCHIVO_LOG="${DIR_LOGS}/instalacion_$(date +%Y%m%d_%H%M%S).log"
DESKTOP_DIR="${HOME}/.local/share/applications"
WRAPPER_SCRIPT="${DIR_INSTALACION}/rootqr-wrapper.sh"

# --- Variables dinámicas ---
DIR_EXPORTACIONES=""

# --- Funciones mejoradas ---
inicializar_directorios() {
    echo -e "📂 \033[1mConfigurando directorios base...\033[0m"
    
    local dirs=(
        "${DIR_APPS}"
        "${DIR_CONFIG}"
        "${DIR_LOGS}"
        "${DESKTOP_DIR}"
    )
    
    for dir in "${dirs[@]}"; do
        echo -n "  ▸ Creando ${dir}... "
        if mkdir -p "${dir}"; then
            echo -e "\033[1;32mOK\033[0m"
            registrar_log "Directorio creado: ${dir}"
        else
            echo -e "\033[1;31mFALLÓ\033[0m"
            registrar_log "Error al crear directorio: ${dir}"
            exit 1
        fi
    done
}

# ... (mantener mostrar_banner, registrar_log, verificar_instalacion_previa y actualizar_aplicacion igual que en DeepRoot)

detectar_sistema() {
    registrar_log "Detectando sistema operativo..."
    
    if [[ -f "/etc/os-release" ]]; then
        NAME=$(grep -E '^NAME=' /etc/os-release | cut -d'=' -f2- | tr -d '"')
        PRETTY_NAME=$(grep -E '^PRETTY_NAME=' /etc/os-release | cut -d'=' -f2- | tr -d '"')
        ID=$(grep -E '^ID=' /etc/os-release | cut -d'=' -f2- | tr -d '"')
        VERSION_ID=$(grep -E '^VERSION_ID=' /etc/os-release | cut -d'=' -f2- | tr -d '"')
    fi

    echo -e "\n💻 \033[1mSistema detectado:\033[0m"
    echo -e "  ▸ Distribución: ${PRETTY_NAME:-Desconocida}"
    [[ -n "$VERSION_ID" ]] && echo -e "  ▸ Versión: ${VERSION_ID}"
    echo -e "  ▸ Kernel: $(uname -r)"
    
    registrar_log "Sistema: ${PRETTY_NAME:-Desconocido}, Versión: ${VERSION_ID:-N/A}, Kernel: $(uname -r), ID: ${ID:-desconocido}"
}

verificar_dependencias_iniciales() {
    echo -e "\n🔍 \033[1mVerificando dependencias iniciales...\033[0m"
    local faltantes=()

    for cmd in git curl python3; do
        if ! command -v $cmd &> /dev/null; then
            faltantes+=("$cmd")
        fi
    done

    if [[ ${#faltantes[@]} -gt 0 ]]; then
        echo -e "❌ \033[1;31mFaltan dependencias:\033[0m ${faltantes[*]}"
        case "${ID}" in
            debian|ubuntu|canaima)
                echo -e "Instala con: \033[1msudo apt update && sudo apt install ${faltantes[*]} python3-venv\033[0m";;
            arch|manjaro)
                echo -e "Instala con: \033[1msudo pacman -S ${faltantes[*]} python\033[0m";;
            fedora|rhel|centos)
                echo -e "Instala con: \033[1msudo dnf install ${faltantes[*]} python3\033[0m";;
            *)
                echo -e "Instala los paquetes equivalentes en tu distribución";;
        esac
        exit 1
    fi
}

# ... (mantener verificar_libmpv y mostrar_ayuda_libmpv igual que en DeepRoot)

configurar_entorno_python() {
    registrar_log "Configurando entorno Python..."
    echo -e "\n🐍 \033[1mCreando entorno virtual en .venv...\033[0m"
    
    if ! python3 -m venv "${DIR_INSTALACION}/.venv"; then
        echo -e "\n❌ \033[1;31mError al crear el entorno virtual.\033[0m"
        case "${ID}" in
            debian|ubuntu|canaima)
                echo -e "Instala python3-venv con: \033[1msudo apt install python3-venv\033[0m";;
            *)
                echo -e "Asegúrate de tener los paquetes de desarrollo de Python instalados";;
        esac
        exit 1
    fi
    
    source "${DIR_INSTALACION}/.venv/bin/activate"
    
    echo -e "\n🔄 \033[1mActualizando pip...\033[0m"
    pip install --upgrade pip || {
        echo -e "\n❌ \033[1;31mError al actualizar pip\033[0m"
        exit 1
    }
    
    echo -e "\n📦 \033[1mInstalando dependencias...\033[0m"
    pip install 'flet[desktop-light]' 'qrcode[pil]' pillow || {
        echo -e "\n❌ \033[1;31mError al instalar dependencias\033[0m"
        exit 1
    }
}

# ... (mantener crear_directorio_exportaciones, instalar_comandos, copiar_scripts igual que en DeepRoot)

crear_wrapper_script() {
    echo -e "\n📜 \033[1mCreando wrapper de ejecución...\033[0m"
    cat > "${WRAPPER_SCRIPT}" << 'EOF'
#!/bin/bash
# Wrapper para RootQR

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_PYTHON="${APP_DIR}/.venv/bin/python"

if [[ ! -f "${VENV_PYTHON}" ]]; then
    echo "Error: Entorno virtual no encontrado" >&2
    exit 1
fi

cd "${APP_DIR}" || exit 1
exec "${VENV_PYTHON}" src/main.py "$@"
EOF

    chmod +x "${WRAPPER_SCRIPT}"
    registrar_log "Wrapper script creado en ${WRAPPER_SCRIPT}"
}

crear_lanzador_desktop() {
    echo -e "\n🖥️  \033[1mCreando acceso directo...\033[0m"
    cat > "${DESKTOP_DIR}/RootQR.desktop" << EOF
[Desktop Entry]
Version=1.0
Name=RootQR
Comment=Generador de códigos QR
Exec=${WRAPPER_SCRIPT}
Icon=${DIR_INSTALACION}/src/assets/icon.png
Terminal=false
Type=Application
Categories=Utility;Development;
StartupWMClass=RootQR
EOF

    chmod +x "${DESKTOP_DIR}/RootQR.desktop"
    registrar_log "Lanzador .desktop creado"
}

# ... (mantener inicializar_bd y mostrar_resumen adaptados para RootQR)

# --- Flujo principal mejorado ---
main() {
    mostrar_banner
    verificar_dependencias_iniciales
    inicializar_directorios
    verificar_instalacion_previa
    detectar_sistema

    # Verificación de libmpv con reintentos
    local intentos=0
    while ! verificar_libmpv; do
        ((intentos++))
        if ((intentos >= 3)); then
            echo -e "\n⚠️  \033[1;33mContinuando sin verificación completa de libmpv\033[0m"
            break
        fi
        sleep 1
    done
    
    echo -e "\n📥 \033[1mInstalando RootQR en:\033[0m \033[1;34m${DIR_INSTALACION}\033[0m"
    
    if ! git clone "${REPO_URL}" "${DIR_INSTALACION}"; then
        echo -e "❌ \033[1;31mError al clonar el repositorio\033[0m"
        exit 1
    fi

    configurar_entorno_python
    crear_directorio_exportaciones
    instalar_comandos
    copiar_scripts
    crear_wrapper_script
    crear_lanzador_desktop
    inicializar_bd
    
    mostrar_resumen
}

main "$@"
