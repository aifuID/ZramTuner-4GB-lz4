# ZramTuner Universal Edition v6.1
- Hybrid governor: adaptive swappiness (cool=base / hot-warm=60 / hot-crit=100),
  thermal veto at 41.0C, recovery hysteresis
- Anti-hijack reflex: foreign swappiness writes reverted within one 60s patrol
- govsay diary: full-date timestamps in /data/adb/zramgov.log
- Logcat voice: events tagged ZramGov (best-effort; early-boot entries may be
  lost to logcat ring rotation - diary remains canonical)
- Honest conf: governor reads SWAP= from /data/adb/zramtuner.conf (no silent fallback)
- Housekeeping: v6.1 stamps unified.
