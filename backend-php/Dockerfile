FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libpq-dev \
    git \
    unzip \
    && docker-php-ext-install curl pdo pdo_pgsql \
    && a2enmod rewrite \
    && rm -rf /var/lib/apt/lists/*

# Suppress ServerName warning
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Configure Apache DocumentRoot to public/ using the standard approach
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
# Copy application files
# Dokploy uses the repo root as build context, so we need to copy backend-php/
# We try backend-php/ first (Dokploy context), fall back to . (local docker-compose context)
COPY backend-php/ /var/www/html/
# Verify public directory exists
RUN ls -la /var/www/html/public/ && echo "DocumentRoot OK"
# Directory configuration for AllowOverride (needed for .htaccess)
RUN echo "<Directory ${APACHE_DOCUMENT_ROOT}>\n\
    Options FollowSymLinks\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>" >> /etc/apache2/apache2.conf

# Set permissions
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
