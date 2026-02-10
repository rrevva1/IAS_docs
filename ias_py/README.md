# IAS (перенос на Python/Django)

Эта папка содержит **новый проект переноса** IAS на Python/Django и **артефакты миграции**.

Важно:
- Исходный PHP/Yii2 проект **не трогаем и не удаляем**.
- Здесь ведём отдельную документацию и подготовку переноса.

---

# Руководство по изучению Python и Django

Этот раздел написан для тех, кто не знаком с Python и Django. Здесь вы найдёте объяснения основных терминов, структуру проекта и пошаговое руководство.

---

## Часть 1: Кратко о Python

### Что такое Python?

**Python** — язык программирования с простым и читаемым синтаксисом. Он хорошо подходит для:
- веб-приложений
- автоматизации
- анализа данных
- скриптов

### Основные особенности Python

| Понятие | Описание |
|---------|----------|
| **Интерпретируемый** | Код выполняется построчно, без отдельной компиляции |
| **Динамическая типизация** | Тип переменной определяется при присваивании |
| **Отступы** | Важны! Используются для обозначения блоков кода (обычно 4 пробела) |
| **Модули** | Код организуется в файлы (`.py`), которые можно импортировать |

### Пример кода Python

```python
# Комментарий в Python начинается с #
name = "Пользователь"          # строка
count = 42                     # число
items = [1, 2, 3]             # список

def greet(person):             # функция
    return f"Привет, {person}!"  # f-строка с подстановкой

print(greet(name))             # Выведет: Привет, Пользователь!
```

---

## Часть 2: Что такое Django?

**Django** — фреймворк для создания веб-приложений на Python. Он предоставляет:
- работу с базой данных (модели, миграции)
- маршрутизацию URL
- шаблоны HTML
- админ-панель
- авторизацию пользователей

### Архитектура Django: MVT

Django использует паттерн **MVT** (Model–View–Template):

| Компонент | Назначение | Где в проекте |
|-----------|------------|----------------|
| **Model** (Модель) | Описание данных и работа с БД | `apps/*/models.py` |
| **View** (Представление) | Логика обработки запроса | `apps/*/views.py` |
| **Template** (Шаблон) | HTML-разметка страницы | `templates/` |

Схема запроса:

```
Пользователь → URL → View → Model (БД) → Template → HTML → Пользователь
```

---

## Часть 3: Структура проекта IAS

### Общая структура

```
helpdesk_ias_py/
├── helpdesk_ias/          # Основной Django-проект
│   ├── config/            # Конфигурация проекта
│   ├── apps/              # Приложения (модули)
│   ├── templates/         # HTML-шаблоны
│   ├── static/            # CSS, JS, изображения
│   ├── manage.py          # Утилита для команд Django
│   └── .env               # Секреты (не в git!)
├── docs/                  # Документация
├── requirements.txt       # Зависимости Python
└── README.md
```

### Папка `config/` — настройки проекта

| Файл | Назначение |
|------|------------|
| `settings.py` | Все настройки: БД, приложения, безопасность |
| `urls.py` | Главный маршрутизатор URL (куда ведут ссылки) |
| `wsgi.py` | Точка входа для веб-сервера |

### Папка `apps/` — приложения (модули)

Каждое приложение отвечает за свою область:

| Приложение | Назначение |
|------------|------------|
| `core` | Общая логика, вход, главная страница |
| `users` | Пользователи, роли, авторизация |
| `tasks` | Заявки Help Desk |
| `assets` | Оборудование, локации |
| `software` | ПО и лицензии |
| `reports` | Отчёты |
| `procurement` | Закупки |
| `audit` | Аудит действий |
| `api` | REST API для фронтенда |

### Типичная структура приложения (например, `tasks`)

```
apps/tasks/
├── models.py      # Модели (Task, Attachment, TaskStatus)
├── views.py       # Обработчики запросов (список, создание, редактирование)
├── forms.py       # Формы для ввода данных
├── urls.py        # URL-маршруты этого приложения
├── admin.py       # Регистрация в админ-панели
├── services.py    # Бизнес-логика (сервисный слой)
├── policies.py    # Правила доступа
└── migrations/    # Миграции БД (история изменений схемы)
```

---

## Часть 4: Ключевые концепции Django

### 4.1 Модели (Models)

Модель описывает структуру таблицы в БД. Каждый класс = таблица, каждое поле = колонка.

**Пример из `apps/tasks/models.py`:**

```python
class Task(models.Model):
    """Заявка Help Desk."""
    description = models.TextField("Описание")      # текстовое поле
    status = models.ForeignKey(TaskStatus, ...)     # связь с другой таблицей
    creator = models.ForeignKey(User, ...)          # кто создал
    executor = models.ForeignKey(User, ...)         # кто выполняет
    created_at = models.DateTimeField(...)         # дата создания
```

**Типы связи между моделями:**
- `ForeignKey` — «многие к одному» (много заявок у одного статуса)
- `ManyToManyField` — «многие ко многим» (заявка ↔ вложения)
- `OneToOneField` — «один к одному»

### 4.2 Миграции (Migrations)

Миграции — это способ изменять структуру БД без ручного SQL.

```bash
# Создать миграции после изменения models.py
python manage.py makemigrations

# Применить миграции к БД
python manage.py migrate
```

### 4.3 Представления (Views)

View — функция или класс, обрабатывающий HTTP-запрос и возвращающий ответ.

```python
# Пример: список заявок
@login_required
def task_list(request):
    tasks = Task.objects.select_related("status", "creator").order_by("-created_at")
    return render(request, "tasks/list.html", {"tasks": tasks})
```

- `request` — объект запроса (параметры, пользователь, cookies)
- `render()` — отрисовка шаблона с данными
- `@login_required` — декоратор: доступ только для авторизованных

