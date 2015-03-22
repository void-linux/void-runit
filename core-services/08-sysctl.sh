# vim: set ts=4 sw=4 et:

if [ -x /sbin/sysctl ]; then
    msg "Loading sysctl(8) settings..."
    sysctl --system
fi
