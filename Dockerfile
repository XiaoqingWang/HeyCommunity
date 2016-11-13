## 参考 https://github.com/DaoCloud/php-laravel-mysql-sample/blob/master/Dockerfile
FROM daocloud.io/php:5.6-apache


##
## APT 自动安装 PHP 相关的依赖包,如需其他依赖包在此添加
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
        zip


##
## 用完包管理器后安排打扫卫生可以显著的减少镜像大小
RUN apt-get clean \
&& apt-get autoclean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


##
## 安装 Composer，此物是 PHP 用来管理依赖关系的工具
RUN curl -sS https://getcomposer.org/installer \
    | php -- --install-dir=/usr/local/bin --filename=composer


##
## Apache 配置
RUN echo '<Directory /var/www/HeyCommunity>\n\
    Options Indexes FollowSymLinks\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>' >> /etc/apache2/apache2.conf

RUN sed -i 's/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/HeyCommunity/g' /etc/apache2/sites-enabled/000-default.conf


##
## 开启 URL 重写模块
## 配置默认放置 App 的目录
RUN a2enmod rewrite \
    && service apache2 restart \
    && mkdir -p /app \
    && ln -s /app /var/www/HeyCommunity

# RUN cat /etc/apache2/apache2.conf
# RUN cat /etc/apache2/sites-enabled/000-default.conf


##
## 复制程序代码
WORKDIR /app
COPY . /app


##
## 部署 backend
WORKDIR /app/backend
RUN composer install
RUN cp .env.example .env \
    && php artisan key:g
RUN chown -R :www-data . \
    && chmod -R g+w storage bootstrap/cache public


##
##
EXPOSE 80
VOLUME /app/backend/public/uploads
CMD ["/bin/bash", "/app/run.sh"]
