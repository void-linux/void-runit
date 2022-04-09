if [ -z "$VIRTUALIZATION" ]; then
    msg "Stopping udev..."
    udevadm control --exit
fi
