## 参考 https://github.com/DaoCloud/php-laravel-mysql-sample/blob/master/Dockerfile
FROM daocloud.io/php:5.6-apache

# APT 自动安装 PHP 相关的依赖包,如需其他依赖包在此添加
RUN apt-get update \
    && apt-get install -y \
        libmcrypt-dev \
        libz-dev \
        git \
        wget \

    # 官方 PHP 镜像内置命令，安装 PHP 依赖
    && docker-php-ext-install \
        mcrypt \
        mbstring \
        pdo_mysql \
        zip \

    # 用完包管理器后安排打扫卫生可以显著的减少镜像大小
    && apt-get clean \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \


# 安装 Composer，此物是 PHP 用来管理依赖关系的工具
RUN curl -sS https://getcomposer.org/installer \
    | php -- --install-dir=/usr/local/bin --filename=composer


# 开启 URL 重写模块
# 配置默认放置 App 的目录
RUN a2enmod rewrite \
    && service apache2 restart \
    && mkdir -p /app \
    && rm -fr /var/www/html \
    && ln -s /app /var/www/html


# 复制程序代码
WORKDIR /app
COPY . /app


# backend 配置
WORKDIR /app/backend
RUN pwd && ls -la
RUN /usr/local/bin/composer install \
    && chown -R www-data:www-data /app \
    && chmod -R 0777 /app/backend/

RUN cp .env.example .env \
    && php artisan key:generate

RUN php artisan migrate:refresh --seed
