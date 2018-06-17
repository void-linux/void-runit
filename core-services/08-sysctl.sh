# vim: set ts=4 sw=4 et:

if [ -x /sbin/sysctl -o -x /bin/sysctl ]; then
    msg "Loading sysctl(8) settings..."
    mkdir /run/sysctl
    for i in /run/sysctl.d/*.conf \
        /etc/sysctl.d/*.conf \
        /usr/local/lib/sysctl.d/*.conf \
        /usr/lib/sysctl.d/*.conf \
        /etc/sysctl.conf; do

        fname="/run/sysctl/${i##*/}"
        if [ -e "$i" ] && [ ! -e "$fname" -o "$i" = "/etc/sysctl.conf" ]; then
            printf '* Applying %s ...\n' "$i"
            sysctl -p "$i"
            touch "$fname"
        fi
    done
    rm -rf /run/sysctl
fi
