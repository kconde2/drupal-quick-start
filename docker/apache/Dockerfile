# from https://www.drupal.org/docs/8/system-requirements/drupal-8-php-requirements
FROM php:7.2-apache

COPY conf/000-default.conf /etc/apache2/sites-available/

RUN apt-get update \
	&& apt-get install wget -y \
	&& rm -rf /var/lib/apt/lists/*

# install the PHP extensions we need
RUN set -ex; \
	\
	if command -v a2enmod; then \
	a2enmod rewrite; \
	fi; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
	libjpeg-dev \
	libpng-dev \
	libpq-dev \
	; \
	\
	docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
	docker-php-ext-install -j "$(nproc)" \
	gd \
	opcache \
	mbstring \
	zip \
	bcmath \
	mysqli \
	pdo_mysql \
	pdo_pgsql \
	; \
	\
	# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark; \
	ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
	| awk '/=>/ { print $3 }' \
	| sort -u \
	| xargs -r dpkg-query -S \
	| cut -d: -f1 \
	| sort -u \
	| xargs -rt apt-mark manual; \
	\
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
	echo 'opcache.memory_consumption=128'; \
	echo 'opcache.interned_strings_buffer=8'; \
	echo 'opcache.max_accelerated_files=4000'; \
	echo 'opcache.revalidate_freq=1'; \
	echo 'opcache.fast_shutdown=1'; \
	echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Drush
RUN wget -O drush.phar https://github.com/drush-ops/drush-launcher/releases/download/0.6.0/drush.phar \
	&& chmod +x drush.phar \
	&& mv drush.phar /usr/local/bin/drush

## Drupal command
RUN curl https://drupalconsole.com/installer -L -o drupal.phar \
	&& mv drupal.phar /usr/local/bin/drupal  \
	&& chmod +x /usr/local/bin/drupal

# Install Xdebug, la conf sera située dans: /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug
RUN service apache2 restart

WORKDIR /var/www/html
