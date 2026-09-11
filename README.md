# Happ Extra Whitelist2

Public MIT **agent skill** for **Windows** (desktop, laptop, or VM): run **[Happ](https://www.happ.su)** as the primary proxy client with:

| Piece | Choice |
|-------|--------|
| Client | **Happ** (FlyFrog) — System Proxy + TUN |
| Routing profile | RoscomVPN **WHITELIST** (public deeplink) |
| Preferred exits | Subscription remarks **`Extra Whitelist2`**, priority **Germany (DE) → Netherlands (NL)** **when those remarks exist** |
| Sub refresh | **60 minutes** (registry) |
| Autostart | `Happ.exe --autostart` via Scheduled Task (launch only) |
| Autoconnect | Official `lastused` + delayed soft `happ://connect` |

> **Naming trap:** public [hydraponique/roscomvpn-routing](https://github.com/hydraponique/roscomvpn-routing) has **WHITELIST** and **DEFAULT** routing profiles. There is **no** `WHITELIST2` *routing* profile. **Extra Whitelist2** is a **server-group / remark label** inside a Happ subscription list — not a RoscomVPN route name. Do not assume those remarks always exist.

Placeholders only. **Never** commit subscription URLs or tokens.

## Quickstart (agent or human)

1. Install Happ from the vendor site; keep it primary (do not enable another client's System Proxy/TUN at the same time).
2. Add the subscription in Happ UI (or from a local URL file kept private).
3. Import RoscomVPN **WHITELIST** routing — see [docs/routing.md](docs/routing.md).
4. If Extra Whitelist2 remarks exist, prefer Germany then Netherlands — [docs/extra-whitelist2.md](docs/extra-whitelist2.md).
5. Run `scripts/Set-HappSubscriptionRefresh.ps1` (60 minutes).
6. Run `scripts/Install-HappAutostart.ps1` (autostart **and** delayed autoconnect nudge).
7. Prefer provider `subscription-autoconnect-type: lastused`. Soft nudge: `scripts/Invoke-HappSoftConnect.ps1` (`happ://connect`). Focus only: `scripts/Invoke-HappSoftOpen.ps1` (`happ://open`). Never disconnect/kill while a remote session depends on the tunnel.
8. Verify: `scripts/Verify-HappExtraWhitelist2.ps1`.

## Agent skill

Copy or point Cursor/other agents at [`skills/happ-extra-whitelist2/SKILL.md`](skills/happ-extra-whitelist2/SKILL.md).

## Docs

- [Architecture](docs/architecture.md)
- [Install pipeline](docs/install-pipeline.md)
- [Autostart vs autoconnect](docs/autoconnect.md)
- [Routing: WHITELIST vs DEFAULT](docs/routing.md)
- [Extra Whitelist2 (DE→NL when present)](docs/extra-whitelist2.md)
- [Security](SECURITY.md)

## Scripts

| Script | Purpose |
|--------|---------|
| `Set-HappSubscriptionRefresh.ps1` | Registry: 60m auto-update |
| `Install-HappAutostart.ps1` | Task → `Happ.exe --autostart` + delayed connect nudge |
| `Set-HappAutoconnect.ps1` | Official lastused guidance + delayed `happ://connect` |
| `Invoke-HappSoftOpen.ps1` | `happ://open` (focus) |
| `Invoke-HappSoftConnect.ps1` | `happ://connect` (tunnel; no kill) |
| `Get-HappRoutingNames.ps1` | RO: `activeRoutingName` + profile names |
| `Verify-HappExtraWhitelist2.ps1` | Smoke checks (no secrets printed) |

## License

MIT — see [LICENSE](LICENSE).

---

## Русский

Публичный навык для **Windows** (любой ПК). Автозапуск (`--autostart`) ≠ автоподключение (`lastused` / `happ://connect`). Extra Whitelist2 DE→NL — если такие remark есть. Профиля `WHITELIST2` нет. Секреты и URL подписки в репозиторий не класть. Не убивать Happ, пока от туннеля зависит удалённый доступ.
