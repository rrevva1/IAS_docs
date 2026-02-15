# Запуск проекта ИАС УТС ВНИИЦ в Docker

Вся конфигурация Docker сосредоточена в этой папке. Запуск даёт одинаковое окружение на любой ОС (Windows, macOS, Linux).

## Требования

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Windows/macOS) или Docker Engine + Docker Compose (Linux)
- Клонированный репозиторий с каталогами `ias_uch_vnii` и `db` на уровень выше этой папки

## Первый запуск на новой машине

1. Перейдите в папку **docker** (от корня проекта: `cd docker`).

2. При необходимости задайте свои параметры (пароль БД, порты):
   ```bash
   cp .env.example .env
   # Отредактируйте .env при необходимости
   ```

3. Запустите контейнеры:
   ```bash
   docker compose up -d
   ```
   При первом запуске БД инициализируется из дампа `../db/ias_vniic_14_02_26.sql` (1–2 минуты).

4. Установите зависимости PHP (один раз на новой машине):
   ```bash
   docker compose exec php composer install --no-interaction -d /app
   ```

5. Создайте первого пользователя (admin / admin123):
   ```bash
   docker compose exec php php /app/yii migrate --migrationPath=@app/migrations --interactive=0
   ```

6. При необходимости скопируйте AG Grid в веб-каталог (если в проекте используется):
   ```bash
   docker compose exec php sh -c 'cd /app && npm install && cp -r node_modules/ag-grid-community web/ag-grid-community' 2>/dev/null || true
   ```
   Если Node.js в образе нет — выполните `npm install` и `cp -r node_modules/ag-grid-community web/ag-grid-community` на хосте в каталоге `ias_uch_vnii`.

7. Откройте в браузере: **http://localhost:8000** (или другой порт из `APP_PORT` в `.env`).

## Обычный запуск (уже настроено)

```bash
cd docker
docker compose up -d
```

Приложение: **http://localhost:8000**

## Остановка

```bash
cd docker
docker compose down
```

Данные БД хранятся в томе Docker и сохраняются между запусками.

## Полезные команды

| Действие              | Команда |
|-----------------------|--------|
| Логи                  | `docker compose logs -f` |
| Логи только БД        | `docker compose logs -f db` |
| Войти в контейнер PHP | `docker compose exec php bash` |
| Миграции              | `docker compose exec php php /app/yii migrate --migrationPath=@app/migrations` |

## Структура папки docker

- `docker-compose.yml` — описание сервисов (БД, приложение)
- `.env.example` — пример переменных окружения (скопировать в `.env`)
- `init/01-init.sh` — скрипт инициализации БД из дампа
- `README.md` — эта инструкция

Переменные окружения (в т.ч. из `.env`) передаются в контейнеры; приложение читает их в `ias_uch_vnii/config/db.php` и подключается к контейнеру БД по имени сервиса `db`.
