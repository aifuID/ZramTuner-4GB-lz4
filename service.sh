#!/system/bin/sh
# ==============================================
#  ZRAM 4GB+lz4 COOL EDITION | v5.3 Change SWEP
#  (c) @aifu-ID x AI
# ==============================================

ZRAM=/dev/block/zram0
SYS=/sys/block/zram0
SIZE=4294967296
LOG=/data/adb/zramtuner.log
STOCK=/data/adb/zramtuner.stock

# cari busybox (buat mkswap)
BUSY=""
for p in /data/adb/ksu/bin/busybox /data/adb/ap/bin/busybox /data/adb/kernelsu/bin/busybox /system/bin/busybox; do
    [ -x "$p" ] && BUSY="$p" && break
done

takeover() {
    swapoff $ZRAM 2>/dev/null
    echo 1 > $SYS/reset 2>/dev/null
    echo lz4 > $SYS/comp_algorithm 2>/dev/null
    echo $SIZE > $SYS/disksize 2>/dev/null
    [ -n "$BUSY" ] && $BUSY mkswap $ZRAM >/dev/null 2>&1
    swapon $ZRAM 2>/dev/null
}

echo "== v5.3 boot $(date) busy=$BUSY ==" > $LOG

# FASE 0: foto settingan bawaan ROM (sekali saja, buat uninstall)
if [ ! -f $STOCK ]; then
    SALGO=$(cat $SYS/comp_algorithm)
    SALGO=${SALGO##*[}
    SALGO=${SALGO%%]*}
    echo "STOCK_SIZE=$(cat $SYS/disksize)" > $STOCK
    echo "STOCK_ALGO=$SALGO" >> $STOCK
    echo "STOCK_SWAP=$(cat /proc/sys/vm/swappiness)" >> $STOCK
fi

# FASE 1: takeover awal (swap masih kosong)
takeover
echo "fase1: size=$(cat $SYS/disksize) active=$(grep -c zram0 /proc/swaps)" >> $LOG

# FASE 2: tunggu boot selesai, kunci swappiness
while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 2
done
sleep 3
echo 10 > /proc/sys/vm/swappiness

# FASE 3: verifikasi 3 hal (size + algo + swap AKTIF) + retry
i=0
while [ $i -lt 5 ]; do
    cur=$(cat $SYS/disksize)
    algo=$(cat $SYS/comp_algorithm)
    active=$(grep -c zram0 /proc/swaps)
    case "$algo" in *"[lz4]"*) ok=1 ;; *) ok=0 ;; esac
    [ "$cur" = "$SIZE" ] && [ "$ok" = "1" ] && [ "$active" = "1" ] && break
    echo 3 > /proc/sys/vm/drop_caches 2>/dev/null
    sleep 2
    takeover
    echo 10 > /proc/sys/vm/swappiness
    i=$((i + 1))
done
echo "final: size=$(cat $SYS/disksize) swappiness=$(cat /proc/sys/vm/swappiness) active=$(grep -c zram0 /proc/swaps) retries=$i" >> $LOG
