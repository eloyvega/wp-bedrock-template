FROM php:7.2-apache

RUN apt-get update && \
    apt-get install -y git wget

RUN docker-php-ext-install mysqli

WORKDIR /app

COPY bin/install-composer.sh .

RUN chmod +x install-composer.sh && \
    ./install-composer.sh && \
    mv composer.phar /usr/local/bin/composer

COPY config/bedrock.conf /etc/apache2/sites-available/bedrock.conf
RUN a2dissite 000-default && a2ensite bedrock

WORKDIR /var/www/html/

COPY . .

RUN composer install

CMD ["apache2-foreground"]
