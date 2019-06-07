all:

install:
	install -d ${DESTDIR}/${PREFIX}/share/man/man1
	install -m644 pause.1 ${DESTDIR}/${PREFIX}/share/man/man1
	install -d ${DESTDIR}/${PREFIX}/share/man/man8
	install -m644 zzz.8 ${DESTDIR}/${PREFIX}/share/man/man8
	install -m644 shutdown.8 ${DESTDIR}/${PREFIX}/share/man/man8
	install -m644 halt.8 ${DESTDIR}/${PREFIX}/share/man/man8
	install -m644 modules-load.8 ${DESTDIR}/${PREFIX}/share/man/man8
	install -m644 vlogger.8 ${DESTDIR}/${PREFIX}/share/man/man8
	ln -sf halt.8 ${DESTDIR}/${PREFIX}/share/man/man8/poweroff.8
	ln -sf halt.8 ${DESTDIR}/${PREFIX}/share/man/man8/reboot.8
	ln -sf zzz.8 ${DESTDIR}/${PREFIX}/share/man/man8/ZZZ.8

.PHONY: all install
