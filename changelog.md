# Changelog - Zram 4GB+lz4 Cool Edition

## v5.3 "Cool Compromise"
- Swappiness 20 -> 10: CPU can deep-idle again (fixes stuck idle freq & warm body from v5.2)
- ZRAM 4GB + lz4 unchanged
- New: auto-capture of stock ROM settings (for a clean uninstall)
- Live tested: idle 595-633 MHz, -280 mA screen-on, cool body

## v5.2 "MKSWAP FIX"
- Takeover of stock ROM ZRAM (swapoff > reset > lz4 > 4GB > mkswap > swapon)
- Boot log to /data/adb/zramtuner.log
- 5x verification retry
- 
