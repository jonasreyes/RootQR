#!/bin/bash
# rootqr_install.sh - Instalador Oficial RootQR v0.1.0
set -eo pipefail

# --- Constantes ---
readonly VERSION="0.1.0"
readonly TELEGRAM_ROOTQR="https://t.me/rootqr_app"
readonly TELEGRAM_CANAIMA="https://t.me/CanaimaGNULinuxOficial"
readonly LOGO_ASCII=$(cat << "EOF"
██████╗  ██████╗  ██████╗ ████████╗ ██████╗ ██████╗ 
██╔══██╗██╔═══██╗██╔═══██╗╚══██╔══╝██╔═══██╗██╔══██╗
██████╔╝██║   ██║██║   ██║   ██║   ██║   ██║██████╔╝
██╔══██╗██║   ██║██║   ██║   ██║   ██║▄▄ ██║██╔══██╗
██║  ██║╚██████╔╝╚██████╔╝   ██║   ╚██████╔╝██║  ██║
╚═╝  ╚═╝ ╚═════╝  ╚═════╝    ╚═╝    ╚══▀▀═╝ ╚═╝  ╚═╝
EOF
)

# --- Configuración inicial ---
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

# --- Funciones principales ---
inicializar_directorios() {
    echo -e "📂 \033[1mConfigurando directorios base...\033[0m"
    mkdir -p "${DIR_APPS}" "${DIR_CONFIG}" "${DIR_LOGS}" "${DESKTOP_DIR}"
}

mostrar_banner() {
    clear
    echo -e "\033[1;34m${LOGO_ASCII}\033[0m"
    echo -e "\033[1mRootQR v${VERSION}\033[0m - Instalador"
    echo -e "══════════════════════════════════════════"
}

registrar_log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "${ARCHIVO_LOG}"
}

verificar_instalacion_previa() {
    if [[ -d "${DIR_INSTALACION}/.git" ]]; then
        registrar_log "Instalación previa detectada en ${DIR_INSTALACION}"
        echo -e "\n⚠️  \033[1;33mATENCIÓN:\033[0m Ya existe una instalación de RootQR."
        
        read -rp "¿Deseas actualizar la instalación existente? [S/n]: " respuesta
        if [[ "${respuesta,,}" =~ ^(n|no)$ ]]; then
            registrar_log "Usuario eligió no actualizar"
            echo -e "\n❌ Operación cancelada por el usuario."
            exit 0
        fi

        if [ "$(ls -A ${DIR_INSTALACION})" ]; then
            echo -e "\n🔍 \033[1mContenido existente en el directorio:\033[0m"
            ls -la "${DIR_INSTALACION}"
            
            read -rp "¿Deseas borrar el contenido existente antes de instalar? [s/N]: " respuesta_borrar
            if [[ "${respuesta_borrar,,}" =~ ^(s|si|y|yes)$ ]]; then
                echo -e "🗑️  \033[1;31mLimpiando directorio...\033[0m"
                rm -rf "${DIR_INSTALACION:?}/"*
                registrar_log "Directorio de instalación limpiado"
            else
                echo -e "❌ \033[1;31mInstalación abortada. Directorio no vacío.\033[0m"
                exit 1
            fi
        fi
        
        registrar_log "Iniciando actualización..."
        actualizar_aplicacion
        exit 0
    fi
}

actualizar_aplicacion() {
    echo -e "\n🔄 \033[1mActualizando RootQR...\033[0m"
    (cd "${DIR_INSTALACION}" && git stash push -u -m "Antes de actualizar" && git pull && source .venv/bin/activate && pip install --upgrade pip && pip install -U -r requirements.txt && git stash pop)
    echo -e "✅ \033[1;32mActualización completada\033[0m"
}

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

verificar_libmpv() {
    echo -e "\n🔍 \033[1mVerificando libmpv.so.1...\033[0m"
    registrar_log "Buscando libmpv.so.1"

    local rutas_busqueda=(
        "/usr/lib"
        "/usr/lib64"
        "/usr/lib/x86_64-linux-gnu"
        "/usr/local/lib"
        "/usr/local/lib64"
        "/opt/lib"
        "/opt/lib64"
    )

    local ruta_libmpv=""
    local ruta_libmpv_alternativa=""

    for ruta in "${rutas_busqueda[@]}"; do
        if [[ -f "${ruta}/libmpv.so.1" ]]; then
            ruta_libmpv="${ruta}/libmpv.so.1"
            break
        elif [[ -f "${ruta}/libmpv.so.2" ]]; then
            ruta_libmpv_alternativa="${ruta}/libmpv.so.2"
        elif [[ -f "${ruta}/libmpv.so" ]]; then
            ruta_libmpv_alternativa="${ruta}/libmpv.so"
        fi
    done

    if [[ -n "${ruta_libmpv}" ]]; then
        echo -e "✅ \033[1;32mVersión correcta encontrada:\033[0m ${ruta_libmpv}"
        registrar_log "libmpv.so.1 encontrado en ${ruta_libmpv}"
        return 0
    elif [[ -n "${ruta_libmpv_alternativa}" ]]; then
        echo -e "⚠️ \033[1;33mSe encontró una versión diferente de libmpv:\033[0m ${ruta_libmpv_alternativa}"
        echo -e "\nPara crear el enlace simbólico necesario, copia y pega la siguiente instrucción:"
        echo -e "\033[1msudo ln -s \"${ruta_libmpv_alternativa}\" \"${ruta_libmpv_alternativa%/*}/libmpv.so.1\"\033[0m"
        registrar_log "Encontrada versión alternativa de libmpv: ${ruta_libmpv_alternativa}"
        return 1
    else
        echo -e "❌ \033[1;31mNo se encontró libmpv.so.1 en el sistema\033[0m"
        registrar_log "No se encontró libmpv.so.1 en el sistema"
        mostrar_ayuda_libmpv
        return 1
    fi
}

