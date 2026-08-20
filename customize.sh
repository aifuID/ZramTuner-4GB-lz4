#!/system/bin/sh
# ==============================================
#  ZRAM 4GB+lz4 COOL EDITION | v5.3
#  (c) @aifu-ID x AI
# ==============================================

ui_print "=================================="
ui_print " Zram 4GB+lz4 Cool Edition"
ui_print " v5.3 - Cool Compromise"
ui_print " (c) @aifu-ID x AI"
ui_print "=================================="
ui_print " "
ui_print " - ZRAM 4GB + lz4"
ui_print " - Swappiness 10"
ui_print " "

# easter egg: ASCII art Evangelion
if [ -f $MODPATH/evangelion.txt ]; then
    while IFS= read -r line; do
        ui_print "$line"
    done < $MODPATH/evangelion.txt
fi

ui_print " "
ui_print " Reboot now."
