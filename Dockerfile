FROM php:8.2-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
  libmcrypt-dev \
  libicu-dev \
  git \
  curl \
  libpng-dev \
  libonig-dev \
  libxml2-dev \
  zip \
  libzip-dev \
  unzip \
  wget \
  ca-certificates \
  nano \
  cron

# Install NodeJS
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get update && apt-get install -y nodejs && apt-get clean

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip calendar intl

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN chmod +x /usr/local/bin/composer

COPY crontab /etc/cron.d/laravel
RUN chmod 0644 /etc/cron.d/laravel
RUN crontab /etc/cron.d/laravel

# Set working directory
WORKDIR /var/www/html

# Start cron
CMD ["cron", "-f"]
