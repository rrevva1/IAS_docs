-- Целевая схема БД для ИАС учёта технических средств (по результатам этапа 3 DB_ias.md).
-- PostgreSQL. Запуск: psql -U postgres -f create_target_db.sql (создаёт БД ias_target и схему).

-- CREATE DATABASE ias_target;
-- \c ias_target

BEGIN;

-- Справочник ролей
CREATE TABLE IF NOT EXISTS roles (
    id SERIAL PRIMARY KEY,
    role_name VARCHAR(100)
);

-- Пользователи (ответственные за оборудование)
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(200) NOT NULL,
    position VARCHAR(100),
    department VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(50),
    password VARCHAR(255),
    role_id INTEGER NOT NULL REFERENCES roles(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by_id INTEGER REFERENCES users(id),
    updated_by_id INTEGER REFERENCES users(id),
    is_deleted BOOLEAN DEFAULT FALSE,
    CONSTRAINT chk_users_full_name_not_empty CHECK (length(trim(full_name)) > 0)
);

-- Места размещения
CREATE TABLE IF NOT EXISTS locations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    location_type VARCHAR(50) NOT NULL,
    floor INTEGER,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE,
    CONSTRAINT chk_location_type CHECK (location_type IN ('кабинет', 'склад', 'серверная', 'лаборатория', 'другое'))
);

-- Оборудование (технические средства)
CREATE TABLE IF NOT EXISTS equipment (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    user_id INTEGER REFERENCES users(id),
    location_id INTEGER NOT NULL REFERENCES locations(id),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by_id INTEGER REFERENCES users(id),
    updated_by_id INTEGER REFERENCES users(id),
    is_deleted BOOLEAN DEFAULT FALSE
);

CREATE INDEX idx_equipment_location_deleted ON equipment(location_id, is_deleted);
CREATE INDEX idx_equipment_user_deleted ON equipment(user_id, is_deleted);

-- История изменений оборудования
CREATE TABLE IF NOT EXISTS equip_history (
    id SERIAL PRIMARY KEY,
    equipment_id INTEGER NOT NULL REFERENCES equipment(id),
    changed_by INTEGER REFERENCES users(id),
    change_type VARCHAR(50) NOT NULL,
    old_value TEXT,
    new_value TEXT,
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    comment TEXT
);

CREATE INDEX idx_equip_history_equipment_date ON equip_history(equipment_id, change_date);

-- Справочник типов комплектующих
CREATE TABLE IF NOT EXISTS spr_parts (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    CONSTRAINT chk_spr_parts_name_not_empty CHECK (length(trim(name)) > 0)
);

-- Справочник характеристик
CREATE TABLE IF NOT EXISTS spr_chars (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    measurement_unit VARCHAR(50)
);

-- Значения характеристик по оборудованию
CREATE TABLE IF NOT EXISTS part_char_values (
    id SERIAL PRIMARY KEY,
    equipment_id INTEGER NOT NULL REFERENCES equipment(id),
    part_id INTEGER NOT NULL REFERENCES spr_parts(id),
    char_id INTEGER NOT NULL REFERENCES spr_chars(id),
    value_text TEXT,
    UNIQUE (equipment_id, part_id, char_id)
);

CREATE INDEX idx_part_char_values_equipment ON part_char_values(equipment_id);
CREATE INDEX idx_part_char_values_part_char ON part_char_values(part_id, char_id);

-- Статусы заявок
CREATE TABLE IF NOT EXISTS dic_task_status (
    id SERIAL PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL UNIQUE
);

-- Заявки
CREATE TABLE IF NOT EXISTS tasks (
    id SERIAL PRIMARY KEY,
    status_id INTEGER NOT NULL REFERENCES dic_task_status(id),
    description TEXT NOT NULL,
    user_id INTEGER NOT NULL REFERENCES users(id),
    executor_id INTEGER REFERENCES users(id),
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_time_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    comment TEXT,
    attachments TEXT
);

CREATE INDEX idx_tasks_status_date ON tasks(status_id, date);
CREATE INDEX idx_tasks_executor ON tasks(executor_id);

-- Вложения к заявкам
CREATE TABLE IF NOT EXISTS desk_attachments (
    id SERIAL PRIMARY KEY,
    path VARCHAR(500) NOT NULL,
    name VARCHAR(255) NOT NULL,
    extension VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_desk_attachments_name ON desk_attachments(name);

-- Аудит (опционально)
CREATE TABLE IF NOT EXISTS audit_events (
    id BIGSERIAL PRIMARY KEY,
    action VARCHAR(200) NOT NULL,
    object_type VARCHAR(100) NOT NULL,
    object_id VARCHAR(100) NOT NULL,
    payload JSONB,
    actor_id BIGINT REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    request_id VARCHAR(64),
    ip INET,
    user_agent TEXT
);

CREATE INDEX idx_audit_events_object ON audit_events(object_type, object_id);
CREATE INDEX idx_audit_events_actor ON audit_events(actor_id);
CREATE INDEX idx_audit_events_created ON audit_events(created_at);

COMMENT ON TABLE equipment IS 'Технические средства (АРМ, системные блоки, мониторы и т.д.)';
COMMENT ON TABLE equip_history IS 'История изменений оборудования (перемещение, смена ответственного)';
COMMENT ON TABLE part_char_values IS 'Значения характеристик по оборудованию (ЦП, ОЗУ, диск, монитор и т.д.)';

COMMIT;
