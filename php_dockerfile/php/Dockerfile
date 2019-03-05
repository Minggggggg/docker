FROM php:7.1.8-fpm
#RUN usermod -u 1000 www-data
#RUN groupmod -g 1000 www-data

ENV TZ=Asia/Shanghai

RUN set -xe \
    && echo "构建依赖" \
    && buildDeps=" \
        libfreetype6 \
        libjpeg62-turbo \
        libmcrypt4 \
        #libpng12-0 \
        build-essential \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
    " \
    && echo "memcached 需要的依赖" \
    && memcachedDeps=" \
        libmemcached11 \
        libmemcachedutil2 \
        build-essential \
        libmemcached-dev \
        libz-dev \
    " \ 
    && echo "安装 php 以及编译构建组件所需包" \
    && DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y ${buildDeps} ${memcachedDeps} net-tools iputils-ping --no-install-recommends \

    && echo "编译安装 php 组件" \
    && docker-php-ext-install -j$(nproc) iconv sockets mcrypt mysqli pdo pdo_mysql zip pcntl \

    && echo "安装redis扩展" \
    && pecl install redis-4.2.0.tgz\
    #可以不需要，自己写进去也行。
    && echo extension=redis.so >> /usr/local/etc/php/conf.d/php.ini \

	&& echo "安装memcached扩展" \
    && pecl install memcached-3.1.3.tgz  \
    #可以不需要，自己写进去也行。
    && echo extension=memcached.so >> /usr/local/etc/php/conf.d/php.ini \
    
    && echo "配置GD库路径&&安装" \
    && docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    
    && echo "清理" \
    && apt-get purge -y --auto-remove \
        #Autoremove不会删除其他软件包推荐的自动软件包,可以通过添加这个apt配置来更改此行
        -o APT::AutoRemove::RecommendsImportant=false \
        -o APT::AutoRemove::SuggestsImportant=false \
        #$buildDeps \
    && apt-get clean \ 
    && rm -rf /var/cache/apt/* \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/pear
