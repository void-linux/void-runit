# vim: set ts=4 sw=4 et:

if [ -x /sbin/sysctl -o -x /bin/sysctl ]; then
    msg "Loading sysctl(8) settings...\n"

    if sysctl -V >/dev/null 2>&1; then
        sysctl --system
    else
        # Fallback for busybox sysctl
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
fi