configurar_entorno_python() {
    registrar_log "Configurando entorno Python..."
    echo -e "\n🐍 \033[1mCreando entorno virtual en .venv...\033[0m"
    if ! python3 -m venv "${DIR_INSTALACION}/.venv"; then
        echo -e "\n❌ \033[1;31mError al crear el entorno virtual. Intenta instalar python3-venv.\033[0m"
        exit 1
    fi
    source "${DIR_INSTALACION}/.venv/bin/activate"
    
    echo -e "\n🔄 \033[1mActualizando pip...\033[0m"
    pip install --upgrade pip
    registrar_log "Pip actualizado a versión: $(pip --version | cut -d' ' -f2)"
    
    echo -e "\n📦 \033[1mInstalando dependencias de RootQR...\033[0m"
    pip install 'flet[desktop-light]' 'qrcode[pil]' || {
        echo -e "\n❌ \033[1;31mError al instalar dependencias. Revisa el archivo de registro para más detalles.\033[0m"
        exit 1
    }
    registrar_log "Dependencias instaladas: flet[desktop-light], qrcode[pil]"
}

crear_directorio_exportaciones() {
    echo -e "\n📂 \033[1mConfigurando directorio de exportaciones...\033[0m"
    
    if [ -d "${HOME}/Descargas" ]; then
        DIR_EXPORTACIONES="${HOME}/Descargas/rootqr_exportaciones"
    elif [ -d "${HOME}/Downloads" ]; then
        DIR_EXPORTACIONES="${HOME}/Downloads/rootqr_exportaciones"
    else
        read -p "¿Dónde quieres que se creen las exportaciones? (ruta completa): " DIR_EXPORTACIONES
        if [[ -z "${DIR_EXPORTACIONES}" ]]; then
            DIR_EXPORTACIONES="${HOME}/rootqr_exportaciones"
        fi
    fi

    mkdir -p "${DIR_EXPORTACIONES}"
    chmod 755 "${DIR_EXPORTACIONES}"
    
    echo -e "  ▸ Ruta: \033[1;34m${DIR_EXPORTACIONES}\033[0m"
    registrar_log "Directorio de exportaciones creado en ${DIR_EXPORTACIONES}"
}

instalar_comandos() {
    registrar_log "Configurando comandos..."
    
    cat > "${DIR_INSTALACION}/.rootqr_env" << EOF
# Configuración RootQR
export ROOT_QR_INSTALL_DIR="${DIR_INSTALACION}"
export ROOT_QR_CONFIG_DIR="${DIR_CONFIG}"
export ROOT_QR_EXPORT_DIR="${DIR_EXPORTACIONES}"
EOF

    for shell_file in ".bashrc" ".zshrc"; do
        if [[ -f "${HOME}/${shell_file}" ]]; then
            sed -i '/# ===== RootQR Config =====/,/# ===== Fin RootQR =====/d' "${HOME}/${shell_file}"
            
            cat >> "${HOME}/${shell_file}" << EOF

# ===== RootQR Config =====
if [ -f "${DIR_INSTALACION}/.rootqr_env" ]; then
    source "${DIR_INSTALACION}/.rootqr_env"
fi

alias rootqr='(cd "\${ROOT_QR_INSTALL_DIR}" && nohup ./.venv/bin/python src/main.py >/dev/null 2>&1 &)'
alias rootqr-update='(cd "\${ROOT_QR_INSTALL_DIR}" && git pull && ./.venv/bin/pip install --upgrade pip && ./.venv/bin/pip install -U -r requirements.txt)'
alias rootqr-uninstall='"\${ROOT_QR_INSTALL_DIR}/scripts/rootqr_uninstall.sh"'
alias rootqr-logs='ls -lh "\${ROOT_QR_CONFIG_DIR}/logs"'
alias rootqr-exports='cd "\${ROOT_QR_EXPORT_DIR}" && ls -lh'
# ===== Fin RootQR =====
EOF
            registrar_log "Comandos configurados en ${HOME}/${shell_file}"
        fi
    done
}

