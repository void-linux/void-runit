# vim: set ts=4 sw=4 et:

# create files for controlling runit
mkdir -p /run/runit
install -m100 /dev/null /run/runit/stopit
install -m100 /dev/null /run/runit/reboot
