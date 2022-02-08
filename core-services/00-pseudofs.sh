# vim: set ts=4 sw=4 et:

msg "Mounting pseudo-filesystems..."
mountpoint -q /proc || mount -o nosuid,noexec,nodev -t proc proc /proc
mountpoint -q /sys || mount -o nosuid,noexec,nodev -t sysfs sys /sys
mountpoint -q /run || mount -o mode=0755,nosuid,nodev -t tmpfs run /run
mountpoint -q /dev || mount -o mode=0755,nosuid -t devtmpfs dev /dev
mkdir -p -m0755 /run/runit /run/lvm /run/user /run/lock /run/log /dev/pts /dev/shm
mountpoint -q /dev/pts || mount -o mode=0620,gid=5,nosuid,noexec -n -t devpts devpts /dev/pts
mountpoint -q /dev/shm || mount -o mode=1777,nosuid,nodev -n -t tmpfs shm /dev/shm
mountpoint -q /sys/kernel/security || mount -n -t securityfs securityfs /sys/kernel/security

if [ -d /sys/firmware/efi/efivars ]; then
    mountpoint -q /sys/firmware/efi/efivars || mount -o nosuid,noexec,nodev -t efivarfs efivarfs /sys/firmware/efi/efivars
fi

if [ -z "$VIRTUALIZATION" ]; then
    _cgroupv1=""
    _cgroupv2=""

    case "${CGROUP_MODE:-hybrid}" in
        legacy)
            _cgroupv1="/sys/fs/cgroup"
            ;;
        hybrid)
            _cgroupv1="/sys/fs/cgroup"
            _cgroupv2="${_cgroupv1}/unified"
            ;;
        unified)
            _cgroupv2="/sys/fs/cgroup"
            ;;
    esac

    # cgroup v1
    if [ -n "$_cgroupv1" ]; then
        mountpoint -q "$_cgroupv1" || mount -o mode=0755 -t tmpfs cgroup "$_cgroupv1"
        while read -r _subsys_name _hierarchy _num_cgroups _enabled; do
            [ "$_enabled" = "1" ] || continue
            _controller="${_cgroupv1}/${_subsys_name}"
            mkdir -p "$_controller"
            mountpoint -q "$_controller" || mount -t cgroup -o "$_subsys_name" cgroup "$_controller"
        done < /proc/cgroups
    fi

    # cgroup v2
    if [ -n "$_cgroupv2" ]; then
        mkdir -p "$_cgroupv2"
        mountpoint -q "$_cgroupv2" || mount -t cgroup2 -o nsdelegate cgroup2 "$_cgroupv2"
    fi
fi
