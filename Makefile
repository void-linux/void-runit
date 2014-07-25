PREFIX ?=	/usr/local
SCRIPTS=	1 2 3 ctrlaltdel

all:
	$(CC) $(CFLAGS) halt.c -o halt
	$(CC) $(CFLAGS) pause.c -o pause

install:
	install -d ${DESTDIR}/${PREFIX}/bin
	install -m755 halt ${DESTDIR}/${PREFIX}/bin
	install -m755 pause ${DESTDIR}/${PREFIX}/bin
	install -m755 suspend ${DESTDIR}/${PREFIX}/bin
	install -m755 shutdown.sh ${DESTDIR}/${PREFIX}/bin/shutdown
	install -m755 zzz ${DESTDIR}/${PREFIX}/bin
	ln -s zzz ${DESTDIR}/${PREFIX}/bin/ZZZ
	ln -s halt ${DESTDIR}/${PREFIX}/bin/poweroff
	ln -s halt ${DESTDIR}/${PREFIX}/bin/reboot
	install -d ${DESTDIR}/${PREFIX}/share/man/man1
	install -m644 pause.1 ${DESTDIR}/${PREFIX}/share/man/man1
	install -d ${DESTDIR}/${PREFIX}/share/man/man8
	install -m644 zzz.8 ${DESTDIR}/${PREFIX}/share/man/man8
	install -d ${DESTDIR}/etc/sv
	install -d ${DESTDIR}/etc/runit/runsvdir
	install -m755 ${SCRIPTS} ${DESTDIR}/etc/runit
	install -m644 rc.conf ${DESTDIR}/etc
	install -d ${DESTDIR}/${PREFIX}/lib/dracut/dracut.conf.d
	install -m644 dracut/*.conf ${DESTDIR}/${PREFIX}/lib/dracut/dracut.conf.d
	cp -aP runsvdir/* ${DESTDIR}/etc/runit/runsvdir/
	cp -aP services/* ${DESTDIR}/etc/sv/

clean:
	-rm -f halt pause suspend
