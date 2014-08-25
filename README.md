## Runit init scripts for void

This repository contains the runit init scripts for the Void Linux distribution.

This is loosely based on https://github.com/chneukirchen/ignite but with the
difference that I'm trying to avoid the bash dependency.

### How to use it

runit is used by default in the Void distribution.
    
To see enabled services for "current" runlevel:

    $ ls -l /var/service

To see available runlevels (default and single, which just runs sulogin):

    $ ls -l /etc/runit/runsvdir

To enable and start a service into the "current" runlevel:

    # ln -s /etc/sv/<service> /var/service

To disable and remove a service:

    # rm -f /var/service/<service>

To view status of all services for "current" runlevel:

    # sv status /var/service/*
    
Feel free to send patches and contribute with improvements and/or new services!
