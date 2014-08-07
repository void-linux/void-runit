#!/bin/sh
# vim: set ts=4 sw=4 et:

. /etc/runit/functions
[ -r /etc/rc.conf ] && . /etc/rc.conf

if [ -x /sbin/sysctl ]; then
    msg "Loading sysctl(8) settings...\n"
    sysctl --system
fi
