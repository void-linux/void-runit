#!/bin/sh
# vim: set ts=4 sw=4 et:

. /etc/runit/functions
[ -r /etc/rc.conf ] && . /etc/rc.conf

install -m0664 -o root -g utmp /dev/null /run/utmp
install -dm1777 /tmp/.X11-unix /tmp/.ICE-unix
rm -f /etc/nologin /forcefsck /forcequotacheck /fastboot
