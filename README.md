# Суть данного проекта

## Цель
Собрать базовую аритектуру на heshicorp приложениях.

## Проблеммы
По задумке авторов приложения heshicorp (fabio, consul и nomad)
должны скачиваться (это просто скомпилированные бинарники) и
запускаться прямо на сервере.

Например отсюда качать consul - https://releases.hashicorp.com/consul/1.4.4/consul_1.4.4_linux_amd64.zip

Проблеммы:
- при попытках скачивания через curl 404, а если перейти по ссылке в браузере, на странице можно увидеть:
  `This content is not currently available in your region.`
- так как heshicorp consul, в основном, нужен для оркестрации приложениями, то нужны разные сервера


## Что хочу:
- Показать как можно настроить инфраструктуру heshicorp от балансировщика до приложения.
- Использовать только готовые и официальные образы.
- Не использовать билды (только чистое поднятие docker-compose up -d с пробросом 
  онфигов через volumes)
- Не использовать .env, все связи (порты и адреса) - хардкод в файлах настроек 3
  (все в папке [.docker](.docker)) и command (в docker-compose)
- все продукты heshicorp докеризированы и есть в dockerhub https://hub.docker.com/u/hashicorp
  , поэтому вместо скачивания/сборки/запуска программ heshicorp (fabio, consul и nomad) использовать docker-контейнер
- Максимально разнести все по контейнерам (fabio отдельно, consul отдельно (несколько), nomad отдельно (несколько)) и связать их через docker сеть с помощью depends_on
- Как я понимаю связку fabio, consul и nomad описано на схеме [.puml/scheme.puml](.puml/scheme.puml)

# Схема docker-compose

[.puml/scheme.docker_compose.puml](.puml/scheme.docker_compose.puml), на схеме каждый прямоугольник - докер контейнер.

# Как поднять
`make up`

# Ссылки на локаль
- <a href="http://localhost:9999">localhost:9999</a> - приложение
  (точка входа балансировщика fabio, он балансирует 2мя сервисами описанными в consul_server и consul_client,
  сервисы представляют собой докер-контейнеры nginx_server (/ - отвечает `Hi. I am server!`) и nginx_client (/ - отвечает `Hi. I am client!`))
- <a href="http://localhost:9998">localhost:9998</a> - дашборд fabio
- <a href="http://localhost:8500">localhost:8500</a> - дашборд consul

# Откуда черпал инфу
1) теоритечческая статья про консул https://habr.com/ru/articles/531602/
2) практическая статья про консул https://habr.com/ru/articles/531602/
3) репо из статьи (2) https://github.com/pranavcode/consul-demo/
4) официальное репо hashicorp с примерами consul на docker-compose https://github.com/hashicorp/learn-consul-docker.git 
