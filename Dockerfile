FROM ubuntu:16.04
MAINTAINER Hector Opazo <hector.opazo.r@gmail.com>

# Variables de entorno
ENV HOME /home/administrador
ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No

# Configurar LOCALE
RUN locale-gen es_ES es_ES.UTF-8
ENV LANG es_ES.UTF-8
ENV LANGUAGE es_ES.UTF-8

# Actualizar
RUN apt-get update

# Instalar paquetes de desarrollo
RUN apt-get install --no-install-recommends -y \
		apache2 \
		ca-certificates \
		curl \
		imagemagick \
		libapache2-mod-php \
		libpcre3-dev \
		libssh2-1-dev \
		lynx \
		php \
		php-curl \
		php-dev \
		php-imap \
		php-mysql \
		php-ssh2 \
		php-xdebug \
		tesseract-ocr \
		zend-framework

RUN apt-get -y autoremove && apt-get clean && apt-get autoclean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl https://getcomposer.org/installer | php -- && mv composer.phar /usr/local/bin/composer && chmod +x /usr/local/bin/composer

# Carpetas del repositorio y enlace a zend-framework
RUN mkdir -p /opt/riskamerica/webservice/zendApp/public \
		&& mkdir -p /opt/riskamerica/webservice/zendApp/library/ \
		&& ln -s /opt/riskamerica/webservice/zendApp/public /var/www/html/webservice \
		&& ln -s /usr/share/php/libzend-framework-php/Zend /opt/riskamerica/webservice/zendApp/library/Zend

# Configurar apache
RUN ["/bin/bash", "-c", "echo -e \"<VirtualHost *:80>\n\tDocumentRoot /var/www/html/\n\tServerName localhost\n\t<Directory \"/var/www/html/webservice\">\n\t\tOptions Indexes FollowSymLinks\n\t\tAllowOverride All\n\t\tOrder allow,deny\n\t\tAllow from all\n\t</Directory>\n</VirtualHost>\">/etc/apache2/sites-enabled/000-default.conf"]

RUN sed -i 's/;date.timezone =/date.timezone = \"America\/Santiago\"/g' /etc/php/7.0/apache2/php.ini \
		&& sed -i 's/display_errors/c\display_errors = On/' /etc/php/7.0/apache2/php.ini \
		&& sed -i 's/#\. \/etc\/default\/locale/\. \/etc\/default\/locale/g' /etc/apache2/envvars \ 
		&& echo "ServerName localhost" >> /etc/apache2/apache2.conf \
		&& a2enmod rewrite
        
RUN ["/bin/bash", "-c", "echo -e \"zend_extension=xdebug.so\nxdebug.remote_enable=on\nxdebug.remote_handler=dbgp\nxdebug.remote_host=localhost\nxdebug.remote_port=9000\nxdebug.default_enable=0\nxdebug.profiler_aggregate=0\nxdebug.profiler_append=0\nxdebug.profiler_enable=0\nxdebug.profiler_enable_trigger=1\nxdebug.profiler_output_dir=/var/tmp/\nxdebug.profiler_output_name=xdebug-profile-cachegrind.out-%p\">/etc/php/7.0/apache2/conf.d/20-xdebug.ini"]

EXPOSE 80

# Usuario del container
RUN useradd -r -g www-data administrador && chown -R administrador:www-data /opt/riskamerica

#USER administrador

#WORKDIR /home/administrador

#Lanzar apache
CMD /usr/sbin/apache2ctl -D FOREGROUND
