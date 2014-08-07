# vim: set ts=4 sw=4 et:

[ -n "$VIRTUALIZATION" ] && return 0

if [ -x /usr/lib/systemd/systemd-udevd ]; then
    _udevd=/usr/lib/systemd/systemd-udevd
elif [ -x /usr/sbin/udevd ]; then
    _udevd=/usr/sbin/udevd
else
    msg_warn "cannot find udevd!\n"
fi

if [ -n "${_udevd}" ]; then
    msg "Starting udev and waiting for devices to settle...\n"
    ${_udevd} --daemon
    udevadm trigger --action=add --type=subsystems
    udevadm trigger --action=add --type=devices
    udevadm settle
fi
