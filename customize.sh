#!/system/bin/sh

MDIR="$MODPATH"
[ -n "$MDIR" ] || MDIR="$MODDIR"
[ -n "$MDIR" ] || MDIR=/data/adb/modules_update/zramtuner

ZRAM=/dev/block/zram0
SYS=/sys/block/zram0

msg() { if type ui_print >/dev/null 2>&1; then ui_print "$1"; else echo "$1"; fi; }
type abort >/dev/null 2>&1 || abort() { msg "$1"; exit 1; }

msg "=================================="
msg "   ZRAM 4GB+lz4 - COOL EDITION"
msg "=================================="

for F in "$MDIR"/*.txt; do
  [ -f "$F" ] || continue
  tr -d '\r' < "$F" | while IFS= read -r L; do msg "$L"; done
done

msg "   ZRAM 4GB+lz4 COOL EDITION | (c) @aifu-ID x AI"
msg "kernel support:"
KERNEL_ALGOS=$(cat $SYS/comp_algorithm 2>/dev/null)
msg "$KERNEL_ALGOS"
case " $(echo "$KERNEL_ALGOS" | tr -d '[]') " in
  *" lz4 "*) : ;;
  *) abort "KERNEL HAS NO lz4 PROFILE - AUTO ABORT INSTALL (anti bootloop)" ;;
esac

cat > $MDIR/module.prop << 'PROP'
id=zramtuner
name=Zram 4GB+lz4 Cool Edition
version=v4.9
versionCode=49
author=aifu-ID
description=(c) @aifu-ID x AI - zram 4GB+lz4+swappiness20
updateJson=https://raw.githubusercontent.com/aifuID/ZramTuner-4GB-lz4/main/update.json
PROP

msg "module.prop -> $(grep '^description=' $MDIR/module.prop 2>/dev/null)"

msg "applying 4GB + lz4 NOW (no reboot needed)..."
swapoff $ZRAM 2>/dev/null
echo 1 > $SYS/reset 2>/dev/null
echo lz4 > $SYS/comp_algorithm 2>/dev/null
echo 4294967296 > $SYS/disksize
mkswap $ZRAM >/dev/null 2>&1
swapon $ZRAM 2>/dev/null

msg "swappiness -> 20 (Cool Edition)..."
echo 20 > /proc/sys/vm/swappiness 2>/dev/null

msg "now: $(cat $SYS/disksize 2>/dev/null) | $(cat $SYS/comp_algorithm 2>/dev/null) | swappiness: $(cat /proc/sys/vm/swappiness 2>/dev/null)"
msg "=================================="
msg "done! reboot optional - service.sh keeps it at boot"
