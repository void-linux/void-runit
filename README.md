## Runit init scripts for void

This repository contains the runit init scripts for the Void Linux distribution.

This is loosely based on https://github.com/chneukirchen/ignite but with the
difference that I'm trying to avoid the bash dependency.

### How to use it

    # xbps-install -Sy runit-void
    
Append `init=/usr/bin/runit-init` to the kernel cmdline, I'd suggest you to use `/etc/default/grub`:

    ...
    GRUB_CMDLINE_LINUX_DEFAULT="loglevel=4 init=/usr/bin/runit-init"
    ...
    
and then update GRUB's configuration file:

    # update-grub

reboot and runit will kick in and start services in "default" runlevel (multi-user).

To see enabled services for "current" runlevel:

    $ ls /var/service

To see available runlevels (default and single, which just runs sulogin):

    $ ls /etc/runit/runsvdir

To enable and start a service:

    $ ln -s /etc/sv/<service> /var/service

To disable and remove a service:

    $ rm -f /var/service/<service>

Feel free to send patches and contribute with improvments and/or new services!