copiar_scripts() {
    registrar_log "Configurando script de desinstalación..."
    mkdir -p "${DIR_SCRIPTS}"
    
    curl -sSL https://raw.githubusercontent.com/jonasreyes/rootqr/main/scripts/rootqr_uninstall.sh \
         -o "${DIR_SCRIPTS}/rootqr_uninstall.sh"
    chmod +x "${DIR_SCRIPTS}/rootqr_uninstall.sh"
}

crear_wrapper_script() {
    echo -e "\n📜 \033[1mCreando wrapper de ejecución...\033[0m"
    cat > "${WRAPPER_SCRIPT}" <<EOL
#!/bin/bash
cd "${DIR_INSTALACION}"
source .venv/bin/activate
python src/main.py
EOL
    chmod +x "${WRAPPER_SCRIPT}"
    registrar_log "Wrapper script creado en ${WRAPPER_SCRIPT}"
}

crear_lanzador_desktop() {
    echo -e "\n🖥️  \033[1mCreando acceso directo...\033[0m"
    cat > "${DESKTOP_DIR}/RootQR.desktop" <<EOL
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
EOL
    chmod +x "${DESKTOP_DIR}/RootQR.desktop"
    registrar_log "Lanzador .desktop creado en ${DESKTOP_DIR}/RootQR.desktop"
}

inicializar_bd() {
    echo -e "\n🗄️  \033[1mInicializando base de datos...\033[0m"
    mkdir -p "${DIR_INSTALACION}/src/database"
    (cd "${DIR_INSTALACION}" && python3 -c "from src.database import init_db; init_db()")
    registrar_log "Base de datos inicializada"
}

mostrar_resumen() {
    echo -e "\n══════════════════════════════════════════"
    echo -e "✅ \033[1;32mINSTALACIÓN COMPLETADA\033[0m ✅"
    echo -e "══════════════════════════════════════════"
    
    echo -e "\n\033[1m📂 Estructura de directorios:\033[0m"
    echo -e "  ▸ \033[34m${DIR_INSTALACION}\033[0m (instalación)"
    echo -e "  ▸ \033[34m${DIR_EXPORTACIONES}\033[0m (exportaciones)"
    echo -e "  ▸ \033[34m${DIR_CONFIG}\033[0m (configuración)"
    
    echo -e "\n\033[1m🐍 Entorno Python:\033[0m"
    echo -e "  ▸ Ruta: \033[34m${DIR_INSTALACION}/.venv\033[0m"
    echo -e "  ▸ Versión pip: \033[34m$(pip --version | cut -d' ' -f2)\033[0m"
    
    echo -e "\n\033[1m🚀 Comandos disponibles:\033[0m"
    echo -e "  ▸ \033[1mrootqr\033[0m       - Inicia la aplicación"
    echo -e "  ▸ \033[1mrootqr-update\033[0m - Actualiza RootQR"
    echo -e "  ▸ \033[1mrootqr-uninstall\033[0m - Desinstala RootQR"
    echo -e "  ▸ \033[1mrootqr-logs\033[0m  - Muestra los registros"
    echo -e "  ▸ \033[1mrootqr-exports\033[0m - Accede a exportaciones"
    
    echo -e "\n\033[1m🖥️  Acceso directo:\033[0m"
    echo -e "  ▸ Se ha creado un lanzador en el menú de aplicaciones"
    
    echo -e "\n\033[1m📢 Canales oficiales:\033[0m"
    echo -e "  ▸ RootQR: ${TELEGRAM_ROOTQR}"
    echo -e "  ▸ Canaima GNU/Linux: ${TELEGRAM_CANAIMA}"
    
    registrar_log "Instalación completada exitosamente"
}

# --- Flujo principal ---
main() {
    mostrar_banner
    inicializar_directorios
    verificar_instalacion_previa
    detectar_sistema

    while true; do
        if verificar_libmpv; then
            break
        else
            read -p "¿Intentar de nuevo la verificación de libmpv? [s/N]: " respuesta
            if [[ "${respuesta,,}" =~ ^(n|no)$ ]]; then
                echo -e "\n\033[1;33mADVERTENCIA: RootQR podría no funcionar correctamente sin libmpv.so.1\033[0m"
                echo -e "Continuando sin verificar libmpv."
                break
            fi
        fi
    done
    
    echo -e "\n📥 \033[1mInstalando RootQR en:\033[0m \033[1;34m${DIR_INSTALACION}\033[0m"
    registrar_log "Iniciando instalación en ${DIR_INSTALACION}"
    
    git clone https://github.com/jonasreyes/rootqr.git "${DIR_INSTALACION}" || {
        echo -e "❌ \033[1;31mError al clonar el repositorio\033[0m"
        exit 1
    }

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
