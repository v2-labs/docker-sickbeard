#!/bin/sh

#
# Display settings on standard out.
#

USER="sickbeard"

echo "SickBeard settings"
echo "=================="
echo
echo "  User:    ${USER}"
echo "  UID:     ${SICKBEARD_UID:=666}"
echo "  GID:     ${SICKBEARD_GID:=666}"
echo "  CHMOD:   ${FORCE_CHMOD:=false}"
echo
echo "  Config:  ${CONFIG:=/etc/sickbeard/config.ini}"
echo

#
# Change UID / GID of SABnzbd user.
#

printf "Updating UID / GID if needed... "
[[ $(id -u ${USER}) == ${SICKBEARD_UID} ]] || usermod  -o -u ${SICKBEARD_UID} ${USER}
[[ $(id -g ${USER}) == ${SICKBEARD_GID} ]] || groupmod -o -g ${SICKBEARD_GID} ${USER}
echo "[DONE]"

#
# Set directory permissions.
#

printf "Set permissions, if required... "
su -p ${USER} -c "touch ${CONFIG}"
chown -R ${USER}:${USER} \
      /home/sickbeard \
      /opt/sickbeard \
      > /dev/null 2>&1
[[ "${FORCE_CHMOD}" == "false" ]] || \
    chown -R ${USER}:${USER} \
          /etc/sickbeard \
          /mnt/sickbeard/shows \
          /mnt/sickbeard/watch \
          /mnt/sickbeard/downloads \
          > /dev/null 2>&1
echo "[DONE]"

#
# Because SickBeard runs in a container we've to make sure we've a proper
# listener on 0.0.0.0. We also have to deal with the port which by default is
# 8081 but can be changed by the user.
#

printf "Get listener port... "
PORT=$(sed -n '/^port *=/{s/port *= *//p;q}' ${CONFIG})
LISTENER="-s 0.0.0.0:${PORT:=8081}"
echo "[${PORT}]"

#
# Finally, start SickBeard.
#

echo "Starting SickBeard..."
exec su -p ${USER} -c "python -OO /opt/sickbeard/SickBeard.py --nolaunch --datadir=$(dirname ${CONFIG})"
