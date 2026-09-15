# v6.2 "AEGIS Protocol"
- Citadel relocation: config & log now live inside the module directory
- AEGIS sentinel: 60s patrol, unauthorized swappiness writes neutralized & timestamped
- Self-healing config with sanitizer (corrupt/missing conf auto-rebuilt)
- uninstall: full purge protocol + sentinel shutdown + safe fallback to stock swappiness
- Field-proven: first intruder kill recorded 45s after fresh boot (70 -> 10, policy restored)
