#!/system/bin/sh
# ==============================================
#  ZRAM 4GB+lz4 COOL EDITION | customize.sh v5.2
#  (c) @aifu-ID x AI
# ==============================================

ui_print "*********************************"
ui_print " Zram 4GB+lz4 Cool Edition"
ui_print " by aifu-ID"
ui_print "*********************************"
ui_print "*************************"
ui_print " Powered by KernelSU"
ui_print "*************************"
ui_print "========================================"
ui_print "  ZRAM 4GB+lz4 - COOL EDITION v5.2"
ui_print "========================================"

if [ -f $MODPATH/evangelion.txt ]; then
    while IFS= read -r line; do
        ui_print "$line"
    done < $MODPATH/evangelion.txt
fi

ui_print "  ZRAM 4GB+lz4 COOL EDITION | (c) @aifu-ID x AI"

ZRAM=/dev/block/zram0
SYS=/sys/block/zram0

ui_print "kernel support:"
ui_print "$(cat $SYS/comp_algorithm)"

sed -i 's/^description=.*/description=(c) @aifu-ID x AI - zram 4GB+lz4+swappiness20/' $MODPATH/module.prop

BUSY=""
for p in /data/adb/ksu/bin/busybox /data/adb/ap/bin/busybox /data/adb/kernelsu/bin/busybox /system/bin/busybox; do
    [ -x "$p" ] && BUSY="$p" && break
done

ui_print "applying 4GB + lz4 + mkswap NOW..."
swapoff $ZRAM 2>/dev/null
echo 1 > $SYS/reset 2>/dev/null
echo lz4 > $SYS/comp_algorithm 2>/dev/null
echo 4294967296 > $SYS/disksize 2>/dev/null
[ -n "$BUSY" ] && $BUSY mkswap $ZRAM >/dev/null 2>&1
swapon $ZRAM 2>/dev/null

ui_print "swappiness -> 20 (Cool Edition)..."
echo 20 > /proc/sys/vm/swappiness

ui_print "now: $(cat $SYS/disksize) | $(cat $SYS/comp_algorithm) | swappiness: $(cat /proc/sys/vm/swappiness)"
ui_print "========================================"
ui_print "reboot untuk FULL CONTROL v5.2!"
