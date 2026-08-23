# Changelog

## v6.0 "Universal Edition"
- Support Android 12–17 (API 31–37)
- Support Magisk / KernelSU / APatch
- Auto-detect BusyBox (KSU / APatch / Magisk) + toybox fallback
- Algoritma kompresi: lz4 only (auto-detect profil lz4 / lz4hc)
- Config eksternal: /data/adb/zramtuner.conf (size, swappiness, CPU floor)
- Lantai frekuensi CPU opsional (default off)
- Swappiness dikunci setelah boot_completed (anti-override ROM)
- User Magisk: wajib modul BusyBox (osm0sis) + modul meta OverlayFS
- Anti-bootloop & uninstall auto-restore (unchanged)

## v5.3 "Cool Compromise"
- Swappiness 20 → 10 — CPU can deep-idle again (fixes stuck idle freq & warm body)
- Live tested: idle 595–633 MHz, −280 mA screen-on, cool body
- What's unchanged: ZRAM 4GB + lz4 (the proven combo)
- What's new:
  - Auto-capture of stock ROM settings on first boot
  - Uninstall now fully restores stock ZRAM (algo, size, swappiness)
- Boot check:
  - cat /data/adb/zramtuner.log
  - swappiness=10 active=1 retries=0
- Flash → reboot → done. ❄️
- 
