## Runit init scripts for void

This repository contains the runit init scripts for the Void Linux distribution.

### How to use it

    # xbps-install -Sy runit-void
    
Append `init=/usr/bin/runit-init` to the kernel cmdline, I'd suggest you to use `/etc/default/grub`:

    ...
    GRUB_CMDLINE_LINUX_DEFAULT="loglevel=4 init=/usr/bin/runit-init"
    ...
    
and then update GRUB's configuration file:

    # update-grub
    
Enjoy!
  
