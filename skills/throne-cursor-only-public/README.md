# Throne Cursor-only

Public entry for the **Throne Cursor-only** install variant: route **only** `Cursor.exe` and the cursor-agent node through VPN; leave the rest of the OS **direct**.

Chooser vs Happ full-proxy: [docs/variant-throne-cursor-only.md](../../docs/variant-throne-cursor-only.md).

## Hard rules

- Spare / Cursor-only — not a second System Proxy while Happ is primary on the same machine.
- **Never** enable Throne System Proxy and Happ System Proxy together.
- No subscription URLs or host-specific paths in this folder.

## Expected files

Canonical procedure (SKILL, reference, cursor-http-proxy / pitfalls / research) is the owner-authorized public-ready copy. Agents should read those files when present and must not invent a parallel Happ TUN.

```text
SKILL.md
reference.md
docs/cursor-http-proxy.md
docs/pitfalls.md
docs/research-cursor-http-proxy.md
```

---

## Русский

Вариант: VPN только для Cursor.exe и cursor-agent; остальная ОС напрямую. Не включать System Proxy Throne вместе с Happ. Выбор варианта: [variant-throne-cursor-only.md](../../docs/variant-throne-cursor-only.md).
