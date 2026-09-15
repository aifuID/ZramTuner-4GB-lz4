#!/system/bin/sh
# ══════════════════════════════════════════════════════
#  AEGIS SENTINEL — ZramTuner v6.2
#  Boot-persistent swappiness guardian.
#  Patrol cycle: 60 s. Unauthorized writes: neutralized.
#  Every kill is timestamped in the blackbox log.
# ══════════════════════════════════════════════════════
CONF=/data/adb/modules/zramtuner/zramtuner.conf
LOG=/data/adb/modules/zramtuner/zramtuner.log
SWAP=10
[ -f "$CONF" ] && . "$CONF"
case "$SWAP" in ''|*[!0-9]*) SWAP=10;; esac
sleep 45
while :; do
  CUR=$(cat /proc/sys/vm/swappiness 2>/dev/null)
  if [ "$CUR" != "$SWAP" ]; then
    echo "$SWAP" > /proc/sys/vm/swappiness 2>/dev/null
    echo "[$(date '+%m-%d %H:%M:%S')] AEGIS: intruder neutralized — swappiness $CUR -> $SWAP (policy restored)" >> "$LOG"
  fi
  sleep 60
done
