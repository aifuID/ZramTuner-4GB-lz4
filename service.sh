#!/system/bin/sh
# ============================================
#  ZRAM 4GB+lz4 - Cool Edition | service.sh
#  (c) @aifu-ID x AI - swappiness20
# ============================================

MODDIR=${0%/*}

# ---- tunggu Android boot selesai ----
while [ "$(getprop sys.boot_completed)" != "1" ]; do
  sleep 5
done
# kasih ROM waktu beresin init-nya
sleep 15

# ---- Cool Edition: swappiness 20 ----
echo 20 > /proc/sys/vm/swappiness

# ---- safety net: 4GB + lz4 ----
Z=/sys/block/zram0
if [ "$(cat $Z/disksize)" != "4294967296" ]; then
  swapoff /dev/block/zram0 >/dev/null 2>&1
  echo 1 > $Z/reset >/dev/null 2>&1
  echo lz4 > $Z/comp_algorithm >/dev/null 2>&1
  echo 4294967296 > $Z/disksize >/dev/null 2>&1
  mkswap /dev/block/zram0 >/dev/null 2>&1
  swapon /dev/block/zram0 >/dev/null 2>&1
fi

# ---- log debug ----
echo "sw=$(cat /proc/sys/vm/swappiness) size=$(cat $Z/disksize)" > $MODDIR/service.log 2>/dev/null
