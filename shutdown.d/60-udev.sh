if [ -z "$IS_CONTAINER" ]; then
    msg "Stopping udev..."
    udevadm control --exit
fi
