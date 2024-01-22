#!make

DOCKER_COMPOSE_CMD = docker-compose

# docker

build:
	$(DOCKER_COMPOSE_CMD) build --no-cache

status:
	$(DOCKER_COMPOSE_CMD) ps
up:
	$(DOCKER_COMPOSE_CMD) up -d
	@$(MAKE) --no-print-directory status
stop:
	$(DOCKER_COMPOSE_CMD) stop
	@$(MAKE) status

restart: stop up


# logs
logs-consul-server:
	$(DOCKER_COMPOSE_CMD) logs -f consul_server
logs-consul-client:
	$(DOCKER_COMPOSE_CMD) logs -f consul_client
logs-fabio:
	$(DOCKER_COMPOSE_CMD) logs -f fabio


# bash/sh
console-consul-server:
	$(DOCKER_COMPOSE_CMD) exec consul_server sh
console-fabio:
	$(DOCKER_COMPOSE_CMD) exec fabio sh


# consul_server
consul-server-show-started-precesses:
	$(DOCKER_COMPOSE_CMD) exec consul_server ps aux
consul-server-catalog-nodes:
	$(DOCKER_COMPOSE_CMD) exec consul_server curl localhost:8500/v1/catalog/nodes
consul-server-catalog-services:
	$(DOCKER_COMPOSE_CMD) exec consul_server curl curl http://localhost:8500/v1/catalog/services
consul-client-catalog-services:
	$(DOCKER_COMPOSE_CMD) exec consul_client curl curl http://localhost:8500/v1/catalog/services

FIND_CONSUL_PID := ps -ef | grep consul | grep -v grep | awk '{print $$1}'
CONSUL_PID ?= $(shell ($(DOCKER_COMPOSE_CMD) exec consul_server sh -c $(FIND_CONSUL_PID)))
consul-server-pid:
	@echo $(CONSUL_PID)
consul-server-reload:
	$(DOCKER_COMPOSE_CMD) exec consul_server kill -SIGHUP $(CONSUL_PID)
