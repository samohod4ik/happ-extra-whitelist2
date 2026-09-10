# Architecture

```text
Internet (often mobile)
    → Happ (System Proxy 127.0.0.1:10809 + TUN)
        → RoscomVPN WHITELIST routing (RU whitelist direct; else proxy)
        → Selected outbound: Extra Whitelist2 remark, prefer DE then NL
```

| Layer | Role |
|-------|------|
| Happ | Primary Windows client (FlyFrog). Autostart with `--autostart`. |
| Routing JSON | `%LOCALAPPDATA%\Happ\routing.json` — `useRouting`, `activeRoutingName`, `routings[]`. |
| Geo assets | Often under `%LOCALAPPDATA%\Happ\routing\0\<ProfileName>\` (`geoip.dat`, `geosite.dat`). |
| Subscription | Opaque in Happ; refresh interval via HKCU registry (minutes on Windows builds). |
| Throne | Optional spare — leave proxy/TUN off while Happ owns the path. |

## Registry (subscription refresh)

Path: `HKCU\Software\Happ\OrganizationDefaults\Preferences\Subscriptions`

| Value | Recommended |
|-------|-------------|
| `subsUpdateTimerInMinutes` | `60` |
| `subsAutoUpdateInterval` | `60` (if present) |
| `subsAutoUpdate` | `true` |
| `subsUpdateOnOpen` | `true` |

Official docs sometimes describe intervals in hours; observed Windows builds honor **minutes** via these keys.
