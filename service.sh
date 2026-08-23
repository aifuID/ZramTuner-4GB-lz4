#!/system/bin/sh
# ==============================================
#  ZramTuner v6.0 "Universal Edition"
#  id: zramtuner
#  ZRAM 4GB + lz4 (strict) | swappiness 10
#  Android 12-17 (API 31-37)
#  Magisk / KernelSU / APatch
# ==============================================
LOG=/data/adb/zramtuner.log
CONF=/data/adb/zramtuner.conf
BAK=/data/adb/zramtuner_backup.conf
log() { echo "[$(date '+%m-%d %H:%M:%S')] $*" >> "$LOG"; }

# ---------- defaults ----------
SIZE=4294967296        # 4GB
SWAP=10
ALGO=lz4               # lz4 only (fallback profile: lz4hc)
#CPU_MIN=595000        # (optional) CPU floor in kHz - remove # to enable

# ---------- user config ----------
if [ ! -f "$CONF" ]; then
  printf '# ZramTuner v6.0 config\nSIZE=4294967296\nSWAP=10\nALGO=lz4\n#CPU_MIN=595000\n' > "$CONF"
fi
. "$CONF"

# ---------- busybox / toybox detection ----------
if   [ -x /data/adb/ksu/bin/busybox ]; then BB="/data/adb/ksu/bin/busybox"
elif [ -x /data/adb/ap/bin/busybox  ]; then BB="/data/adb/ap/bin/busybox"
elif [ -x /data/adb/magisk/busybox  ]; then BB="/data/adb/magisk/busybox"
else BB="/system/bin/toybox"
fi

SDK=$(getprop ro.build.version.sdk)
MGR=unknown
[ -d /data/adb/ksu ] && MGR=KernelSU
[ -d /data/adb/ap ] && MGR=APatch
[ -d /data/adb/magisk ] && MGR=Magisk
log "=== boot SDK=$SDK manager=$MGR bb=$BB ==="

# ---------- wait for zram0 ----------
i=0
while [ ! -d /sys/block/zram0 ] && [ "$i" -lt 30 ]; do sleep 1; i=$((i+1)); done
[ -d /sys/block/zram0 ] || { log "ERROR: zram0 not found"; exit 0; }

# ---------- backup original settings (first boot only) ----------
if [ ! -f "$BAK" ]; then
  O_SIZE=$(cat /sys/block/zram0/disksize)
  O_ALGO=$(cat /sys/block/zram0/comp_algorithm | sed 's/.*$$$[^]]*$$$.*/\1/')
  O_SW=$(cat /proc/sys/vm/swappiness)
  printf 'ORIG_SIZE=%s\nORIG_ALGO=%s\nORIG_SW=%s\n' "$O_SIZE" "$O_ALGO" "$O_SW" > "$BAK"
  log "backup: size=$O_SIZE algo=$O_ALGO sw=$O_SW"
fi

# ---------- lz4 profile detection ----------
if [ "$ALGO" = "auto" ]; then ALGO=lz4; fi
AVAIL=$(cat /sys/block/zram0/comp_algorithm)
HAS_LZ4=0
HAS_LZ4HC=0
for w in $AVAIL; do
  case "$w" in
    lz4|"[lz4]")     HAS_LZ4=1;;
    lz4hc|"[lz4hc]") HAS_LZ4HC=1;;
  esac
done
if [ "$ALGO" = "lz4hc" ]; then
  if [ "$HAS_LZ4HC" = 1 ]; then ALGO=lz4hc
  elif [ "$HAS_LZ4" = 1 ]; then ALGO=lz4
  else ALGO=""; fi
else
  if [ "$HAS_LZ4" = 1 ]; then ALGO=lz4
  elif [ "$HAS_LZ4HC" = 1 ]; then ALGO=lz4hc
  else ALGO=""; fi
fi
[ -n "$ALGO" ] || { log "ERROR: kernel has no lz4/lz4hc profile - anti-bootloop abort"; exit 0; }

# ---------- apply ----------
grep -q zram0 /proc/swaps && $BB swapoff /dev/block/zram0 2>/dev/null
echo 1 > /sys/block/zram0/reset 2>/dev/null
echo "$ALGO" > /sys/block/zram0/comp_algorithm 2>/dev/null
CUR=$(cat /sys/block/zram0/comp_algorithm)
case "$CUR" in
  *"[$ALGO]"*) log "algo OK: $ALGO";;
  *) log "ERROR: kernel rejected $ALGO - abort"; exit 0;;
esac
echo "$SIZE" > /sys/block/zram0/disksize 2>/dev/null
$BB swapon /dev/block/zram0 2>/dev/null || {
  $BB mkswap /dev/block/zram0 2>/dev/null
  $BB swapon /dev/block/zram0 2>/dev/null
}
echo "$SWAP" > /proc/sys/vm/swappiness 2>/dev/null

# ---------- CPU floor (optional) ----------
if [ -n "$CPU_MIN" ]; then
  for f in /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_min_freq; do
    echo "$CPU_MIN" > "$f" 2>/dev/null
  done
  log "CPU floor: $CPU_MIN kHz"
fi

# ---------- lock swappiness after boot completed (v5.3 legacy) ----------
t=0
while [ "$(getprop sys.boot_completed)" != "1" ] && [ "$t" -lt 120 ]; do
  sleep 2; t=$((t+2))
done
sleep 3
echo "$SWAP" > /proc/sys/vm/swappiness 2>/dev/null
log "swappiness locked: $(cat /proc/sys/vm/swappiness)"

# ---------- clean up v5.3 leftover files ----------
rm -f /data/adb/zramtuner.stock

# ---------- verification ----------
if grep -q zram0 /proc/swaps; then
  log "SUCCESS: $(cat /sys/block/zram0/disksize) bytes | $ALGO | swappiness $(cat /proc/sys/vm/swappiness)"
else
  log "FAIL: zram0 not active"
fi
exit 0
