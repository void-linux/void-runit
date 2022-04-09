if [ -z "$VIRTUALIZATION" ]; then
    msg "Unmounting filesystems, disabling swap..."
    swapoff -a
    umount -r -a -t nosysfs,noproc,nodevtmpfs,notmpfs
    msg "Remounting rootfs read-only..."
    mount -o remount,ro /
fi

sync

if [ -z "$VIRTUALIZATION" ]; then
    deactivate_vgs
    deactivate_crypt
fi
