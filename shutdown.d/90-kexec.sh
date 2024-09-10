if [ -z "$IS_CONTAINER" ]; then
    # test -x returns false on a noexec mount, hence using find to detect x bit
    if [ -n "$(find /run/runit/reboot -perm -u+x 2>/dev/null)" ] &&
        command -v kexec >/dev/null
    then
        msg "Triggering kexec..."
        kexec -e 2>/dev/null
        # not reached when kexec was successful.
    fi
fi
