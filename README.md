# RootQR - Generador Avanzado de Códigos QR para Canaima GNU/Linux

![Beta Version](https://img.shields.io/badge/version-0.1.0--beta-yellow) 
![License](https://img.shields.io/badge/license-GPLv3-blue)
![Python](https://img.shields.io/badge/Python-3.8%2B-blue)
![Flet](https://img.shields.io/badge/Framework-Flet-green)

![Logo de RootQR](src/assets/icon.png)

**RootQR** es una solución avanzada para generación y gestión de códigos QR, desarrollada en Python con Flet, diseñada especialmente para Canaima GNU/Linux pero compatible con cualquier distribución Linux.

## 🌟 Características Destacadas

- **Generación avanzada** de códigos QR con metadata estructurada
- **Sistema de plantillas** para configuraciones rápidas
- **Base de datos SQLite** integrada para historial de generaciones
- **Modo claro/oscuro** siguiendo las pautas de Canaima
- **Exportación múltiple** (PNG, SVG, PDF, TXT)
- **100% Software Libre** bajo licencia GPLv3

## 🛠️ Requisitos del Sistema

- **Python 3.8+**
- **Canaima GNU/Linux** (compatible con Debian/Ubuntu y derivados)
- **Dependencias esenciales**:
  ```bash
  sudo apt install libmpv1 python3-venv git
  ```

## 📂 Estructura del Proyecto

| Componente | Ruta por Defecto | Descripción |
|------------|------------------|-------------|
| **Instalación principal** | `~/apps/rootqr/` | Contiene toda la aplicación |
| **Configuración** | `~/.config/rootqr/` | Archivos de configuración y logs |
| **Base de datos** | `~/apps/rootqr/src/database/` | Almacena el historial de QR generados |
| **Exportaciones** | `~/Descargas/rootqr_exports/` | QR generados (configurable) |
| **Lanzador** | `~/.local/share/applications/RootQR.desktop` | Acceso desde el menú |

## 🚀 Instalación Automática

Ejecuta este comando en tu terminal:

```bash
curl -sSL https://raw.githubusercontent.com/jonasreyes/rootqr/main/scripts/install.sh | bash
```

### Instalación Manual
```bash
git clone https://github.com/jonasreyes/rootqr.git ~/apps/rootqr
cd ~/apps/rootqr
./scripts/install.sh
```

## 🔄 Comandos Clave

```bash
# Iniciar aplicación
rootqr

# Actualizar a última versión
rootqr-update

# Ver logs de actividad
rootqr-logs

# Abrir directorio de exportaciones
rootqr-exports

# Desinstalar completamente
rootqr-uninstall
```

## ⚙️ Configuración Avanzada

Edita `~/.config/rootqr/config.ini` para personalizar:

```ini
[preferencias]
tema = auto  # oscuro/claro/auto
formato_exportacion = png  # png/svg/pdf
calidad = alta  # baja/media/alta
ruta_exportaciones = ~/Documentos/mis_qrs

[base_datos]
mantener_historial = si  # si/no
limite_registros = 100
```

## 🗑️ Desinstalación Completa

```bash
# Método recomendado (usa el desinstalador oficial)
rootqr-uninstall

# Método manual (alternativo)
rm -rf ~/apps/rootqr ~/.config/rootqr
sed -i '/# ===== RootQR Config =====/,/# ===== Fin RootQR =====/d' ~/.bashrc ~/.zshrc
rm ~/.local/share/applications/RootQR.desktop
```

## 📊 Almacenamiento y Datos

- **Historial completo**: Base de datos SQLite con metadatos de cada QR generado
- **Exportaciones automáticas**: Guarda en múltiples formatos simultáneamente
- **Sistema de logs**: Registro detallado de actividad en `~/.config/rootqr/logs/`

## 🤝 Contribuir al Proyecto

1. Haz fork del repositorio
2. Crea una rama para tu función (`git checkout -b feature/nueva-funcion`)
3. Haz commit de tus cambios (`git commit -am 'Añade nueva función'`)
4. Haz push a la rama (`git push origin feature/nueva-funcion`)
5. Abre un Pull Request

## 📜 Licencia y Derechos

RootQR se distribuye bajo **GNU General Public License v3.0**. Consulta el archivo [LICENSE](LICENSE) para detalles completos.

## 📞 Soporte y Comunidad

- **Canal Oficial**: [@rootqr_app en Telegram](https://t.me/rootqr_app)
- **Soporte Técnico**: [@jonasroot en Telegram](https://t.me/jonasroot)
- **Reporte de Bugs**: [Issues en GitHub](https://github.com/jonasreyes/rootqr/issues)

---

**"Una herramienta venezolana para la comunidad global de Software Libre"**  
*Desarrollado con ❤️ para Canaima GNU/Linux #PatriaYSoftwareLibre*

![DeepRoot Ecosystem](https://github.com/jonasreyes/deeproot/raw/main/src/assets/images/icons/deeproot_10.png)  
*Parte del ecosistema DeepRoot de herramientas científicas libres*
