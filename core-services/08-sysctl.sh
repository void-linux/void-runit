# vim: set ts=4 sw=4 et:

if [ -x /sbin/sysctl ]; then
    msg "Loading sysctl(8) settings...\n"
    for d in /etc/sysctl.d /usr/lib/sysctl.d; do
        [ ! -d $d ] && continue
        for x in $d/*.conf; do
            sysctl -p $x
        done
    done
fi
