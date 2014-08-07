#!/bin/sh
# vim: set ts=4 sw=4 et:

. /etc/runit/functions
[ -r /etc/rc.conf ] && . /etc/rc.conf

[ -n "$VIRTUALIZATION" ] && return 0

msg "Initializing swap...\n"
swapon -a || emergency_shell
