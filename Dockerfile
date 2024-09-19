# Stage 1: Install dependencies
FROM composer:2.7.9 as build

# Set working directory
WORKDIR /var/www/html

# Copy composer files
COPY composer.json ./

# Install composer dependencies
RUN composer install --no-dev --no-scripts --no-interaction --prefer-dist --optimize-autoloader

# Copy the rest of the application code
COPY . .

# Set correct permissions for Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Stage 2: Production stage with php-fpm and nginx
FROM php:8.1-fpm-alpine

# Install PHP extensions and dependencies
RUN apk update && apk --no-cache add \
    nginx \
    supervisor \
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

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd intl

# Copy built app from the build stage
COPY --from=build /var/www/html /var/www/html

# Copy nginx configuration
COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf

# Copy supervisor configuration
COPY ./docker/supervisord.conf /etc/supervisord.conf

# Set permissions for storage and cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Expose the port that nginx is running on
EXPOSE 80

# Start supervisord (which runs nginx and php-fpm)
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
