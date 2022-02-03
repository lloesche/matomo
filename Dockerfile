FROM matomo:4.7
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG="en_US.UTF-8"
COPY matomo-archive /etc/cron.d/matomo-archive
COPY startup /usr/local/sbin/startup
RUN ln -s /var/www/html/matomo.php /var/www/html/m.php \
    && ln -s /var/www/html/matomo.js /var/www/html/m.js \
    && chmod +x /usr/local/sbin/startup \
    && apt-get update \
    && apt-get -y --no-install-recommends install apt-utils \
    && apt-get -y dist-upgrade \
    && apt-get -y --no-install-recommends install dumb-init cron locales \
    && echo 'LANG="en_US.UTF-8"' > /etc/default/locale \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ENTRYPOINT [ "/usr/bin/dumb-init", "--", "/usr/local/sbin/startup" ]
CMD [ "apache2-foreground" ]
