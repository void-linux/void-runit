# vim: set ts=4 sw=4 et:

[ -n "$VIRTUALIZATION" ] && return 0

msg "Remounting rootfs read-only...\n"
mount -o remount,ro / || emergency_shell

if [ -x /sbin/dmraid ]; then
    msg "Activating dmraid devices...\n"
    dmraid -i -ay
fi

if [ -x /bin/btrfs ]; then
    msg "Activating btrfs devices...\n"
    btrfs device scan || emergency_shell
fi

if [ -x /sbin/vgchange ]; then
    msg "Activating LVM devices...\n"
    vgchange --sysinit -a y || emergency_shell
fi

if [ -e /etc/crypttab ]; then
    msg "Activating encrypted devices...\n"
    awk '/^#/ || /^$/ { next }
         NF>2 { print "unsupported crypttab: " $0 >"/dev/stderr"; next }
         { system("cryptsetup luksOpen " $2 " " $1) }' /etc/crypttab

    if [ -x /sbin/vgchange ]; then
        msg "Activating LVM devices for dm-crypt...\n"
        vgchange --sysinit -a y || emergency_shell
    fi
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
    msg "Checking filesystems:\n"
    fsck -A -T -a -t noopts=_netdev $FORCEFSCK
    if [ $? -gt 1 ]; then
        emergency_shell
    fi
fi

msg "Mounting rootfs read-write...\n"
mount -o remount,rw / || emergency_shell

msg "Mounting all non-network filesystems...\n"
mount -a -t "nosysfs,nonfs,nonfs4,nosmbfs,nocifs" -O no_netdev || emergency_shell
