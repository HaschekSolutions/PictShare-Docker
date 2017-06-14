FROM shito/alpine-nginx:edge
MAINTAINER Christian Haschek <office@haschek-solutions.com>

# Add PHP 7
RUN apk upgrade -U && \
    apk --update --repository=http://dl-4.alpinelinux.org/alpine/edge/testing add \
    openssl \
    ffmpeg \
    unzip \
    php7 \
    php7-pdo \
    php7-mcrypt \
    php7-curl \
    php7-gd \
    php7-json \
    php7-fpm \
    php7-openssl \
    php7-ctype \
    php7-opcache \
    php7-mbstring \
    php7-session \
    php7-fileinfo \
    php7-pcntl \
    file

COPY /rootfs /

# Small fixes
RUN rm /usr/bin/php && \
    ln -s /etc/php7 /etc/php && \
    ln -s /usr/bin/php7 /usr/bin/php && \
    ln -s /usr/sbin/php-fpm7 /usr/bin/php-fpm && \
    ln -s /usr/lib/php7 /usr/lib/php && \
    rm -fr /var/cache/apk/*

# Install composer global bin
#RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# Enable default sessions
RUN mkdir -p /var/lib/php7/sessions
RUN chown nginx:nginx /var/lib/php7/sessions

# ADD SOURCE
RUN mkdir -p /usr/share/nginx/html
RUN chown -Rf nginx:nginx /usr/share/nginx/html

WORKDIR /usr/share/nginx/html
RUN curl -O https://codeload.github.com/chrisiaut/pictshare/zip/master
RUN unzip master
RUN mv pictshare-master/* . && rm master && rm -r pictshare-master

VOLUME /usr/share/nginx/html/upload

RUN chmod +x bin/ffmpeg

RUN mv inc/example.config.inc.php inc/config.inc.php


RUN chown -Rf nginx:nginx /usr/share/nginx/html
RUN chmod -R 777 /usr/share/nginx/html/
RUN chmod 777 /etc/pictshare.sh

EXPOSE 80

ENTRYPOINT ["/etc/pictshare.sh"]
