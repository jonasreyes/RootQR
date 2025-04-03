# RootQR - Generador de códigos QR para Canaima GNU/Linux

![Logo de RootQR](src/assets/icon.png)

**RootQR** es una aplicación sencilla pero potente para generar códigos QR personalizados, desarrollada en Python con Flet. Diseñada específicamente para Canaima GNU/Linux, forma parte de un conjunto de herramientas de autoría nacional para la comunidad de software libre.

## ✨ Características principales

- Generación de códigos QR con logotipos incrustrados
- Personalización básica de colores del QR
- Interfaz intuitiva y fácil de usar
- Almacenamiento local de códigos generados
- 100% software libre bajo licencia GPLv3

## 🚀 Instalación

Para instalar RootQR en tu sistema Canaima GNU/Linux:

```bash
wget https://raw.githubusercontent.com/jonasreyes/rootqr/main/install_rootqr.sh
chmod +x install_rootqr.sh
./install_rootqr.sh
```

## 🗑️ Desinstalación

Para eliminar RootQR de tu sistema:

```bash
wget https://raw.githubusercontent.com/jonasreyes/rootqr/main/uninstall_rootqr.sh
chmod +x uninstall_rootqr.sh
./uninstall_rootqr.sh
```

## 📦 Estructura del proyecto

```
RootQR/
├── install_rootqr.sh    # Script de instalación
├── LICENSE              # Licencia GPLv3
├── pyproject.toml       # Configuración del proyecto
├── src/                 # Código fuente
│   ├── assets/          # Recursos gráficos
│   ├── database/        # Base de datos SQLite
│   └── main.py          # Aplicación principal
└── uninstall_rootqr.sh  # Script de desinstalación
```

## 📄 Licencia

RootQR se distribuye bajo la **GNU General Public License v3.0**. Consulta el archivo [LICENSE](LICENSE) para más detalles.

## 🤝 Contribuciones

¡Contribuciones son bienvenidas! Visita nuestro [repositorio en GitHub](https://github.com/jonasreyes/rootqr.git) para reportar issues o enviar pull requests.

---

*RootQR - Una herramienta venezolana 100% compatible con Canaima GNU/Linux*
