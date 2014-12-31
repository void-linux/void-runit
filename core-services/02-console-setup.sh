# vim: set ts=4 sw=4 et:

[ -n "$VIRTUALIZATION" ] && return 0

if [ -n "$FONT" ]; then
    msg "Setting up TTYs font to '${FONT}'...\n"
    for i in /dev/tty[0-6]; do
        setfont ${FONT_MAP:+-m $FONT_MAP} ${FONT_UNIMAP:+-u $FONT_UNIMAP} $FONT -C $i
    done
fi

if [ -n "$KEYMAP" ]; then
    msg "Setting up keymap to '${KEYMAP}'...\n"
    loadkeys -q -u ${KEYMAP}
fi

if [ -n "$HARDWARECLOCK" ]; then
    msg "Setting up RTC to '${HARDWARECLOCK}'...\n"
    TZ=$TIMEZONE hwclock --systz \
        ${HARDWARECLOCK:+--$(echo $HARDWARECLOCK |tr A-Z a-z) --noadjfile} || emergency_shell
fi
