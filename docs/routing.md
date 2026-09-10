# Routing: WHITELIST vs DEFAULT

Source: [hydraponique/roscomvpn-routing](https://github.com/hydraponique/roscomvpn-routing) (`HAPP/` deeplinks).

| Profile | Behavior (summary) | When to use |
|---------|-------------------|-------------|
| **WHITELIST** | Direct only for RU whitelist destinations; everything else via proxy | This skill default ("белые списки") |
| **DEFAULT** | RU/BY-oriented direct + selective proxy (YouTube/Telegram/GitHub, etc.) | Lighter split / alternate |

There is **no** public **WHITELIST2** routing profile. Do not invent one.

## Import (soft)

1. Download `HAPP/WHITELIST.DEEPLINK` from the RoscomVPN routing repo (or use [routing.help](https://routing.help) if it still mirrors these profiles).
2. Open the deeplink / `Start-Process` the `happ://routing/onadd/...` line from the file.
3. In Happ: enable **Use routing**; set active profile to the imported name (often displayed as a RoscomVPN-style name — confirm in UI and in `routing.json`).
4. Soft open: `happ://open`. Avoid `happ://disconnect` unless you accept session drops.

## Verify

```powershell
.\\scripts\\Get-HappRoutingNames.ps1
```

Expect `useRouting=True` and an active name corresponding to the WHITELIST import (exact display string can vary by export).
