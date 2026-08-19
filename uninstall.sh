#!/system/bin/sh

BACKUP=/data/adb/zramtuner_backup.conf
SWB=/data/adb/zramtuner_swappiness.orig
ZRAM=/dev/block/zram0
SYS=/sys/block/zram0

# Cool Edition: kembalikan swappiness bawaan ROM
if [ -f "$SWB" ]; then
  echo "$(cat "$SWB")" > /proc/sys/vm/swappiness 2>/dev/null
  rm -f "$SWB"
fi

# kembalikan setting zRAM asli
if [ -f "$BACKUP" ]; then
  . "$BACKUP"
  swapoff $ZRAM 2>/dev/null
  echo 1 > $SYS/reset 2>/dev/null
  [ -n "$ORIG_ALGO" ] && echo "$ORIG_ALGO" > $SYS/comp_algorithm 2>/dev/null
  [ -n "$ORIG_SIZE" ] && echo "$ORIG_SIZE" > $SYS/disksize 2>/dev/null
  if [ "$ORIG_ACTIVE" = "1" ]; then
    mkswap $ZRAM >/dev/null 2>&1
    swapon $ZRAM 2>/dev/null
  fi
  rm -f "$BACKUP"
fi

exit 0
