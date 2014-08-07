#!/bin/sh
# vim: set ts=4 sw=4 et:

. /etc/runit/functions
[ -r /etc/rc.conf ] && . /etc/rc.conf

[ -n "$VIRTUALIZATION" ] && return 0

msg "Setting up TTYs to unicode mode...\n"
for i in /dev/tty[0-6]; do
    unicode_start < $i
done

if [ -n "$FONT" ]; then
    msg "Setting up TTYs font to '${FONT}'...\n"
    for i in /dev/tty[0-6]; do
        setfont ${FONT_MAP:+-m $FONT_MAP} ${FONT_UNIMAP:+-u $FONT_UNIMAP} $FONT -C $i
    done
fi

msg "Setting up keymap to '${KEYMAP:-us}'...\n"
loadkeys -q -u ${KEYMAP:-us}
