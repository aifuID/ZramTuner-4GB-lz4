v5.2 🧊 Mkswap Fix

- FIX: swap now survives reboot (mkswap re-signs zram after reset)
- Auto-detect busybox path for mkswap
- Verification loop now checks size + algo + swap-active
- Boot log at /data/adb/zramtuner.log
- 
