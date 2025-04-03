# RootQR - Generador de códigos QR para Canaima GNU/Linux

![Beta Version](https://img.shields.io/badge/version-0.1.0--beta-yellow) ![License](https://img.shields.io/badge/license-GPLv3-blue)

![Logo de RootQR](src/assets/icon.png)

**RootQR** es una aplicación desarrollada en Python con Flet para generar códigos QR personalizados, diseñada especialmente para Canaima GNU/Linux.

## 📂 Estructura de instalación

La aplicación se instala en las siguientes ubicaciones:

| Componente | Ruta |
|------------|------|
| **Instalación principal** | `/opt/RootQR/` |
| **Ejecutable** | `/usr/local/bin/rootqr` |
| **Acceso directo** | `~/.local/share/applications/RootQR.desktop` |
| **Configuración** | `~/.config/RootQR/` |
| **Base de datos** | `/opt/RootQR/src/database/qr_database.db` |
| **QRs generados** | `/opt/RootQR/src/assets/generated_qrs/` |
| **Logos/Assets** | `/opt/RootQR/src/assets/` |

## 🚀 Instalación con un solo comando

```bash
curl -sSL https://raw.githubusercontent.com/jonasreyes/rootqr/main/install_rootqr.sh | bash
```

## 🗑️ Desinstalación

```bash
curl -sSL https://raw.githubusercontent.com/jonasreyes/rootqr/main/uninstall_rootqr.sh | bash
```

## 💾 Almacenamiento de datos

- **Códigos QR generados**: Se guardan automáticamente en `/opt/RootQR/src/assets/generated_qrs/` con formato `qr_[TIMESTAMP].png`
- **Historial**: Se almacena en la base de datos SQLite en `/opt/RootQR/src/database/qr_database.db`

## 🖼️ Directorio de assets

| Archivo | Propósito |
|---------|-----------|
| `icon.png` | Icono de la aplicación |
| `splash_android.png` | Imagen de inicio (para futura versión móvil) |
| `generated_qrs/` | Contiene todos los códigos QR generados |

## 🛠️ Requisitos

- Python 3.8+
- Canaima GNU/Linux (compatible con otras distros basadas en Debian)
- Dependencias: `flet`, `qrcode`, `pillow`

## 📄 Licencia

Distribuido bajo la **GNU GPLv3**. Ver [LICENSE](LICENSE) para más detalles.

---

**Repositorio oficial**: [github.com/jonasreyes/rootqr](https://github.com/jonasreyes/rootqr.git)  
**Contacto**: [t.me/jonasroot](https://t.me/jonasroot)

*Una herramienta venezolana para la comunidad de software libre*
