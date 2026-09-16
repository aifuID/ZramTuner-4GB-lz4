v6.2.1 — AEGIS sentinel fix
- Fix: sentinel died at boot (now launched via sh + setsid + anti-dupe guard)
- Fix: install permissions (top-level chmod in customize.sh)
- Proven on-device (test on EvoX A17): intruder swappiness 70 -> 10 neutralized in <60s after booting up
