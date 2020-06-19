wp_url=https://ru.wordpress.org

wp_plugins_url=https://downloads.wordpress.org/plugin

wp_themes_path=
wp_plugins_path=wordpress/wp-content/plugins

NAME=$(shell basename $(shell pwd))
HOSTNAME=$(shell hostname)
XDEBUG_CONFIG=remote_host=$(HOSTNAME) remote_port=9000 remote_enable=1 remote_autostart=1

all: env pull build wp environment
	# Environment
.PHONY: all

pull:
	docker pull wordpress:5.4-apache
	docker pull php:7.0.33-apache
	docker-compose pull db adminer
build:
	docker-compose build
env:
	-mkdir -p wordpress/wp-content/plugins wordpress/wp-content/themes
	-mkdir .cache
	-mkdir initdb
	echo NAME=$(NAME) > .env
	echo HOSTNAME=$(HOSTNAME) >> .env
	echo XDEBUG_CONFIG=$(XDEBUG_CONFIG) >> .env
serve:
	docker-compose up
clean:
	docker-compose rm -fsv
	-rm -rf wordpress
prune: clean
	rm -rf .cache
	docker-compose run app bash -c 'rm -rf /var/www/html/*'
# Environment
environment: \
environment/requirements \
environment/config
	# Environment Inited!
environment/requirements:
	composer install
environment/config: \
linter/config/wpcs
	# Environment Configured!
# Features
feature/initdb:
	mkdir -p ./initdb
	touch ./initdb/.gitkeep
	sed -i 's/# feature:initdb/- .\/initdb:\/docker-entrypoint-initdb.d:ro/g' docker-compose.yml
feature/initdb/disable:
	sed -i 's/- .\/initdb:\/docker-entrypoint-initdb.d:ro/# feature:initdb/g' docker-compose.yml
# Wordpress
wp: wp/requirements wp/defaults
	# Wordpress Installed!
wp/requirements: \
wp/install/wordpress-5.4.1-ru_RU.zip \
wp/install/plugin/developer.1.2.6.zip \
wp/install/plugin/query-monitor.3.6.0.zip \
	# Wordpress Requirements Installed!
wp/defaults:
	cp -rf defaults/wordpress/* wordpress
wp/install/wordpress-%:
	wget -nc -P .cache $(wp_url)/wordpress-$*
	unzip -q -o .cache/wordpress-$*
	# ---------- $@ ----------
wp/install/plugin/%:
	wget -nc -P .cache $(wp_plugins_url)/$*
	unzip -q -o .cache/$* -d $(wp_plugins_path)
	# ---------- $@ ----------
# Linter
lint: linter/phpcbf linter/phpcs
	# ---------- $@ ----------
linter/phpcs:
	./vendor/bin/phpcs --ignore=vendor,wordpress --extensions=php --standard=WordPress-Extra .
linter/phpcbf:
	./vendor/bin/phpcbf --ignore=vendor,wordpress --extensions=php --standard=WordPress-Extra .
linter/config/wpcs:
	./vendor/bin/phpcs --config-set installed_paths $(shell pwd)/vendor/wp-coding-standards/wpcs
# Project
project/wp-content/%:
	$(eval $@_NAME=$(shell basename $*))
	mkdir ./$($@_NAME)
	touch ./$($@_NAME)/.gitkeep
	sed -i 's|# app:volumes|- ./$($@_NAME):/var/www/html/wordpress/wp-content/themes/$*\n      # app:volumes|g' docker-compose.yml
	sed -i 's|// pathMappings|"/var/www/html/wordpress/wp-content/themes/$*": "$${workspaceFolder}/$($@_NAME)",\n				// pathMappings|' .vscode/launch.json
	# ---------- $@ ----------
project/drop/wp-content/%:
	$(eval $@_NAME=$(shell basename $*))
	rm -r ./$($@_NAME)
	sed -i '\|- ./$($@_NAME):/var/www/html/wordpress/wp-content/themes/$*|d' docker-compose.yml
	sed -i '\|"/var/www/html/wordpress/wp-content/themes/$*": "$${workspaceFolder}/$($@_NAME)",|d' .vscode/launch.json
project/theme/%:
	make project/wp-content/themes/$*
project/drop/theme/%:
	make project/drop/wp-content/themes/$*
project/plugin/%:
	make project/wp-content/plugins/$*
project/drop/plugin/%:
	make project/drop/wp-content/plugins/$*
