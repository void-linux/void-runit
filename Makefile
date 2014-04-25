SCRIPTS=	1 2 3 ctrlaltdel

install:
	install -d ${DESTDIR}/etc/sv
	install -d ${DESTDIR}/etc/runit/runsvdir
	install -m755 ${SCRIPTS} ${DESTDIR}/etc/runit
	install -m644 rc.conf ${DESTDIR}/etc
	cp -aP runsvdir/* ${DESTDIR}/etc/runit/runsvdir/
	cp -aP services/* ${DESTDIR}/etc/sv/
