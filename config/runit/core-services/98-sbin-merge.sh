if [ -d /usr/sbin -a ! -L /usr/sbin ]; then
	for f in /usr/sbin/*; do
		if [ -f $f -a ! -L $f ]; then
			msg "Detected $f file, can't create /usr/sbin symlink."
			return 0
		fi
	done
	msg "Creating /usr/sbin -> /usr/bin symlink, moving existing to /usr/sbin.old"
	mv /usr/sbin /usr/sbin.old
	ln -sf bin /usr/sbin
fi
