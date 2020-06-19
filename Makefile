wp_url=https://ru.wordpress.org

wp_plugins_url=https://downloads.wordpress.org/plugin

wp_themes_path=
wp_plugins_path=wordpress/wp-content/plugins

NAME=$(shell basename $(shell pwd))
HOSTNAME=$(shell hostname)
XDEBUG_CONFIG=remote_host=$(HOSTNAME) remote_port=9000 remote_enable=1 remote_autostart=1

all: env pull build wp
	# Environment
.PHONY: all

pull:
	docker-compose pull
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
clone/%:
	cd wordpress && git clone $*
	# ---------- $@ ----------
