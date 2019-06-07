all:

install:
	install -d ${DESTDIR}/etc/sv/
	cp -R --no-dereference --preserve=mode,links -v sv/* ${DESTDIR}/etc/sv/
	install -m644 rc.conf ${DESTDIR}/etc
	install -m755 rc.local ${DESTDIR}/etc
	install -m755 rc.shutdown ${DESTDIR}/etc
	install -d ${DESTDIR}/${PREFIX}/lib/dracut/dracut.conf.d
	install -m644 dracut/*.conf ${DESTDIR}/${PREFIX}/lib/dracut/dracut.conf.d
	$(MAKE) -C runit install

.PHONY: all install
