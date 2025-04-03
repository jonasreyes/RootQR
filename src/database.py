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

import sqlite3
from datetime import datetime

path_db = "./src/database/qr_database.db"
def init_db():
    conn = sqlite3.connect(path_db)
    cursor = conn.cursor()
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS qr_codes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content TEXT NOT NULL,
        color TEXT DEFAULT '#000000',
        logo_path TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
    """)
    conn.commit()
    conn.close()

def save_qr(content, color, logo_path=None):
    conn = sqlite3.connect(path_db)
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO qr_codes (content, color, logo_path) VALUES (?, ?, ?)",
        (content, color, logo_path)
    )
    conn.commit()
    conn.close()

def get_all_qrs():
    conn = sqlite3.connect("qr_database.db")
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM qr_codes ORDER BY created_at DESC")
    qrs = cursor.fetchall()
    conn.close()
    return qrs
