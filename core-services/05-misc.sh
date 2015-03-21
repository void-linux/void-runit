# vim: set ts=4 sw=4 et:

msg "Initializing random seed..."
cp /var/lib/random-seed /dev/urandom >/dev/null 2>&1 || true
( umask 077; dd if=/dev/urandom of=/var/lib/random-seed count=1 bs=512 >/dev/null 2>&1 )

msg "Setting up loopback interface..."
ip link set up dev lo

[ -r /etc/hostname ] && read -r HOSTNAME < /etc/hostname
if [ -n "$HOSTNAME" ]; then
    msg "Setting up hostname to '${HOSTNAME}'..."
    echo "$HOSTNAME" > /proc/sys/kernel/hostname
else
    msg_warn "Didn't setup a hostname!"
fi

if [ -n "$TIMEZONE" ]; then
    msg "Setting up timezone to '${TIMEZONE}'..."
    ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
fi
