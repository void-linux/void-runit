# vim: set ts=4 sw=4 et:

msg "Mounting pseudo-filesystems...\n"
mountpoint -q /proc || mount -t proc proc /proc -o nosuid,noexec,nodev
mountpoint -q /sys || mount -t sysfs sys /sys -o nosuid,noexec,nodev
mountpoint -q /run || mount -t tmpfs run /run -o mode=0755,nosuid,nodev
mountpoint -q /dev || mount -t devtmpfs dev /dev -o mode=0755,nosuid
mkdir -p -m0755 /run/runit /run/lvm /run/user /dev/pts /dev/shm
mountpoint -q /dev/pts || mount -n -t devpts devpts /dev/pts -o mode=0620,gid=5,nosuid,noexec
mountpoint -q /dev/shm || mount -n -t tmpfs shm /dev/shm -o mode=1777,nosuid,nodev
mountpoint -q /sys/fs/cgroup || mount -t tmpfs cgroup /sys/fs/cgroup -o mode=0755
awk '$4==1 { system("mountpoint -q /sys/fs/cgroup/" $1 " || mount -t cgroup -o " $1 ",x-mount.mkdir cgroup /sys/fs/cgroup/" $1) }' /proc/cgroups
