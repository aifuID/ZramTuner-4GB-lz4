#!/system/bin/sh
# ==============================================
#  ZRAM 4GB+lz4 COOL EDITION | v5.1 FULL CONTROL
#  (c) @aifu-ID x AI
#  early = win size | late = win swappiness
# ==============================================

ZRAM=/dev/block/zram0
SYS=/sys/block/zram0
SIZE=4294967296

takeover() {
    swapoff $ZRAM 2>/dev/null
    echo 1 > $SYS/reset 2>/dev/null
    echo lz4 > $SYS/comp_algorithm 2>/dev/null
    echo $SIZE > $SYS/disksize 2>/dev/null
    swapon $ZRAM 2>/dev/null
}

# ---------- FASE 1: TAKEOVER AWAL ----------
# swap masih ~0 -> swapoff gampang (jurus v4.9: menang SIZE)
takeover

# ---------- FASE 2: NUNGGU BOOT SELESAI ----------
while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 2
done
sleep 3

# penulis terakhir -> menang swappiness (jurus v5.0)
echo 20 > /proc/sys/vm/swappiness

# ---------- FASE 3: VERIFIKASI + RETRY ----------
i=0
while [ $i -lt 5 ]; do
    cur=$(cat $SYS/disksize)
    algo=$(cat $SYS/comp_algorithm)
    case "$algo" in
        *$$lz4$$*) ok=1 ;;
        *) ok=0 ;;
    esac
    if [ "$cur" = "$SIZE" ] && [ "$ok" = "1" ]; then
        break
    fi
    echo 3 > /proc/sys/vm/drop_caches 2>/dev/null
    sleep 2
    takeover
    echo 20 > /proc/sys/vm/swappiness
    i=$((i + 1))
done
