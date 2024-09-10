if [ -z "$IS_CONTAINER" ] && [ -n "$HARDWARECLOCK" ]; then
    hwclock --systohc ${HARDWARECLOCK:+--$(echo $HARDWARECLOCK |tr A-Z a-z)}
fi
