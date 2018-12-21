# Base image
FROM ubuntu:16.04

RUN export DEBIAN_FRONTEND=noninteractive

# Set to working mirrors that won't cause Hash sum mismatch errors on MacOS
RUN sed -i '1ideb http://mirror.onet.pl/pub/mirrors/ubuntu/ xenial main' /etc/apt/sources.list
RUN sed -i '1ideb-src http://mirror.onet.pl/pub/mirrors/ubuntu/ xenial main' /etc/apt/sources.list

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
RUN apt-add-repository ppa:nginx/development -y
RUN apt-key update
RUN apt-get -y update

# Install basic packages
RUN apt-get -y install git mc unzip nano

# Install Libxml2 to install Soap PHP extension
RUN apt-get install -y libxml2-dev

# Install Zlib to install Zip PHP extension
RUN apt-get install -y zlib1g-dev

# Install PHP
RUN apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages \
php7.3-cli php7.3-fpm php7.3-dev \
php7.3-pgsql php7.3-sqlite3 php7.3-gd \
php7.3-curl php7.3-memcached \
php7.3-imap php7.3-mysql php7.3-mbstring \
php7.3-xml php7.3-zip php7.3-bcmath php7.3-soap \
php7.3-intl php7.3-readline php-xdebug php-pear

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
RUN apt-get install --yes python-setuptools
RUN easy_install supervisor
RUN echo_supervisord_conf > /etc/supervisord.conf
RUN mkdir /etc/supervisor/

# Set up supervisor log and include extra configuration files
RUN sed -i -e "s#logfile=/tmp/supervisord.log ;#logfile=/var/log/supervisor/supervisord.log ;#g" /etc/supervisord.conf
RUN sed -i -e "s#;\[include\]#\[include\]#g" /etc/supervisord.conf
RUN sed -i -e "s#;files = relative/directory/\*.ini#files = /etc/supervisor/conf.d/\*.conf#g" /etc/supervisord.conf

# Set PHP to listen on given port instead of unix socket
RUN sed -i -e 's#listen = \/run\/php\/php7.3-fpm.sock#listen = 0.0.0.0:9000#g' /etc/php/7.3/fpm/pool.d/www.conf

# Install Chrome web driver and other libraries required to run Laravel Dusk tests
RUN apt-get -y install libxpm4 libxrender1 libgtk2.0-0 \
libnss3 libgconf-2-4 chromium-browser \
xvfb gtk2-engines-pixbuf xfonts-cyrillic \
xfonts-100dpi xfonts-75dpi xfonts-base \
xfonts-scalable imagemagick x11-apps

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