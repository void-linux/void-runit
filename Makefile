SCRIPTS=	1 2 3 ctrlaltdel

all:
	$(CC) $(CFLAGS) halt.c -o halt
	$(CC) $(CFLAGS) pause.c -o pause

install:
	install -d ${DESTDIR}/${PREFIX}/bin
	install -m755 halt ${DESTDIR}/${PREFIX}/bin
	install -m755 pause ${DESTDIR}/${PREFIX}/bin
	ln -s halt ${DESTDIR}/${PREFIX}/bin/poweroff
	ln -s halt ${DESTDIR}/${PREFIX}/bin/reboot
	install -d ${DESTDIR}/${PREFIX}/share/man/man1
	install -m644 pause.1 ${DESTDIR}/${PREFIX}/share/man/man1
	install -d ${DESTDIR}/etc/sv
	install -d ${DESTDIR}/etc/runit/runsvdir
	install -m755 ${SCRIPTS} ${DESTDIR}/etc/runit
	install -m644 rc.conf ${DESTDIR}/etc
	cp -aP runsvdir/* ${DESTDIR}/etc/runit/runsvdir/
	cp -aP services/* ${DESTDIR}/etc/sv/
