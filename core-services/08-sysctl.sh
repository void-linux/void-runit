# vim: set ts=4 sw=4 et:

if [ -x /sbin/sysctl -o -x /bin/sysctl ]; then
    msg "Loading sysctl(8) settings..."
    for i in /run/sysctl.d/*.conf \
        /etc/sysctl.d/*.conf \
        /usr/local/lib/sysctl.d/*.conf \
        /usr/lib/sysctl.d/*.conf \
        /etc/sysctl.conf; do

        if [ -e "$i" ]; then
            printf '* Applying %s ...\n' "$i"
            sysctl -p "$i"
        fi
    done
fi
