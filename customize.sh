### ZramTuner v6.2.1 - customize.sh (AEGIS Protocol)
SKIPMOUNT=false
PROPFILE=false
POSTFSDATA=false
LATESTARTSERVICE=true

print_modname() {
  ui_print "════════════════════════════════════════"
  ui_print "  ZramTuner v6.2.1 — AEGIS Protocol"
  ui_print "  Sentinel armed. Intruders will be neutralized."
  ui_print "  'This is the fate.' — Rei"
  ui_print "════════════════════════════════════════"
}

# v6.2: Rei Pilot EVA
[ -f "$MODPATH/evangelion.txt" ] || unzip -o "$ZIPFILE" 'evangelion.txt' -d "$MODPATH" >/dev/null 2>&1
if [ -f "$MODPATH/evangelion.txt" ]; then
  while IFS= read -r _rei; do ui_print "$_rei"; done < "$MODPATH/evangelion.txt"
fi

on_install() {
  ui_print "- Installing ZRAM module..."
  unzip -o "$ZIPFILE" module.prop service.sh uninstall.sh zramwatch.sh evangelion.txt -d "$TMPDIR" > /dev/null
  mkdir -p "$MODPATH"
  mv "$TMPDIR/module.prop"     "$MODPATH/"
  mv "$TMPDIR/service.sh"      "$MODPATH/"
  mv "$TMPDIR/uninstall.sh"    "$MODPATH/"
  mv "$TMPDIR/zramwatch.sh"    "$MODPATH/"
  mv "$TMPDIR/evangelion.txt"  "$MODPATH/"
  # permissions
  chmod 755 "$MODPATH/service.sh"
  chmod 755 "$MODPATH/uninstall.sh"
  chmod 755 "$MODPATH/zramwatch.sh"
  chmod 644 "$MODPATH/module.prop"
  chmod 644 "$MODPATH/evangelion.txt"
}

# v6.2.1: relocate config & log into the Citadel (module directory)
[ -f /data/adb/zramtuner.conf ] && mv -f /data/adb/zramtuner.conf "$MODPATH/zramtuner.conf"
[ -f /data/adb/zramtuner.log ]  && mv -f /data/adb/zramtuner.log  "$MODPATH/zramtuner.log"
rm -f /data/adb/zramtuner_backup.conf
[ -f "$MODPATH/zramtuner.conf" ] || printf 'SWAP=10\n' > "$MODPATH/zramtuner.conf"
ui_print "- Config relocated: $MODPATH/zramtuner.conf"
ui_print "- Blackbox relocated: $MODPATH/zramtuner.log"
ui_print "- Legacy files purged from /data/adb"
ui_print "- ZramTuner v6.2 installed (watchdog armed)"

# v6.2.1: chmod wajib top-level — on_install() tidak pernah dipanggil framework
chmod 755 "$MODPATH/service.sh" "$MODPATH/uninstall.sh" "$MODPATH/zramwatch.sh"
chmod 644 "$MODPATH/module.prop" "$MODPATH/evangelion.txt"
