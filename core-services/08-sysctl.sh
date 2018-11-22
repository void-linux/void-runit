# vim: set ts=4 sw=4 et:

if [ -x /sbin/sysctl -o -x /bin/sysctl ]; then
    msg "Loading sysctl(8) settings..."
    for file in $(system-dirs sysctl.d) /etc/sysctl.conf; do
        if [ -e "$file" ]; then
            msg "Applying ${file} ..."
            sysctl -p "$file"
        fi
    done
fi
