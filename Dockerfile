FROM mattermost/mattermost-preview
LABEL maintainer="https://qiita.com/k1tajima"

# Set default character set to UTF8 on MySQL.
COPY my.cnf /etc/

# Activate N-gram parser on MySQL to search a sentence in Japanese.
WORKDIR /mm
COPY docker-entry_ngram.sh .
RUN chmod +x docker-entry_ngram.sh
ENTRYPOINT ["./docker-entry_ngram.sh"]

# Add mount points
# VOLUME /mm/mattermost/mattermost-data /mm/mattermost/config