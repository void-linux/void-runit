# vim: set ts=4 sw=4 et:

if [ ! -e /var/log/wtmp ]; then
	install -m0664 -o root -g utmp /dev/null /var/log/wtmp
fi
if [ ! -e /var/log/btmp ]; then
	install -m0600 -o root -g utmp /dev/null /var/log/btmp
fi
install -dm1777 /tmp/.X11-unix /tmp/.ICE-unix
rm -f /etc/nologin /forcefsck /forcequotacheck /fastboot

msg "Killing device manager to make way for service..."
case $CONFIG_DEV in
	udevd)
		udevadm control --exit
	;;

	mdevd)
		kill "$pid_mdevd"
	;;
esac
