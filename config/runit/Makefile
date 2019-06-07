all:

install:
	install -d ${DESTDIR}/etc/runit/runsvdir
	cp -R --no-dereference --preserve=mode,links -v runsvdir/* ${DESTDIR}/etc/runit/runsvdir/
	install -d ${DESTDIR}/etc/runit/core-services
	install -m644 core-services/*.sh ${DESTDIR}/etc/runit/core-services
	install -m755 1 2 3 ctrlaltdel ${DESTDIR}/etc/runit
	install -m644 functions $(DESTDIR)/etc/runit
	install -m644 crypt.awk  ${DESTDIR}/etc/runit
	ln -sf /run/runit/reboot ${DESTDIR}/etc/runit/
	ln -sf /run/runit/stopit ${DESTDIR}/etc/runit/

.PHONY: all install
