#!/bin/bash

# Переходим в директорию проекта
cd blogicum

# Применяем миграции
python manage.py migrate

# Загружаем фикстуры
python manage.py loaddata db.json

# Создаем суперпользователя (если не существует)
# Используем переменные окружения для автоматического создания
if [ "$CREATE_SUPERUSER" = "yes" ]; then
  echo "Creating superuser..."
  python manage.py shell -c "
from django.contrib.auth import get_user_model;
User = get_user_model();
if not User.objects.filter(username='$DJANGO_SUPERUSER_USERNAME').exists():
    User.objects.create_superuser('$DJANGO_SUPERUSER_USERNAME', 
                                 '$DJANGO_SUPERUSER_EMAIL', 
                                 '$DJANGO_SUPERUSER_PASSWORD')
    print('Superuser created.');
else:
    print('Superuser already exists.')
  "
fi

# Запускаем сервер
python manage.py runserver 0.0.0.0:8000 