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
