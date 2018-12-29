FROM mattermost/mattermost-preview:latest
LABEL maintainer="https://qiita.com/k1tajima"

ENV MATTERMOST_HOME=/mm/mattermost
VOLUME ["$MATTERMOST_HOME/config","$MATTERMOST_HOME/mattermost-data"]

# Install wget.
RUN apt-get -y install wget

# Set default character set to UTF8 on MySQL.
COPY my.cnf /etc/

# Store initial config
WORKDIR $MATTERMOST_HOME
RUN mkdir config_init ; \
    cp -rp config/* config_init/ ; \
    chmod 775 config_init ; \
    chmod 664 config_init/* ; \
    chown -R 1000:1000 config_init

# Activate N-gram parser on MySQL to search a sentence in Japanese.
WORKDIR /mm
COPY docker-entry_ngram.sh .
COPY reindex-ngram.sh .
RUN chmod +x docker-entry_ngram.sh reindex-ngram.sh
ENTRYPOINT ["/mm/docker-entry_ngram.sh"]

# Set Current Directory
WORKDIR $MATTERMOST_HOME