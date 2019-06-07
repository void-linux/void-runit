all:
	$(CC) $(CFLAGS) halt.c -o halt $(LDFLAGS)
	$(CC) $(CFLAGS) pause.c -o pause $(LDFLAGS)
	$(CC) $(CFLAGS) vlogger.c -o vlogger $(LDFLAGS)

install:
	install -d ${DESTDIR}/${PREFIX}/sbin
	install -m755 halt ${DESTDIR}/${PREFIX}/sbin
	install -m755 pause ${DESTDIR}/${PREFIX}/sbin
	install -m755 vlogger ${DESTDIR}/${PREFIX}/sbin
	install -m755 shutdown ${DESTDIR}/${PREFIX}/sbin/shutdown
	install -m755 modules-load ${DESTDIR}/${PREFIX}/sbin/modules-load
	install -m755 zzz ${DESTDIR}/${PREFIX}/sbin
	ln -sf zzz ${DESTDIR}/${PREFIX}/sbin/ZZZ
	ln -sf halt ${DESTDIR}/${PREFIX}/sbin/poweroff
	ln -sf halt ${DESTDIR}/${PREFIX}/sbin/reboot

clean:
	-rm -f halt pause vlogger

.PHONY: all install clean
