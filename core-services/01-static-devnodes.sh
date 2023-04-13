# Some kernel modules must be loaded before starting udev(7).
# Load them by looking at the output of `kmod static-nodes`.

for f in $(kmod static-nodes -f devname 2>/dev/null|cut -d' ' -f1); do
	modprobe -bq $f 2>/dev/null
done
