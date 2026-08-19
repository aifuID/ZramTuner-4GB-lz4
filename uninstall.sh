#!/system/bin/sh
BACKUP=/data/adb/zramtuner_backup.conf
ZRAM=/dev/block/zram0
SYS=/sys/block/zram0
[ -f "$BACKUP" ] || exit 0
. "$BACKUP"
[ -e "$SYS/disksize" ] || { rm -f "$BACKUP"; exit 0; }
swapoff $ZRAM 2>/dev/null
echo 1 > $SYS/reset 2>/dev/null
[ -n "$ORIG_ALGO" ] && echo "$ORIG_ALGO" > $SYS/comp_algorithm 2>/dev/null
echo "$ORIG_SIZE" > $SYS/disksize 2>/dev/null
if [ "$ORIG_SIZE" != "0" ]; then
  mkswap $ZRAM >/dev/null 2>&1
  [ "$ORIG_ACTIVE" = "1" ] && swapon $ZRAM 2>/dev/null
fi
rm -f "$BACKUP"
exit 0
