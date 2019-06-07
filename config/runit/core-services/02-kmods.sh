# vim: set ts=4 sw=4 et:

[ -n "$VIRTUALIZATION" ] && return 0
# Do not try to load modules if kernel does not support them.
[ ! -e /proc/modules ] && return 0

msg "Loading kernel modules..."
modules-load -v | tr '\n' ' ' | sed 's:insmod [^ ]*/::g; s:\.ko\(\.gz\)\? ::g'
echo
