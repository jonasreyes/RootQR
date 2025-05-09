#!/bin/bash
# rootqr-wrapper.sh - Wrapper de ejecución para RootQR

# Configuración básica
APP_DIR="$(dirname "$(realpath "$0")")"
VENV_DIR="${APP_DIR}/.venv"
MAIN_SCRIPT="${APP_DIR}/src/main.py"
LOG_DIR="${HOME}/.config/rootqr/logs"
LOG_FILE="${LOG_DIR}/rootqr_$(date +%Y%m%d_%H%M%S).log"

# Crear directorio de logs si no existe
mkdir -p "${LOG_DIR}"

# Verificar existencia del entorno virtual
if [[ ! -d "${VENV_DIR}" ]]; then
    notify-send "RootQR Error" "No se encontró el entorno virtual en ${VENV_DIR}"
    exit 1
fi

# Verificar script principal
if [[ ! -f "${MAIN_SCRIPT}" ]]; then
    notify-send "RootQR Error" "No se encontró el script principal en ${MAIN_SCRIPT}"
    exit 1
fi

# Ejecutar la aplicación
echo "Iniciando RootQR - $(date)" >> "${LOG_FILE}"
{
    cd "${APP_DIR}" || exit 1
    source "${VENV_DIR}/bin/activate"
    python3 "${MAIN_SCRIPT}" 2>&1
} >> "${LOG_FILE}" 2>&1 &

# Notificación de inicio (opcional)
if command -v notify-send &> /dev/null; then
    notify-send "RootQR" "Aplicación iniciada correctamente" --icon="${APP_DIR}/src/assets/icon.png"
fi

exit 0
