# vim: set ts=4 sw=4 et:

[ -n "$VIRTUALIZATION" ] && return 0

msg "Starting device manager and waiting for devices to settle..."
case $CONFIG_DEV in
	udevd)
		udevd --daemon
		udevadm trigger --action=add --type=subsystems
		udevadm trigger --action=add --type=devices
		udevadm settle
        ;;

	mdevd)
		mdevd & pid_mdevd=$!
		mdevd-coldplug
        ;;
esac
