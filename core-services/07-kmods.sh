# vim: set ts=4 sw=4 et:

[ -n "$VIRTUALIZATION" ] && return 0

msg "Loading kernel modules...\n"
modules-load -v ${MODULES} | tr '\n' ' ' | sed 's:insmod [^ ]*/::g; s:\.ko\(\.gz\)\? ::g'
echo
