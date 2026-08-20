#!/system/bin/sh
# ==============================================
#  ZRAM 4GB+lz4 COOL EDITION | v5.3
#  Uninstall: restore stock ROM settings
# ==============================================

ZRAM=/dev/block/zram0
SYS=/sys/block/zram0
STOCK=/data/adb/zramtuner.stock

BUSY=""
for p in /data/adb/ksu/bin/busybox /data/adb/ap/bin/busybox /data/adb/kernelsu/bin/busybox /system/bin/busybox; do
    [ -x "$p" ] && BUSY="$p" && break
done

if [ -f $STOCK ]; then
    . $STOCK
    swapoff $ZRAM 2>/dev/null
    echo 1 > $SYS/reset 2>/dev/null
    [ -n "$STOCK_ALGO" ] && echo $STOCK_ALGO > $SYS/comp_algorithm 2>/dev/null
    [ -n "$STOCK_SIZE" ] && echo $STOCK_SIZE > $SYS/disksize 2>/dev/null
    [ -n "$BUSY" ] && $BUSY mkswap $ZRAM >/dev/null 2>&1
    swapon $ZRAM 2>/dev/null
    [ -n "$STOCK_SWAP" ] && echo $STOCK_SWAP > /proc/sys/vm/swappiness 2>/dev/null
    rm -f $STOCK
fi
rm -f /data/adb/zramtuner.log
