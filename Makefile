# Makefile for building the project

app_name=twofactor_u2f
project_dir=$(CURDIR)/../$(app_name)
build_dir=$(CURDIR)/build/artifacts
sign_dir=$(build_dir)/sign
appstore_dir=$(build_dir)/appstore
source_dir=$(build_dir)/source
package_name=$(app_name)
cert_dir=$(HOME)/.nextcloud/certificates

all: install-deps

clean:
	rm -rf vendor

composer.phar:
	curl -sS https://getcomposer.org/installer | php

update-composer: composer.phar
	rm -f composer.lock
	php composer.phar install --prefer-dist

appstore:
	mkdir -p $(sign_dir)
	composer install --no-dev
	rsync -a \
	--delete \
	--exclude=.git \
	--exclude=build \
	--exclude=.gitignore \
	--exclude=.travis.yml \
	--exclude=.scrutinizer.yml \
	--exclude=CONTRIBUTING.md \
	--exclude=composer.json \
	--exclude=composer.lock \
	--exclude=composer.phar \
	--exclude=coverage \
	--exclude=karma.conf.js \
	--exclude=l10n/.tx \
	--exclude=l10n/no-php \
	--exclude=Makefile \
	--exclude=nbproject \
	--exclude=node_modules \
	--exclude=package.json \
	--exclude=screenshots \
	--exclude=phpunit*xml \
	--exclude=tests \
	--exclude=vendor/bin \
	--exclude=vendor/yubico/u2flib-server/examples \
	$(project_dir) $(sign_dir)
	@echo "Signing…"
	php ../../occ integrity:sign-app \
		--privateKey=$(cert_dir)/$(app_name).key\
		--certificate=$(cert_dir)/$(app_name).crt\
		--path=$(sign_dir)/$(app_name)
	tar -czf $(build_dir)/$(app_name).tar.gz \
		-C $(sign_dir) $(app_name)
	openssl dgst -sha512 -sign $(cert_dir)/$(app_name).key $(build_dir)/$(app_name).tar.gz | openssl base64
