"""
RootQR - Generador de códigos QR para Canaima GNU/Linux
Copyright (C) 2024  Jonás Antonio Reyes Casanova

Este programa es software libre: usted puede redistribuirlo y/o modificarlo
bajo los términos de la GNU General Public License publicada por
la Free Software Foundation, ya sea la versión 3 de la Licencia, o
(a su elección) cualquier versión posterior.

Este programa se distribuye con la esperanza de que sea útil,
pero SIN NINGUNA GARANTÍA; incluso sin la garantía implícita de
COMERCIALIZACIÓN o IDONEIDAD PARA UN PROPÓSITO PARTICULAR. Vea la
GNU General Public License para más detalles.

Debería haber recibido una copia de la GNU General Public License
junto con este programa. Si no es así, visite <https://www.gnu.org/licenses/>.

Contacto: Jonás Antonio Reyes Casanova <t.me/jonasroot>
Repositorio: https://github.com/jonasreyes/rootqr.git
"""

__author__ = "Jonás Antonio Reyes Casanova"
__copyright__ = "Copyright 2024, RootQR"
__license__ = "GPLv3"
__version__ = "0.1.0"
__maintainer__ = "Jonás Antonio Reyes Casanova"
__email__ = "jonasreyes@yandex.com"  
__status__ = "En desarrollo"

import flet as ft
from database import init_db, save_qr, get_all_qrs
import os
from pathlib import Path
from datetime import datetime
import qrcode
import base64
from PIL import Image
import io

QR_OUTPUT_DIR = "src/assets/generated_qrs"
Path(QR_OUTPUT_DIR).mkdir(parents=True, exist_ok=True) # Crea la carpeta si no existe
def main(page: ft.Page):
    page.title = "Generador de QR"
    page.theme_mode = ft.ThemeMode.LIGHT
    page.vertical_alignment = ft.MainAxisAlignment.CENTER
    page.horizontal_alignment = ft.CrossAxisAlignment.CENTER
    page.padding = 30

    # Inicializando la DB
    init_db()

    # Variables de estado
    qr_image = ft.Image(src_base64="iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=", width=200, height=200)
    content_input = ft.TextField(label="Texto/URL")
    color_picker = ft.Dropdown(
        label="Color",
        hint_text="Selecciona el color preferido para el QR.",
        options=[
            ft.dropdown.Option("#000000", "Negro"),
            ft.dropdown.Option("#A6D8E2", "Azul Cielo Futuro"),
            ft.dropdown.Option("#1440AD", "Azul Futuro"),
            ft.dropdown.Option("#1D70B7", "Azul Mincyt"),
            ft.dropdown.Option("#F8EFDC", "Beige Futuro"),
            ft.dropdown.Option("#EFC318", "Dorado Futuro"),
            ft.dropdown.Option("#9C9B9B", "Gris Mincyt"),
            ft.dropdown.Option("#653188", "Morado Mincyt"),
            ft.dropdown.Option("#EC6C3A", "Naranja Futuro"),
            ft.dropdown.Option("#F08427", "Naranja Mincyt"),
            ft.dropdown.Option("#000000", "Negro"),
            ft.dropdown.Option("#1F1E1E", "Negro Futuro"),
            ft.dropdown.Option("#E63022", "Rojo Futuro"),
            ft.dropdown.Option("#02A7AB", "Té Mincyt"),
            ft.dropdown.Option("#08714D", "Verde Futuro"),
            ft.dropdown.Option("#026E71", "Verde Mincyt"),
        ]
    )
    logo_path = None

    def generate_qr(e):
        global logo_path
        if not content_input.value:
            page.open(ft.SnackBar(ft.Text("¡Ingresa un texto o URL!")))
            page.update()
            return

        qr = qrcode.QRCode(version=1, box_size=10, border=4)
        qr.add_data(content_input.value)
        qr.make(fit=True)
        img = qr.make_image(fill_color=color_picker.value, back_color="white")

        # Añadir el logo si existe
        if logo_path:
            try:
                logo = Image.open(logo_path)

                # Redimensionamos el logo si fuese muy grande
                qr_size = img.size[0]
                max_logo_size = qr_size // 5
                if logo.size[0] > max_logo_size or logo.size[1] > max_logo_size:
                    logo.thumbnail((max_logo_size, max_logo_size))

                # Incrustramos el logo
                img = img.convert("RGB")

                pos = (
                    (img.size[0] - logo.size[0]) // 2,
                    (img.size[1] - logo.size[1]) // 2
                )
                img.paste(logo, pos)

            except Exception as ex:
                page.open(ft.SnackBar(ft.Text(f"Error al procesar logo: {str(ex)}")))
                page.update()

        # Convertir a bytes para Flet y Notificar sitio de almacenamiento
        img_byte_arr = io.BytesIO()
        img.save(img_byte_arr, format='PNG')
        qr_image.src_base64 = base64.b64encode(img_byte_arr.getvalue()).decode("utf-8")
        file_path = download_qr(qr_image.src_base64)
        # Guardar en la BD
        save_qr(content_input.value, color_picker.value, logo_path)
        page.open(ft.SnackBar(ft.Text(f"QR guardado en: /generated_qrs/{os.path.basename(file_path)}")))
        page.update()

    def pick_logo(e: ft.FilePickerResultEvent):
        global logo_path
        if e.files and e.files[0].path:
            logo_path = e.files[0].path
            page.open(ft.SnackBar(ft.Text(f"Logo seleccionado: {os.path.basename(logo_path)}")))
            page.update()

    def download_qr(qr_image_base64: str) -> str:
        # Nombre del archivo con timestamp
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        file_name = f"qr_{timestamp}.png"
        file_path = os.path.join(QR_OUTPUT_DIR, file_name)

        # Decodificar y Guardar
        img_data = base64.b64decode(qr_image_base64)
        with open(file_path, "wb") as f:
            f.write(img_data)

        return file_path # Por ejemplo: "src/assets/generated_qrs/qr_20250331_143022.png"


    file_picker = ft.FilePicker(on_result=pick_logo)
    page.overlay.append(file_picker)

    # Interfáz
    page.add(
        ft.Column(
            [
                ft.Text("Generador de QR", size=24, weight=ft.FontWeight.BOLD, text_align=ft.TextAlign.CENTER,),
                content_input,
                color_picker,
                ft.Row(
                    [
                        ft.ElevatedButton("Generar QR", on_click=generate_qr),
                        ft.ElevatedButton("Seleccionar Logo", on_click=lambda _: file_picker.pick_files()),
                    ],
                    alignment = ft.MainAxisAlignment.CENTER,
                ),
                qr_image,
            ],
            spacing=20,
            horizontal_alignment=ft.CrossAxisAlignment.CENTER,
        )
    )

ft.app(target=main)
