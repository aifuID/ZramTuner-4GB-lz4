#!/system/bin/sh

BACKUP=/data/adb/zramtuner_backup.conf
SWB=/data/adb/zramtuner_swappiness.orig
ZRAM=/dev/block/zram0
SYS=/sys/block/zram0

n=0
while [ ! -e "$SYS/disksize" ] && [ $n -lt 15 ]; do sleep 2; n=$((n+1)); done
[ -e "$SYS/disksize" ] || exit 1

n=0
while [ "$(cat $SYS/disksize)" = "0" ] && [ $n -lt 30 ]; do sleep 2; n=$((n+1)); done

if [ ! -f "$BACKUP" ]; then
  ORIG_SIZE=$(cat $SYS/disksize)
  ORIG_ALGO=$(cat $SYS/comp_algorithm | tr ' ' '\n' | grep -F '[' | tr -d '[]')
  [ -n "$ORIG_ALGO" ] || ORIG_ALGO=$(cat $SYS/comp_algorithm | cut -d' ' -f1)
  if grep -q zram0 /proc/swaps; then ORIG_ACTIVE=1; else ORIG_ACTIVE=0; fi
  echo "ORIG_SIZE=$ORIG_SIZE"      > "$BACKUP"
  echo "ORIG_ALGO=$ORIG_ALGO"     >> "$BACKUP"
  echo "ORIG_ACTIVE=$ORIG_ACTIVE" >> "$BACKUP"
fi

# Cool Edition: backup swappiness bawaan ROM (sekali), lalu kunci di 20
if [ ! -f "$SWB" ]; then
  cat /proc/sys/vm/swappiness > "$SWB"
fi
echo 20 > /proc/sys/vm/swappiness 2>/dev/null

swapoff $ZRAM 2>/dev/null
echo 1 > $SYS/reset
echo lz4 > $SYS/comp_algorithm 2>/dev/null
echo 4294967296 > $SYS/disksize
mkswap $ZRAM >/dev/null 2>&1
swapon $ZRAM 2>/dev/null

exit 0
