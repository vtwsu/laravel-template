# Выводит список команд make-файла с описанием
help:
	sed -nE "s/^([[:alpha:]]*:)/\1/p; s/^(#[[:blank:]]*)([[:graph:]].*)$\/-\ \2/p; s/^#[[:blank:]]*$\//p" Makefile

# Запуск контейнеров
up:
	docker-compose up -d
	sudo chown -R vtw:vtw data
	sudo chmod -R 777 data
	docker-compose exec -T -u root php bash -c "PGPASSWORD=password pg_dump -U user -h postgres db >> db.sql"
# Остановка контейнеров
down:
	docker-compose down

# Запуск sh в контейнере php
php:
	docker-compose exec php sh

# Запуск миграций БД
migration:
	docker-compose exec php php artisan migrate

# Собирает контейнеры
build:
	cp example.env .env
	cp src/.env.example src/.env

	docker-compose pull
	docker-compose build
	docker-compose up -d

	docker-compose exec php composer install
	# docker-compose exec php yarn

	docker-compose exec php php artisan key:generate

	docker-compose down

# Запускает yarn watch в контейнере для разработки фронтенда
dev:
	# docker-compose exec php yarn watch

# Запускает yarn production для сборки билда
prod:
	# docker-compose exec php yarn production

