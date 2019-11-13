FROM python:3.7.0-alpine3.8
LABEL maintainer="devops@travelaudience.com, hajo@ventx.de"

ENV NEXUS_BACKUP_DIRECTORY=/nexus-data/backup
ENV NEXUS_DATA_DIRECTORY=/nexus-data
ENV NEXUS_LOCAL_HOST_PORT=localhost:8081

ENV OFFLINE_REPOS="maven-central maven-public maven-releases maven-snapshots"
ENV TARGET_BUCKET=s3://nexus-backup
ENV GRACE_PERIOD=60

ENV AWSCLI 1.16.261

RUN apk add --no-cache --update bash ca-certificates curl inotify-tools openssl
RUN pip3 install --upgrade pip
RUN pip3 install awscli==${AWSCLI}

ADD ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ADD ./start-repository.groovy /scripts/
ADD ./stop-repository.groovy /scripts/

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/ash"]
