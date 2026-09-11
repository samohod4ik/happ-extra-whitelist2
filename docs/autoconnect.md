# Autostart vs autoconnect

**Autostart** launches Happ. **Autoconnect** brings the VPN / TUN / System Proxy session up. They are not the same. After reboot, `Happ.exe --autostart` can leave Happ running minimized with the tunnel still down.

This skill targets any **Windows** PC (desktop, laptop, or VM) where Happ is the primary proxy client.

## Official Happ auto-connect (preferred)

Vendor docs: [App management — Auto-connect](https://www.happ.su/main/dev-docs/app-management) (RU: [Управление приложением](https://www.happ.su/main/ru/dev-docs/app-management)).

```
subscription-autoconnect: true|1
subscription-autoconnect-type: lastused|lowestdelay|random
```

Prefer **`lastused`** (reconnect the last selected server). When Extra Whitelist2 remarks exist, prefer Germany (`DE`; informal `GE`) then Netherlands (`NL`) as that last selection.

Delivery (subscription provider — **never** commit the URL):

- HTTP response headers on the subscription, and/or
- Body lines: `#subscription-autoconnect: 1` and `#subscription-autoconnect-type: lastused`

Vendor `app-auto-start` is documented as **Android-only**. On Windows, launch is the Scheduled Task `Happ.exe --autostart`, not that header.

## What this repo can set locally (no provider)

No public Happ Windows **Preferences** registry value for autoconnect is documented. Scripts must not invent keys. `Set-HappAutoconnect.ps1` only *reports* existing HKCU names that already look like autoconnect.

Local options without a subscription provider:

1. **UI toggle** — if the installed build shows Settings **Auto-connect** / **Автоподключение**, enable it.
2. **Soft scheduled nudge** — current-user task `happ://connect` **30–60s after logon** (default 45s), after Happ has started. Does not kill Happ.
3. **Watch** — if `Happ.exe` is running but TUN / System Proxy is down, run `scripts/Invoke-HappSoftConnect.ps1`. Never `happ://disconnect` or `Stop-Process` while a remote session depends on the tunnel.

```powershell
.\scripts\Install-HappAutostart.ps1          # --autostart + delayed connect nudge
.\scripts\Set-HappAutoconnect.ps1            # nudge only (or -InspectOnly)
.\scripts\Invoke-HappSoftConnect.ps1         # happ://connect now
```

## Hard rule

Never kill Happ and never call `happ://disconnect` when remote access depends on the tunnel. Soft `happ://open` (focus) or `happ://connect` (bring tunnel up) only.

---

## Русский

**Автозапуск** только открывает Happ. **Автоподключение** поднимает туннель. После перезагрузки `Happ.exe --autostart` может оставить Happ свёрнутым без VPN.

Официально автоподключение задаёт провайдер подписки (`lastused` предпочтителен). URL подписки в репозиторий не писать. Локально: тумблер в Settings, если есть; отложенный `happ://connect` через 30–60 с после входа. Если процесс есть, а TUN/прокси нет — мягкий `happ://connect`. Не убивать Happ и не вызывать `happ://disconnect`, пока удалённый доступ зависит от туннеля.
