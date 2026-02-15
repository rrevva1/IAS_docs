#!/bin/bash
set -e
# Убираем строку \restrict из дампа (нестандартная команда psql) и применяем дамп
sed '/^\\restrict/d' /docker-entrypoint-initdb.d/dump.sql.skip | psql -v ON_ERROR_STOP=1 -U postgres -d "${POSTGRES_DB:-ias_vniic}"
