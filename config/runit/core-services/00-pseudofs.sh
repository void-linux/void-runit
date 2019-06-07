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

if [ -z "$VIRTUALIZATION" ]; then
    mountpoint -q /sys/fs/cgroup || mount -o mode=0755 -t tmpfs cgroup /sys/fs/cgroup
    awk '$4 == 1 { system("mountpoint -q /sys/fs/cgroup/" $1 " || { mkdir -p /sys/fs/cgroup/" $1 " && mount -t cgroup -o " $1 " cgroup /sys/fs/cgroup/" $1 " ;}" ) }' /proc/cgroups
fi
