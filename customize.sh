#!/system/bin/sh
# ==============================================
#  ZramTuner v6.0 - customize.sh (jalan saat flash)
#  id: zramtuner
# ==============================================
ui_print ""
ui_print "⚡ ZramTuner v6.0 - Universal Edition"
ui_print "   ZRAM 4GB + lz4 (strict) | Android 12-17"
ui_print "   Magisk / KernelSU / APatch"
ui_print ""

# ---------- easter egg ascii art ----------
if [ -f "$MODPATH/evangelion.txt" ]; then
  while IFS= read -r line; do ui_print "$line"; done < "$MODPATH/evangelion.txt"
fi

# ---------- cek versi android ----------
SDK=$(getprop ro.build.version.sdk)
if [ "$SDK" -lt 31 ] || [ "$SDK" -gt 37 ]; then
  ui_print "! Warning: SDK $SDK outside tested range (31-37)"
  ui_print "! Continuing anyway..."
fi

# ---------- deteksi root manager ----------
if [ -d /data/adb/ksu ]; then MGR="KernelSU"
elif [ -d /data/adb/ap ]; then MGR="APatch"
elif [ -d /data/adb/magisk ]; then MGR="Magisk"
else MGR="unknown"; fi
ui_print "• Root manager : $MGR"

# ---------- cek busybox ----------
if [ -x /data/adb/ksu/bin/busybox ] || [ -x /data/adb/ap/bin/busybox ] || [ -x /data/adb/magisk/busybox ]; then
  ui_print "• BusyBox      : bundled ✔"
else
  ui_print "• BusyBox      : not bundled (toybox fallback active)"
  [ "$MGR" = "Magisk" ] && ui_print "! Magisk: install BusyBox module (osm0sis) + OverlayFS meta"
fi

# ---------- permission ----------
set_perm 0 0 0755 "$MODPATH/service.sh"
set_perm 0 0 0755 "$MODPATH/uninstall.sh"

ui_print ""
ui_print "✔ Flash complete - reboot to apply"
exit 0
