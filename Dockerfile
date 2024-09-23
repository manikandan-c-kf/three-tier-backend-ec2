# Use PHP 8.1 with Apache
FROM php:8.1-apache

# Update the image and install important packages
RUN apt-get update -y && apt-get install -y \
    openssl \
    zip \
    unzip \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev

# Clean up package manager files to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Installing Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Adding Apache configuration
ADD 000-default.conf /etc/apache2/sites-available/
RUN ln -sf /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-enabled/000-default.conf

# Enable Apache rewrite module
RUN a2enmod rewrite

# Restart Apache service
RUN service apache2 restart

# Set working directory
WORKDIR /var/www/app/

# Copy all files from the current directory to the container's working directory
COPY . /var/www/app

# Granting permissions to files and folders
RUN chmod -R o+w /var/www/app/storage
RUN chown -R www-data:www-data ./storage
RUN chgrp -R www-data storage bootstrap/cache
RUN chmod -R ug+rwx storage bootstrap/cache
RUN chmod -R 755 /var/www/app/
RUN find /var/www/app/ -type d -exec chmod 775 {} \;
RUN chown -R www-data:www-data /var/www

# Install Laravel dependencies using Composer
RUN composer install --no-scripts --no-autoloader --no-ansi --no-interaction --working-dir=/var/www/app

# Install necessary PHP extensions
RUN docker-php-ext-install mbstring pdo pdo_mysql exif pcntl bcmath gd opcache
