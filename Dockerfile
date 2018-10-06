FROM mattermost/mattermost-preview:5.3.1
LABEL maintainer="https://qiita.com/k1tajima"

ENV MATTERMOST_HOME=/mm/mattermost
VOLUME ["$MATTERMOST_HOME/config","$MATTERMOST_HOME/mattermost-data"]

# Install wget.
RUN apt-get -y install wget

# Set default character set to UTF8 on MySQL.
COPY my.cnf /etc/

# Store initial config
RUN cp -rp $MATTERMOST_HOME/config/ $MATTERMOST_HOME/config_init/

# Activate N-gram parser on MySQL to search a sentence in Japanese.
WORKDIR /mm
COPY docker-entry_ngram.sh .
COPY reindex-ngram.sh .
RUN chmod +x docker-entry_ngram.sh reindex-ngram.sh
ENTRYPOINT ["/mm/docker-entry_ngram.sh"]

# Make symbolic link as /usr/local/bin/mattermost.
RUN ln -s $MATTERMOST_HOME/bin/mattermost /usr/local/bin/mattermost \
    && chmod +x /usr/local/bin/mattermost

# Set Current Directory
WORKDIR $MATTERMOST_HOME