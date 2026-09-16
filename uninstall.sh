#!/system/bin/sh
# ==============================================
#  ZramTuner v6.2.1 - uninstall.sh (AEGIS Protocol)
#  id: zramtuner
#  Restore original settings on uninstall
# ==============================================
BAK=/data/adb/zramtuner_backup.conf
if   [ -x /data/adb/ksu/bin/busybox ]; then BB="/data/adb/ksu/bin/busybox"
elif [ -x /data/adb/ap/bin/busybox  ]; then BB="/data/adb/ap/bin/busybox"
elif [ -x /data/adb/magisk/busybox  ]; then BB="/data/adb/magisk/busybox"
else BB="/system/bin/toybox"
fi
grep -q zram0 /proc/swaps && $BB swapoff /dev/block/zram0 2>/dev/null
echo 1 > /sys/block/zram0/reset 2>/dev/null
[ -f "$BAK" ] && . "$BAK"
[ -n "$ORIG_ALGO" ] && echo "$ORIG_ALGO" > /sys/block/zram0/comp_algorithm 2>/dev/null
[ -n "$ORIG_SIZE" ] && echo "$ORIG_SIZE" > /sys/block/zram0/disksize 2>/dev/null
$BB swapon /dev/block/zram0 2>/dev/null || {
  $BB mkswap /dev/block/zram0 2>/dev/null
  $BB swapon /dev/block/zram0 2>/dev/null
}
[ -n "$ORIG_SW" ] && echo "$ORIG_SW" > /proc/sys/vm/swappiness 2>/dev/null
[ -z "$ORIG_SW" ] && echo 60 > /proc/sys/vm/swappiness 2>/dev/null

# ---------- v6.2.1: purge all traces (Citadel + legacy) ----------
rm -f /data/adb/zramtuner.conf /data/adb/zramtuner.log /data/adb/zramtuner_backup.conf /data/adb/service.d/zramwatch.sh /data/adb/swaphunt.log
pkill -f zramwatch.sh 2>/dev/null
rm -f "$BAK"
rm -f /data/adb/zramtuner.stock
exit 0
