# -*- coding: utf-8 -*-
"""
Шаблон загрузки данных из файла «Основной Учет.xlsx» в БД ias_vnii_db.

Перед запуском:
  1. pip install pandas openpyxl psycopg2-binary
  2. Заполнить CONNECTION_STRING (postgres/12345, ias_vnii_db).
  3. Указать путь к Excel и имена листов/столбцов в конфигурации ниже.
  4. При необходимости сопоставить имена столбцов Excel с полями БД.
"""

import os
import sys
from pathlib import Path

import pandas as pd
import psycopg2
from psycopg2.extras import execute_values

# -----------------------------------------------------------------------------
# Конфигурация (подставьте свои значения)
# -----------------------------------------------------------------------------
CONNECTION_STRING = "host=localhost port=5432 dbname=ias_vnii_db user=postgres password=12345"
# Путь к файлу «Основной Учет.xlsx» (относительно корня проекта или абсолютный)
PROJECT_ROOT = Path(__file__).resolve().parent.parent
EXCEL_PATH = PROJECT_ROOT / "Основной Учет.xlsx"

# Лист «АРМ» в «Основной Учет.xlsx»: диапазон A1:W792, 23 столбца.
# Детальная структура и неатомарные ячейки (Диск, Монитор, ОЗУ, IP): см. docs/СТРУКТУРА_ЛИСТА_АРМ_ОСНОВНОЙ_УЧЕТ.md
SHEET_EQUIPMENT = "АРМ"  # имя листа (или 0 по индексу)
COLUMN_MAP = {
    "name": "Инв. Номер",             # или "Наименование", "№ системн. блока" — приоритет инв. номеру
    "location": "Помещение",          # кабинет/локация (в файле: "Помещение", "к. 505" и т.д.)
    "responsible": "Пользователь",    # ФИО для сопоставления с users.full_name
    "description": "Примечание",      # опционально; неатомарные столбцы (Диск, Монитор) можно добавлять в описание
}

# -----------------------------------------------------------------------------
# Загрузка Excel
# -----------------------------------------------------------------------------
def load_excel(path: Path, sheet=0) -> pd.DataFrame:
    """Читает лист из Excel."""
    if not path.exists():
        raise FileNotFoundError(f"Файл не найден: {path}")
    df = pd.read_excel(path, sheet_name=sheet, engine="openpyxl")
    df = df.rename(columns=lambda c: (c or "").strip())
    return df


def find_column(df: pd.DataFrame, possible_names: list) -> str | None:
    """Возвращает имя столбца из df, если он совпадает с одним из possible_names."""
    for name in possible_names:
        if name in df.columns:
            return name
    return None


# -----------------------------------------------------------------------------
# Работа с БД
# -----------------------------------------------------------------------------
def get_connection():
    return psycopg2.connect(CONNECTION_STRING)


def ensure_locations(conn, names: set) -> dict:
    """Возвращает словарь name -> id для locations; при необходимости создаёт записи."""
    cur = conn.cursor()
    cur.execute("SELECT id, name FROM locations")
    existing = {row[1]: row[0] for row in cur.fetchall()}
    result = dict(existing)
    for name in names:
        name = (name or "").strip()
        if not name or name in result:
            continue
        cur.execute(
            "INSERT INTO locations (name, location_type, floor, description) VALUES (%s, %s, %s, %s) RETURNING id",
            (name, "кабинет", None, None),
        )
        result[name] = cur.fetchone()[0]
    conn.commit()
    cur.close()
    return result


def ensure_users_by_name(conn) -> dict:
    """Возвращает словарь full_name -> id для users."""
    cur = conn.cursor()
    cur.execute("SELECT id, full_name FROM users")
    return {row[1].strip(): row[0] for row in cur.fetchall() if row[1]}


def insert_equipment(conn, rows: list[dict], location_by_name: dict, user_by_name: dict) -> int:
    """Вставляет записи в equipment. Возвращает количество вставленных строк."""
    cur = conn.cursor()
    role_id = 1  # по умолчанию; при необходимости взять из roles
    data = []
    for r in rows:
        name = (r.get("name") or "").strip()
        if not name:
            continue
        loc_name = (r.get("location") or "").strip()
        resp_name = (r.get("responsible") or "").strip()
        location_id = location_by_name.get(loc_name) if loc_name else None
        user_id = user_by_name.get(resp_name) if resp_name else None
        if not location_id and loc_name:
            continue  # или создать локацию; здесь пропускаем
        description = (r.get("description") or "")[:500] if r.get("description") else None
        data.append((name, user_id, location_id, description))
    if not data:
        cur.close()
        return 0
    execute_values(
        cur,
        """INSERT INTO equipment (name, user_id, location_id, description)
           VALUES %s""",
        data,
        template="(%s, %s, %s, %s)",
    )
    conn.commit()
    count = cur.rowcount
    cur.close()
    return count


# -----------------------------------------------------------------------------
# Точка входа
# -----------------------------------------------------------------------------
def main():
    if not EXCEL_PATH.exists():
        print(f"Файл не найден: {EXCEL_PATH}")
        print("Укажите EXCEL_PATH в скрипте и убедитесь, что файл «Основной Учет.xlsx» на месте.")
        sys.exit(1)

    df = load_excel(EXCEL_PATH, SHEET_EQUIPMENT)
    print(f"Прочитано строк (с заголовком): {len(df) + 1}, столбцов: {len(df.columns)}")
    print("Столбцы:", list(df.columns))

    # Маппинг: поле БД -> имя столбца в Excel
    col_name = find_column(df, [COLUMN_MAP["name"], "Наименование", "Инв. номер", "АРМ", "name"])
    col_location = find_column(df, [COLUMN_MAP["location"], "Кабинет", "Локация", "Помещение"])
    col_resp = find_column(df, [COLUMN_MAP["responsible"], "Ответственный", "ФИО"])
    col_desc = find_column(df, [COLUMN_MAP["description"], "Примечание", "Описание"])

    if not col_name:
        print("Не найден столбец с наименованием/инв. номером. Задайте COLUMN_MAP по фактическим именам столбцов.")
        sys.exit(1)

    rows = []
    for _, row in df.iterrows():
        rows.append({
            "name": row.get(col_name) if col_name else None,
            "location": row.get(col_location) if col_location else None,
            "responsible": row.get(col_resp) if col_resp else None,
            "description": row.get(col_desc) if col_desc else None,
        })

    conn = get_connection()
    try:
        location_names = {r["location"] for r in rows if r.get("location")}
        location_by_name = ensure_locations(conn, location_names)
        user_by_name = ensure_users_by_name(conn)
        count = insert_equipment(conn, rows, location_by_name, user_by_name)
        print(f"Добавлено записей в equipment: {count}")
    finally:
        conn.close()


if __name__ == "__main__":
    main()
