# vim: set ts=4 sw=4 et:

msg "Initializing random seed...\n"
cp /var/lib/random-seed /dev/urandom >/dev/null 2>&1 || true
( umask 077; dd if=/dev/urandom of=/var/lib/random-seed count=1 bs=512 >/dev/null 2>&1 )

msg "Setting up loopback interface...\n"
ip link set up dev lo

[ -r /etc/hostname ] && read -r HOSTNAME < /etc/hostname
if [ -n "$HOSTNAME" ]; then
    msg "Setting up hostname to '${HOSTNAME}'...\n"
    echo "$HOSTNAME" > /proc/sys/kernel/hostname
else
    msg_warn "Didn't setup a hostname!\n"
fi

if [ -n "$TIMEZONE" ]; then
    msg "Setting up timezone to '${TIMEZONE}'...\n"
    ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
fi
