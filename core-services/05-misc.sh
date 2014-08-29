# vim: set ts=4 sw=4 et:

msg "Initializing random seed...\n"
cp /var/lib/random-seed /dev/urandom >/dev/null 2>&1 || true
( umask 077; dd if=/dev/urandom of=/var/lib/random-seed count=1 bs=512 >/dev/null 2>&1 )

msg "Setting up loopback interface...\n"
ip link set up dev lo

if [ -n "$HOSTNAME" ]; then
    echo "$HOSTNAME" > /proc/sys/kernel/hostname
elif [ -r /etc/hostname ]; then
    HOSTNAME=$(cat /etc/hostname)
    echo "$HOSTNAME" > /proc/sys/kernel/hostname
fi
msg "Setting up hostname to '${HOSTNAME}'...\n"

if [ -n "$TIMEZONE" ]; then
    msg "Setting up timezone to '${TIMEZONE}'...\n"
    ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
fi
