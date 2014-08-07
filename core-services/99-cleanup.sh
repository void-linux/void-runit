#!/bin/sh

install -m0664 -o root -g utmp /dev/null /run/utmp
install -dm1777 /tmp/.X11-unix /tmp/.ICE-unix
rm -f /etc/nologin /forcefsck /forcequotacheck /fastboot