### 4.4 URL-маршрутизация

`config/urls.py` подключает приложения:

```python
urlpatterns = [
    path("", include("apps.core.urls")),      # главная
    path("admin/", admin.site.urls),          # админка
    path("tasks/", include("apps.tasks.urls")),
    path("users/", include("apps.users.urls")),
]
```

В `apps/tasks/urls.py`:

```python
urlpatterns = [
    path("", views.task_list, name="task_list"),
    path("<int:pk>/", views.task_detail, name="task_detail"),
    path("create/", views.task_create, name="task_create"),
]
```

Так `/tasks/` вызывает `task_list`, `/tasks/5/` — `task_detail` с `pk=5`.

### 4.5 Шаблоны (Templates)

Шаблоны — HTML с вставками Django (переменные, циклы, условия).

```html
<!-- base.html — базовый шаблон -->
<html>
<body>
  {% block content %}{% endblock %}
</body>
</html>

<!-- tasks/list.html — наследует base -->
{% extends "base.html" %}
{% block content %}
  {% for task in tasks %}
    <p>{{ task.description }} — {{ task.status.name }}</p>
  {% endfor %}
{% endblock %}
```

**Синтаксис шаблонов:**
- `{{ переменная }}` — вывод значения
- `{% for item in list %}...{% endfor %}` — цикл
- `{% if condition %}...{% endif %}` — условие
- `{% block name %}...{% endblock %}` — блок для наследования

### 4.6 Формы (Forms)

Формы проверяют ввод и показывают ошибки:

```python
# forms.py
class TaskForm(forms.ModelForm):
    class Meta:
        model = Task
        fields = ["description", "status", "executor", "comment"]

# views.py
form = TaskForm(request.POST or None)
if form.is_valid():
    form.save()
    return redirect("task_list")
```

---

## Часть 5: Быстрый старт

### 1. Установка Python

Убедитесь, что Python 3.11+ установлен:

```bash
python3 --version
```

### 2. Виртуальное окружение

Виртуальное окружение изолирует зависимости проекта.

```bash
# Создать (если ещё нет)
python3 -m venv .venv

# Активировать (macOS/Linux)
source .venv/bin/activate

# Активировать (Windows)
.venv\Scripts\activate
```

После активации в начале строки появится `(.venv)`.

### 3. Установка зависимостей

```bash
pip install -r requirements.txt
```

### 4. Настройка окружения

```bash
cd helpdesk_ias
cp .env.example .env
# Отредактируйте .env: DJANGO_SECRET_KEY, DEBUG, DATABASE_URL (если PostgreSQL)
```

### 5. База данных

```bash
python manage.py migrate
```

### 6. Создание суперпользователя (для админки)

```bash
python manage.py createsuperuser
```

### 7. Запуск сервера

```bash
python manage.py runserver
```

Откройте в браузере: http://127.0.0.1:8000/

---

## Часть 6: Полезные команды Django

| Команда | Назначение |
|---------|------------|
| `python manage.py runserver` | Запуск dev-сервера |
| `python manage.py check` | Проверка настроек |
| `python manage.py migrate` | Применить миграции |
| `python manage.py makemigrations` | Создать миграции |
| `python manage.py createsuperuser` | Создать админа |
| `python manage.py shell` | Интерактивная консоль Python с Django |
| `python manage.py startapp имя` | Создать новое приложение |

---

## Часть 7: Зависимости проекта (requirements.txt)

| Пакет | Назначение |
|-------|------------|
| Django | Фреймворк |
| django-environ | Переменные окружения из .env |
| django-crispy-forms | Красивые формы с Bootstrap |
| django-debug-toolbar | Отладка запросов в dev |
| psycopg | Драйвер PostgreSQL |
| openpyxl | Работа с Excel |

---

## Часть 8: Логи

Файлы логов пишутся в `helpdesk_ias/logs/`:
- `app.log` — общий лог приложения
- `security.log` — события безопасности
- `audit.log` — аудит действий

---

## Часть 9: Глоссарий

| Термин | Пояснение |
|--------|-----------|
| **ORM** | Object-Relational Mapping — доступ к БД через объекты Python |
| **QuerySet** | Набор записей из БД (например, `Task.objects.all()`) |
| **Декоратор** | Функция, оборачивающая другую (`@login_required`) |
| **Middleware** | Промежуточный слой между запросом и view |
| **CSRF** | Защита от подделки запросов (Django включает по умолчанию) |
| **MEDIA_ROOT** | Папка для загружаемых файлов |
| **STATIC_ROOT** | Папка для статики (CSS, JS) |

---

## Часть 10: Ресурсы для обучения

### Python
- [Официальный туториал Python (ru)](https://docs.python.org/3/tutorial/)
- [LearnPython.org](https://www.learnpython.org/) — интерактивные уроки

### Django
- [Официальная документация Django](https://docs.djangoproject.com/)
- [Django Girls Tutorial](https://tutorial.djangogirls.org/ru/) — пошаговый туториал на русском
- [Django for Beginners](https://djangoforbeginners.com/) — книга

### Этот проект
- `docs/README.md` — индекс документации
- `docs/guides/ПЛАН.md` — план миграции и требования
- `docs/technical/` — технические спецификации

---

## Документация проекта

- `docs/README.md` — индекс документации.

## Django-проект (Фаза 2)

Код Django расположен в: `helpdesk_ias/`

### Быстрый старт (dev)

1) Активировать виртуальное окружение:

```bash
source .venv/bin/activate
```

2) Подготовить переменные окружения:

```bash
cp helpdesk_ias/.env.example helpdesk_ias/.env
```

3) Запустить проверки/сервер:

```bash
cd helpdesk_ias
python manage.py check
python manage.py runserver
```
