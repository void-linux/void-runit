export PREFIX ?= /usr/local

all:
	mkdir -p build
	$(CC) $(CFLAGS) cmd/halt.c -o build/halt $(LDFLAGS)
	$(CC) $(CFLAGS) cmd/pause.c -o build/pause $(LDFLAGS)
	$(CC) $(CFLAGS) cmd/vlogger.c -o build/vlogger $(LDFLAGS)

install: install.cmd install.man install.config

install.cmd:
	install -d ${DESTDIR}/${PREFIX}/bin
	install -m755 build/halt ${DESTDIR}/${PREFIX}/bin
	install -m755 build/pause ${DESTDIR}/${PREFIX}/bin
	install -m755 build/vlogger ${DESTDIR}/${PREFIX}/bin
	install -m755 cmd/shutdown ${DESTDIR}/${PREFIX}/bin
	install -m755 cmd/modules-load ${DESTDIR}/${PREFIX}/bin
	install -m755 cmd/zzz ${DESTDIR}/${PREFIX}/bin
	ln -sf zzz ${DESTDIR}/${PREFIX}/bin/ZZZ
	ln -sf halt ${DESTDIR}/${PREFIX}/bin/poweroff
	ln -sf halt ${DESTDIR}/${PREFIX}/bin/reboot

install.man:
	install -d ${DESTDIR}/${PREFIX}/share/man/man1
	install -m644 man/pause.1 ${DESTDIR}/${PREFIX}/share/man/man1
	install -d ${DESTDIR}/${PREFIX}/share/man/man8
	install -m644 man/zzz.8 ${DESTDIR}/${PREFIX}/share/man/man8
	install -m644 man/shutdown.8 ${DESTDIR}/${PREFIX}/share/man/man8
	install -m644 man/halt.8 ${DESTDIR}/${PREFIX}/share/man/man8
	install -m644 man/modules-load.8 ${DESTDIR}/${PREFIX}/share/man/man8
	install -m644 man/vlogger.8 ${DESTDIR}/${PREFIX}/share/man/man8
	ln -sf halt.8 ${DESTDIR}/${PREFIX}/share/man/man8/poweroff.8
	ln -sf halt.8 ${DESTDIR}/${PREFIX}/share/man/man8/reboot.8
	ln -sf zzz.8 ${DESTDIR}/${PREFIX}/share/man/man8/ZZZ.8

install.config:
	install -d ${DESTDIR}/etc/sv/
	cp -R --no-dereference --preserve=mode,links -v config/sv/* ${DESTDIR}/etc/sv/
	install -m644 config/rc.conf ${DESTDIR}/etc
	install -m755 config/rc.local ${DESTDIR}/etc
	install -m755 config/rc.shutdown ${DESTDIR}/etc
	install -d ${DESTDIR}/${PREFIX}/lib/dracut/dracut.conf.d
	install -m644 config/dracut/*.conf ${DESTDIR}/${PREFIX}/lib/dracut/dracut.conf.d
	install -d ${DESTDIR}/etc/runit/runsvdir
	cp -R --no-dereference --preserve=mode,links -v config/runit/runsvdir/* ${DESTDIR}/etc/runit/runsvdir/
	install -d ${DESTDIR}/etc/runit/core-services
	install -m644 config/runit/core-services/*.sh ${DESTDIR}/etc/runit/core-services
	install -m755 config/runit/1 ${DESTDIR}/etc/runit
	install -m755 config/runit/2 ${DESTDIR}/etc/runit
	install -m755 config/runit/3 ${DESTDIR}/etc/runit
	install -m755 config/runit/ctrlaltdel ${DESTDIR}/etc/runit
	install -m644 config/runit/functions ${DESTDIR}/etc/runit
	install -m644 config/runit/crypt.awk ${DESTDIR}/etc/runit
	ln -sf /run/runit/reboot ${DESTDIR}/etc/runit/
	ln -sf /run/runit/stopit ${DESTDIR}/etc/runit/

clean:
	-rm -rf -- build

.PHONY: all install install.cmd install.man install.config clean
