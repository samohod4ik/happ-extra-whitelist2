# Architecture

```text
Internet
    → Happ (System Proxy 127.0.0.1:10809 + TUN)   # typical local listen; confirm on the host
        → RoscomVPN WHITELIST routing (RU whitelist direct; else proxy)
        → Selected outbound: last used server; prefer Extra Whitelist2 DE then NL when those remarks exist
```

Applies to any **Windows** PC where Happ is the primary proxy client.

| Layer | Role |
|-------|------|
| Happ | Primary Windows client (FlyFrog). **Autostart** = `Happ.exe --autostart` (launch). **Autoconnect** = official `lastused` + optional delayed `happ://connect`. |
| Routing JSON | `%LOCALAPPDATA%\Happ\routing.json` — `useRouting`, `activeRoutingName`, `routings[]`. |
| Geo assets | Often under `%LOCALAPPDATA%\Happ\routing\0\<ProfileName>\` (`geoip.dat`, `geosite.dat`). |
| Subscription | Opaque in Happ; refresh interval via HKCU registry (minutes on Windows builds). Autoconnect flags are **subscription-delivered**, not a documented registry value. |
| Other clients | Optional spare — leave their proxy/TUN off while Happ owns the path. |

## Autostart vs autoconnect

| Mechanism | What it does | What it does not do |
|-----------|----------------|---------------------|
| Scheduled Task `Happ.exe --autostart` | Starts Happ at logon (often minimized) | Does not guarantee TUN/proxy up |
| `subscription-autoconnect` + `lastused` | Official auto-connect on app launch | Requires provider headers/body (no URLs in this repo) |
| Delayed `happ://connect` | Soft local nudge 30–60s after logon | Does not kill Happ; not `happ://disconnect` |

Vendor `app-auto-start` is Android-only in [official docs](https://www.happ.su/main/dev-docs/app-management).

## Registry (subscription refresh)

Path: `HKCU\Software\Happ\OrganizationDefaults\Preferences\Subscriptions`

| Value | Recommended |
|-------|-------------|
| `subsUpdateTimerInMinutes` | `60` |
| `subsAutoUpdateInterval` | `60` (if present) |
| `subsAutoUpdate` | `true` |
| `subsUpdateOnOpen` | `true` |

Official docs sometimes describe intervals in hours; observed Windows builds honor **minutes** via these keys. No public autoconnect value is documented under Preferences — do not invent one.

---

## Русский

Слои те же на любом Windows ПК. Автозапуск только поднимает процесс; автоподключение — отдельно (`lastused` от провайдера и/или мягкий `happ://connect`). Реестр здесь — интервал обновления подписки, не автоподключение. Extra Whitelist2 DE/NL — если такие серверы есть в подписке пользователя.
