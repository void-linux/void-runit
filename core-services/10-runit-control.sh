# vim: set ts=4 sw=4 et:

# create files for controlling runit
mkdir -p /run/runit
install -m000 /dev/null /run/runit/stopit
install -m000 /dev/null /run/runit/reboot

# ensure runit keeps link count >0 if the binary is updated,
# so the rootfs can be remounted read-only
ln -f /bin/runit /bin/.runit.booted
