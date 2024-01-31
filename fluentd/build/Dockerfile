FROM fluentd:v1.16.2-1.1

# Use root account to use apk
USER root

# below RUN includes plugin as examples elasticsearch is not required
# you may customize including plugins as you wish
RUN apk add --no-cache --update --virtual .build-deps \
        sudo build-base ruby-dev \
 && sudo gem install fluent-plugin-opensearch \
 && sudo gem sources --clear-all \
 && apk del .build-deps \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem \
 && mkdir -p /opt/logs/positions \
 && chown fluent /opt/logs/positions

### How to install elasticsearch plugin
# sudo gem install fluent-plugin-elasticsearch

### How to install Loki plugin
# sudo gem install fluent-plugin-grafana-loki

## Copy default config file
#COPY fluent.conf /fluentd/etc/
COPY entrypoint.sh /bin/

USER fluent
