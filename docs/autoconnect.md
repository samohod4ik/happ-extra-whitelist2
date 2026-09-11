# Autostart vs autoconnect

**Autostart** launches Happ. **Autoconnect** brings the VPN / TUN / System Proxy session up. They are not the same. After reboot, `Happ.exe --autostart` can leave Happ running minimized with the tunnel still down.

This is the **Happ full-proxy** variant on any **Windows** PC. Do not combine with Throne System Proxy. See [variant-throne-cursor-only.md](variant-throne-cursor-only.md).

## Official Happ auto-connect (preferred)

Vendor docs: [App management — Auto-connect](https://www.happ.su/main/dev-docs/app-management) (RU: [Управление приложением](https://www.happ.su/main/ru/dev-docs/app-management)).

```
subscription-autoconnect: true|1
subscription-autoconnect-type: lastused|lowestdelay|random
```

Prefer **`lastused`** (reconnect the last selected server). When Extra Whitelist2 remarks exist, prefer Germany (`DE`) then Netherlands (`NL`) as that last selection.

Delivery (subscription provider — **never** commit the URL):

- HTTP response headers on the subscription, and/or
- Body lines: `#subscription-autoconnect: 1` and `#subscription-autoconnect-type: lastused`

Vendor `app-auto-start` is documented as **Android-only**. On Windows, launch is the Scheduled Task `Happ.exe --autostart`, not that header.

## What this repo can set locally (no provider)

No public Happ Windows **Preferences** registry value for autoconnect is documented. Scripts must not invent keys. `Set-HappAutoconnect.ps1` only *reports* existing HKCU names that already look like autoconnect.

Local options without a subscription provider:

1. **UI toggle** — if the installed build shows Settings **Auto-connect** / **Автоподключение**, enable it.
2. **Soft scheduled nudge** — current-user task waits until `Happ.exe` is running, then `happ://connect` **30–60s after logon** (default 45s). Local protocol nudge, not the vendor header API. Does not kill Happ.
3. **Watch** — if `Happ.exe` is running but TUN / System Proxy is down, run `scripts/Invoke-HappSoftConnect.ps1`. Never `happ://disconnect` or `Stop-Process` while a remote session depends on the tunnel.

```powershell
.\scripts\Install-HappAutostart.ps1          # --autostart + delayed connect nudge
.\scripts\Set-HappAutoconnect.ps1            # nudge only (or -InspectOnly)
.\scripts\Invoke-HappSoftConnect.ps1         # happ://connect now
.\scripts\Verify-HappExtraWhitelist2.ps1     # -SkipAutoconnectCheck if nudge was skipped
```

## Hard rule

Never kill Happ and never call `happ://disconnect` when remote access depends on the tunnel. Soft `happ://open` (focus) or `happ://connect` (bring tunnel up) only. Never enable Happ System Proxy and Throne System Proxy together.

---

## Русский

**Автозапуск** только открывает Happ. **Автоподключение** поднимает туннель. После перезагрузки `Happ.exe --autostart` может оставить Happ свёрнутым без VPN.

Официально автоподключение задаёт провайдер подписки (`lastused` предпочтителен). URL подписки в репозиторий не писать. Локально: тумблер в Settings, если есть; отложенный `happ://connect` после старта Happ.exe (через 30–60 с после входа). Это локальный protocol nudge, не header API вендора. Если процесс есть, а TUN/прокси нет — мягкий `happ://connect`. Не убивать Happ и не вызывать `happ://disconnect`. Не включать System Proxy Happ и Throne вместе.
