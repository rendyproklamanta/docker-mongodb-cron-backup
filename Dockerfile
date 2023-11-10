FROM mongo
LABEL maintainer "Fco. Javier Delgado del Hoyo <frandelhoyo@gmail.com>"

RUN apt-get update && apt-get install -y cron && rm -rf /var/lib/apt/lists/*

# Install dos2unix
RUN apt-get update && \
    apt-get install -y --no-install-recommends util-linux dos2unix && \
    rm -rf /var/lib/apt/lists/*

COPY ["run.sh", "backup.sh", "restore.sh", "/"]
RUN dos2unix /run.sh /backup.sh /restore.sh
RUN chmod u+x /run.sh /backup.sh /restore.sh

RUN mkdir /backup
VOLUME ["/backup"]

CMD ["/run.sh"]
