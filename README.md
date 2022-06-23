# README

```
docker run -d --name sickbeard \
           -e SICKBEARD_UID=1000 \
           -e SICKBEARD_GID=100 \
           -e TZ="America/Sao Paulo" \
           -p 8081:8081 \
           -v ...:/etc/sickbeard \
           -v ...:/mnt/sickbeard/shows \
           -v ...:/mnt/sickbeard/watch \
           -v ...:/mnt/sickbeard/downloads \
           v2labs/sickbeard:latest
```


## Important notice

Like many other python services that are based on the same codebase, there are a couple os commom parameter options recognized. However, for SickBeard, the `--daemon` option, besides being recognized, can't be clearly used on a container, since the container itself remains alive if the main process _is_ alive. The `--daemon` option kills the process and doesn't and as there is no init process in it (root process 1), the whole container terminate.
