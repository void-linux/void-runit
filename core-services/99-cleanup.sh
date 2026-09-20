# vim: set ts=4 sw=4 et:

# runsvchdir chokes if the current and/or previous symlinks are broken
if [ -e /etc/runit/runsvdir/previous ]; then
	rm /etc/runit/runsvdir/previous
fi
if [ -e /etc/runit/runsvdir/current ]; then
	rm /etc/runit/runsvdir/current
fi
# Set the initial runlevel to 'default', even if a different one
# is being selected through the kernel command line (see /etc/runit/2)
ln -s default /etc/runit/runsvdir/current

if [ ! -e /var/log/wtmp ]; then
	install -m0664 -o root -g utmp /dev/null /var/log/wtmp
fi
if [ ! -e /var/log/btmp ]; then
	install -m0600 -o root -g utmp /dev/null /var/log/btmp
fi
if [ ! -e /var/log/lastlog ]; then
	install -m0600 -o root -g utmp /dev/null /var/log/lastlog
fi
install -dm1777 /tmp/.X11-unix /tmp/.ICE-unix
rm -f /etc/nologin /forcefsck /forcequotacheck /fastboot
