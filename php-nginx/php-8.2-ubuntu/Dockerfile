# Base image
FROM ubuntu:24.04

RUN export DEBIAN_FRONTEND=noninteractive

# Update packages list and system
RUN apt-get -y update && \
    apt-get -y upgrade

RUN dpkg --configure -a

# Allow to use add-apt-repository command
RUN apt-get -y install software-properties-common locales poppler-utils --no-install-recommends

# Set valid locale
RUN echo "LC_ALL=en_US.UTF-8" > /etc/default/locale && \
    locale-gen en_US.UTF-8

# Add some packages
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y && \
    apt-key update && \
    apt-get -y update


RUN apt-get -y install --no-install-recommends \
    # Install basic packages
    git mc unzip nano curl cron \
    # Install Libxml2 to install Soap PHP extension
    libxml2-dev \
    # Install Zlib to install Zip PHP extension
    zlib1g-dev

# Remove default PHP installation
RUN apt-get purge -y php8.3.* php8.4.*

# Install PHP
RUN  apt-get -y update && \
     apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages --no-install-recommends \
php8.2-cli php8.2-fpm php8.2-dev \
php8.2-pgsql php8.2-sqlite3 php8.2-gd \
php8.2-curl php8.2-memcached \
php8.2-imap php8.2-mysql php8.2-mbstring \
php8.2-xml php8.2-zip php8.2-bcmath php8.2-soap \
php8.2-intl php8.2-readline php8.2-xdebug php-pear php8.2-redis

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Install SSH server
RUN apt-get --yes install --no-install-recommends openssh-server && \
    mkdir /var/run/sshd

# Install Nginx
RUN apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages --no-install-recommends nginx && \
    rm /etc/nginx/sites-enabled/default && \
    rm /etc/nginx/sites-available/default && \
    service nginx restart

# Set The Nginx & PHP-FPM User
RUN sed -i "s/# server_names_hash_bucket_size.*/server_names_hash_bucket_size 64;/" /etc/nginx/nginx.conf

# Install supervisor (using pip to get latest version)
RUN apt install --yes --no-install-recommends python3-pip && \
    pip3 install supervisor --break-system-packages && \
    echo_supervisord_conf > /etc/supervisord.conf && \
    mkdir /etc/supervisor/ && \
    mkdir /var/log/supervisor/ && \
    mkdir /var/log/supervisor/conf.d && \
    apt-get purge -y python3-pip

# Set up supervisor log and include extra configuration files
RUN sed -i -e "s#logfile=/tmp/supervisord.log ;#logfile=/var/log/supervisor/supervisord.log ;#g" /etc/supervisord.conf && \
    sed -i -e "s#;\[include\]#\[include\]#g" /etc/supervisord.conf && \
    sed -i -e "s#;files = relative/directory/\*.ini#files = /etc/supervisor/conf.d/\*.conf#g" /etc/supervisord.conf

# Set PHP to listen on given port instead of unix socket
RUN sed -i -e 's#listen = \/run\/php\/php8.2-fpm.sock#listen = 0.0.0.0:9000#g' /etc/php/8.2/fpm/pool.d/www.conf

# Install Google Chrome to run Laravel Dusk tests
RUN curl -LO https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get -y update && \
    apt-get install -y --no-install-recommends ./google-chrome-stable_current_amd64.deb && \
    rm google-chrome-stable_current_amd64.deb

# Install Redis
RUN apt-get -y install --no-install-recommends redis-server

# Clean
RUN apt-get -y autoremove && \
    apt-get -y clean

# Copy .bashrc and .profile files
COPY .bashrc /www-data/.bashrc
COPY .profile /www-data/.profile

# Copy services script file
COPY start.sh /www-data/start.sh

# Run services file
CMD ["/bin/bash", "/www-data/start.sh"]
