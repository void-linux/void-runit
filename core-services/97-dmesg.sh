# vim: set ts=4 sw=4 et:

dmesg >/var/log/dmesg.log
if [ $(sysctl -n kernel.dmesg_restrict 2>/dev/null) -eq 1 ]; then
	chmod 0600 /var/log/dmesg.log
else
	chmod 0644 /var/log/dmesg.log
fi
