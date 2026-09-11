# Happ Extra Whitelist2

Public MIT **agent skill** for **Windows** (desktop, laptop, or VM). Two install variants — pick **one** owner of System Proxy / TUN.

## Install variants

| # | Variant | Use when | Do not |
|---|---------|----------|--------|
| **1** | **Happ** (this repo's default) | Whole-OS proxy/TUN + RoscomVPN **WHITELIST** + Extra Whitelist2 DE→NL **when those remarks exist** + `Happ.exe --autostart` + autoconnect **`lastused`** | Enable Throne System Proxy at the same time |
| **2** | **Throne Cursor-only** | Only `Cursor.exe` + cursor-agent node through VPN; rest of the OS **direct** | Enable Happ System Proxy / TUN beside Throne |

- Happ skill: [`skills/happ-extra-whitelist2/SKILL.md`](skills/happ-extra-whitelist2/SKILL.md)
- Throne skill folder: [`skills/throne-cursor-only-public/`](skills/throne-cursor-only-public/)
- Chooser: [docs/variant-throne-cursor-only.md](docs/variant-throne-cursor-only.md)

**Never** enable Throne System Proxy and Happ System Proxy together. Throne is spare / Cursor-only while Happ is primary.

## Happ variant (full-proxy)

| Piece | Choice |
|-------|--------|
| Client | **Happ** (FlyFrog) — System Proxy + TUN |
| Routing profile | RoscomVPN **WHITELIST** (public deeplink) |
| Preferred exits | Subscription remarks **`Extra Whitelist2`**, priority **Germany (DE) → Netherlands (NL)** **when those remarks exist** |
| Sub refresh | **60 minutes** (registry) |
| Autostart | `Happ.exe --autostart` via Scheduled Task (launch only) |
| Autoconnect (official) | Provider `subscription-autoconnect` + `lastused` |
| Autoconnect (local nudge) | Delayed soft `happ://connect` after Happ.exe is running |

> **Naming trap:** public [hydraponique/roscomvpn-routing](https://github.com/hydraponique/roscomvpn-routing) has **WHITELIST** and **DEFAULT** routing profiles. There is **no** `WHITELIST2` *routing* profile. **Extra Whitelist2** is a **server-group / remark label** inside a Happ subscription list — not a RoscomVPN route name. Do not assume those remarks always exist.

Placeholders only. **Never** commit subscription URLs or tokens.

## Quickstart (Happ variant)

1. Install Happ from the vendor site; keep it primary (Throne System Proxy/TUN off).
2. Add the subscription in Happ UI (or from a local URL file kept private).
3. Import RoscomVPN **WHITELIST** routing — see [docs/routing.md](docs/routing.md).
4. If Extra Whitelist2 remarks exist, prefer Germany then Netherlands — [docs/extra-whitelist2.md](docs/extra-whitelist2.md).
5. Run `scripts/Set-HappSubscriptionRefresh.ps1` (60 minutes).
6. Run `scripts/Install-HappAutostart.ps1` (autostart **and** delayed autoconnect nudge).
7. Prefer provider `subscription-autoconnect-type: lastused`. Local nudge: `scripts/Set-HappAutoconnect.ps1` (delayed logon task). Live session already tunneled: do not fire `happ://connect` just to apply — field-check after reboot/logon. Soft connect now (`scripts/Invoke-HappSoftConnect.ps1`) only if the tunnel is down. Focus only: `scripts/Invoke-HappSoftOpen.ps1` (`happ://open`). Never disconnect/kill while a remote session depends on the tunnel.
8. Verify: `scripts/Verify-HappExtraWhitelist2.ps1`.

## Docs

- [Architecture](docs/architecture.md)
- [Install pipeline](docs/install-pipeline.md)
- [Autostart vs autoconnect](docs/autoconnect.md)
- [Throne Cursor-only vs Happ](docs/variant-throne-cursor-only.md)
- [Routing: WHITELIST vs DEFAULT](docs/routing.md)
- [Extra Whitelist2 (DE→NL when present)](docs/extra-whitelist2.md)
- [Security](SECURITY.md)

## Scripts

| Script | Purpose |
|--------|---------|
| `Set-HappSubscriptionRefresh.ps1` | Registry: 60m auto-update |
| `Install-HappAutostart.ps1` | Task → `Happ.exe --autostart` + delayed connect nudge |
| `Set-HappAutoconnect.ps1` | Official lastused guidance + delayed logon `happ://connect` nudge (no immediate connect on a healthy live session) |
| `Invoke-HappSoftOpen.ps1` | `happ://open` (focus) |
| `Invoke-HappSoftConnect.ps1` | `happ://connect` if the tunnel is down (optional/skip when already healthy; no kill) |
| `Get-HappRoutingNames.ps1` | RO: `activeRoutingName` + profile names |
| `Verify-HappExtraWhitelist2.ps1` | Smoke checks (no secrets printed) |

## License

MIT — see [LICENSE](LICENSE).

---

## Русский

Два варианта на **Windows** (любой ПК), не два системных прокси сразу:

1. **Happ** — весь ОС через Happ (WHITELIST, Extra Whitelist2 DE→NL если remark есть, `--autostart` + автоподключение `lastused`).
2. **Throne Cursor-only** — в VPN только Cursor.exe и cursor-agent; остальная ОС напрямую. См. [variant-throne-cursor-only.md](docs/variant-throne-cursor-only.md) и `skills/throne-cursor-only-public/`.

Автозапуск ≠ автоподключение. Официальный `lastused` задаёт провайдер; локальный nudge — `happ://connect` после старта Happ.exe. На живой сессии, если туннель уже поднят, connect не вызывать «чтобы применить» — проверить nudge после перезагрузки. Профиля `WHITELIST2` нет. URL подписки не класть. Не убивать Happ, пока от туннеля зависит удалённый доступ. Не включать System Proxy Happ и Throne вместе.
