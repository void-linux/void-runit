# vim: set ts=4 sw=4 et:

[ -n "$IS_CONTAINER" ] && return 0

msg "Initializing swap..."
swapon -a || emergency_shell
