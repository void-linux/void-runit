# vim: set ts=4 sw=4 et:

[ -n "$VIRTUALIZATION" ] && return 0

msg "Remounting rootfs read-only..."
mount -o remount,ro / || emergency_shell

if [ -x /sbin/dmraid -o -x /bin/dmraid ]; then
    msg "Activating dmraid devices..."
    dmraid -i -ay
fi

if [ -x /bin/btrfs ]; then
    msg "Activating btrfs devices..."
    btrfs device scan || emergency_shell
fi

if [ -x /sbin/vgchange -o -x /bin/vgchange ]; then
    msg "Activating LVM devices..."
    vgchange --sysinit -a ay || emergency_shell
fi

if [ -e /etc/crypttab ]; then
    msg "Activating encrypted devices..."
    awk -f /etc/runit/crypt.awk /etc/crypttab

    if [ -x /sbin/vgchange -o -x /bin/vgchange ]; then
        msg "Activating LVM devices for dm-crypt..."
        vgchange --sysinit -a ay || emergency_shell
    fi
fi

if [ -x /usr/bin/zpool -a -x /usr/bin/zfs ]; then
    if [ -e /etc/zfs/zpool.cache ]; then
        msg "Importing cached ZFS pools..."
        zpool import -N -a -c /etc/zfs/zpool.cache
    else
        msg "Scanning for and importing ZFS pools..."
        zpool import -N -a -o cachefile=none
    fi

    msg "Mounting ZFS file systems..."
    zfs mount -a -l

    msg "Sharing ZFS file systems..."
    zfs share -a

    # NOTE(dh): ZFS has ZVOLs, block devices on top of storage pools.
    # In theory, it would be possible to use these as devices in
    # dmraid, btrfs, LVM and so on. In practice it's unlikely that
    # anybody is doing that, so we aren't supporting it for now.
fi

[ -f /fastboot ] && FASTBOOT=1
[ -f /forcefsck ] && FORCEFSCK="-f"
for arg in $(cat /proc/cmdline); do
    case $arg in
        fastboot) FASTBOOT=1;;
        forcefsck) FORCEFSCK="-f";;
    esac
done

if [ -z "$FASTBOOT" ]; then
    msg "Checking filesystems:"
    fsck -A -T -a -t noopts=_netdev $FORCEFSCK
    if [ $? -gt 1 ]; then
        emergency_shell
    fi
fi

msg "Mounting rootfs read-write..."
mount -o remount,rw / || emergency_shell

msg "Mounting all non-network filesystems..."
mount -a -t "nosysfs,nonfs,nonfs4,nosmbfs,nocifs" -O no_netdev || emergency_shell
