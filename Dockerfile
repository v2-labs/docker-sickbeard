FROM alpine:3.9
MAINTAINER Juvenal A. Silva Jr. <juvenal.silva.jr@gmail.com>

# Set SickBeard version to build
ENV VERSION development

# set python to use utf-8 rather than ascii
ENV PYTHONIOENCODING="UTF-8"

# Create user and group for SABnzbd.
RUN addgroup -S -g 666 sickbeard \
    && adduser -S -u 666 -G sickbeard -h /home/sickbeard -s /bin/sh sickbeard

# This is SABnzbd basic install with requirements
RUN apk add --no-cache ca-certificates openssl python py-pip shadow \
    && cd /opt \
    && wget -O- https://github.com/midgetspy/Sick-Beard/archive/$VERSION.tar.gz | tar -zx \
    && mv Sick-Beard-$VERSION sickbeard \
    && cd sickbeard \
    && pip install -r requirements.txt \
    && mkdir -p /etc/sickbeard/ \
    && mkdir -p /mnt/sickbeard/watch \
    && mkdir -p /mnt/sickbeard/shows \
    && mkdir -p /mnt/sickbeard/downloads

# Add SABnzbd init script.
COPY entrypoint.sh /home/sickbeard/entrypoint.sh
RUN chmod 755 /home/sickbeard/entrypoint.sh

VOLUME ["/etc/sickbeard", "/mnt/sickbeard/watch", "/mnt/sickbeard/shows", "/mnt/sickbeard/downloads"]

EXPOSE 8081

WORKDIR /home/sickbeard

CMD ["./entrypoint.sh"]
