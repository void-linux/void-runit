export PREFIX ?= /usr/local

all:
	$(MAKE) -C cmd

install:
	$(MAKE) -C cmd install
	$(MAKE) -C man install
	$(MAKE) -C config install

clean:
	$(MAKE) -C cmd clean

.PHONY: all install clean
