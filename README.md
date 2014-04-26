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

Feel free to send patches and contribute with improvments and/or new services!
