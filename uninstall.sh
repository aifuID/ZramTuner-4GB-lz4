#!/system/bin/sh
# ==============================================
#  ZramTuner v6.0 - uninstall.sh
#  id: zramtuner
#  Restore setting original saat uninstall
# ==============================================
BAK=/data/adb/zramtuner_backup.conf
if   [ -x /data/adb/ksu/bin/busybox ]; then BB="/data/adb/ksu/bin/busybox"
elif [ -x /data/adb/ap/bin/busybox  ]; then BB="/data/adb/ap/bin/busybox"
elif [ -x /data/adb/magisk/busybox  ]; then BB="/data/adb/magisk/busybox"
else BB="/system/bin/toybox"
fi
[ -f "$BAK" ] || exit 0
. "$BAK"
grep -q zram0 /proc/swaps && $BB swapoff /dev/block/zram0 2>/dev/null
echo 1 > /sys/block/zram0/reset 2>/dev/null
[ -n "$ORIG_ALGO" ] && echo "$ORIG_ALGO" > /sys/block/zram0/comp_algorithm 2>/dev/null
[ -n "$ORIG_SIZE" ] && echo "$ORIG_SIZE" > /sys/block/zram0/disksize 2>/dev/null
$BB swapon /dev/block/zram0 2>/dev/null
[ -n "$ORIG_SW" ] && echo "$ORIG_SW" > /proc/sys/vm/swappiness 2>/dev/null
rm -f "$BAK"
exit 0
