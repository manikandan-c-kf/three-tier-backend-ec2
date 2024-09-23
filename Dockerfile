# Stage 1: Build dependencies (smaller base image)
FROM composer:2.3.10 AS build

# Set working directory
WORKDIR /var/www/html

# Copy composer.json and install dependencies
COPY composer.json ./
RUN composer install --no-dev --no-scripts --no-interaction --prefer-dist --optimize-autoloader

# Stage 2: Production stage with PHP-FPM and Nginx (smaller base image)
FROM php:8.1-fpm-alpine AS production

# Install PHP extensions
RUN apk add --no-cache \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    oniguruma-dev \
    bash \
    icu-dev \
    libxml2-dev \
    zip \
    unzip \
    curl

# Install additional extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd intl

# Copy built app from the build stage
COPY --from=build /var/www/html /var/www/html

# Expose the port that nginx is running on
EXPOSE 80

# Start supervisord (which runs nginx and php-fpm)
CMD ["php-fpm"]