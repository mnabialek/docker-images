# Base image
FROM ubuntu:20.04

RUN export DEBIAN_FRONTEND=noninteractive

# Set to working mirrors that won't cause Hash sum mismatch errors on MacOS
RUN sed -i '1ideb http://ftp.icm.edu.pl/pub/Linux/ubuntu// xenial main' /etc/apt/sources.list
RUN sed -i '1ideb-src http://ftp.icm.edu.pl/pub/Linux/ubuntu/ xenial main' /etc/apt/sources.list

# Update packages list and system
RUN apt-get -y update
RUN apt-get -y upgrade

# Allow to use add-apt-repository command
RUN apt-get -y install software-properties-common locales poppler-utils

# Set valid lcoale
RUN echo "LC_ALL=en_US.UTF-8" > /etc/default/locale
RUN locale-gen en_US.UTF-8

# Add some packages
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y
RUN apt-add-repository ppa:chris-lea/redis-server -y
RUN apt-key update
RUN apt-get -y update

# Install basic packages
RUN apt-get -y install git mc unzip nano

# Install Libxml2 to install Soap PHP extension
RUN apt-get install -y libxml2-dev

# Install Zlib to install Zip PHP extension
RUN apt-get install -y zlib1g-dev

# Remove default PHP installation
RUN apt-get purge php8.0.*

# Install PHP
RUN apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages \
php8.1-cli php8.1-fpm php8.1-dev \
php8.1-pgsql php8.1-sqlite3 php8.1-gd \
php8.1-curl php8.1-memcached \
php8.1-imap php8.1-mysql php8.1-mbstring \
php8.1-xml php8.1-zip php8.1-bcmath php8.1-soap \
php8.1-intl php8.1-readline php-xdebug php-pear php-redis

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Install SSH server
RUN apt-get --yes install openssh-server
RUN mkdir /var/run/sshd

# Install Nginx
RUN apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages nginx
RUN rm /etc/nginx/sites-enabled/default
RUN rm /etc/nginx/sites-available/default
RUN service nginx restart

# Set The Nginx & PHP-FPM User
RUN sed -i "s/# server_names_hash_bucket_size.*/server_names_hash_bucket_size 64;/" /etc/nginx/nginx.conf

# Install supervisor (using easy_install to get latest version)
RUN apt install --yes python3-pip
RUN pip3 install supervisor
RUN echo_supervisord_conf > /etc/supervisord.conf
RUN mkdir /etc/supervisor/

# Set up supervisor log and include extra configuration files
RUN sed -i -e "s#logfile=/tmp/supervisord.log ;#logfile=/var/log/supervisor/supervisord.log ;#g" /etc/supervisord.conf
RUN sed -i -e "s#;\[include\]#\[include\]#g" /etc/supervisord.conf
RUN sed -i -e "s#;files = relative/directory/\*.ini#files = /etc/supervisor/conf.d/\*.conf#g" /etc/supervisord.conf

# Set PHP to listen on given port instead of unix socket
RUN sed -i -e 's#listen = \/run\/php\/php8.1-fpm.sock#listen = 0.0.0.0:9000#g' /etc/php/8.1/fpm/pool.d/www.conf

# Install Google Chrome to run Laravel Dusk tests
RUN curl -LO https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get install -y ./google-chrome-stable_current_amd64.deb
RUN rm google-chrome-stable_current_amd64.deb

# Install Redis
RUN apt-get -y install redis-server

# Clean
RUN apt-get -y autoremove
RUN apt-get -y clean

# Copy .bashrc and .profile files
COPY .bashrc /www-data/.bashrc
COPY .profile /www-data/.profile

# Copy services script file
COPY start.sh /www-data/start.sh

# Run services file
CMD ["/bin/bash", "/www-data/start.sh"]
