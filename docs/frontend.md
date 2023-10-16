Для добавления в контейнер node, npm и yarn необходимо:
1. в `Dockerfile` необходимо расскоментировать строку

```docker
RUN apt-get install --no-cache nodejs npm yarn
```

2. В `Makefile` раскомментировать строку
```
docker-compose exec php yarn
```

3. Пересобрать контейнеры
```sh
make build
```

После того, как контейнеры пересоберутся, пакеты `node`, `npm` и `yarn` будут доступны внутри контейнера `php`. Зайти в него можно с помощью команды `make php`.


## Точка входа приложения
Точкой входа скриптов служит `src/resources/js/app.js`<br>
Точкой входа стилей служит `src/resources/css/app.css`

## Работа с фронтом
`make dev` - запуск вотчера (yarn watch)<br>
`make prod` - запуск продовой сборки
