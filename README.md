# Happ Extra Whitelist2

Public MIT **agent skill** for Windows laptops (often on mobile internet): run **[Happ](https://www.happ.su)** as the primary proxy client with:

| Piece | Choice |
|-------|--------|
| Client | **Happ** (FlyFrog) — System Proxy + TUN |
| Routing profile | RoscomVPN **WHITELIST** (public deeplink) |
| Preferred exits | Subscription remarks **`Extra Whitelist2`**, priority **Germany (DE) → Netherlands (NL)** |
| Sub refresh | **60 minutes** (registry) |
| Autostart | `Happ.exe --autostart` via Scheduled Task |

> **Naming trap:** public [hydraponique/roscomvpn-routing](https://github.com/hydraponique/roscomvpn-routing) has **WHITELIST** and **DEFAULT** routing profiles. There is **no** `WHITELIST2` *routing* profile. **Extra Whitelist2** is a **server-group / remark label** inside your Happ subscription list — not a RoscomVPN route name.

Placeholders only. **Never** commit subscription URLs or tokens.

## Quickstart (agent or human)

1. Install Happ from the vendor site; keep it primary (do not enable Throne/Nekoray System Proxy/TUN at the same time).
2. Add your subscription in Happ UI (or from a local URL file you keep private).
3. Import RoscomVPN **WHITELIST** routing — see [docs/routing.md](docs/routing.md).
4. In the server list, prefer remarks matching `Extra Whitelist2`, Germany first, then Netherlands — [docs/extra-whitelist2.md](docs/extra-whitelist2.md).
5. Run `scripts/Set-HappSubscriptionRefresh.ps1` (60 minutes).
6. Run `scripts/Install-HappAutostart.ps1`.
7. Soft nudge: `scripts/Invoke-HappSoftOpen.ps1` (`happ://open`). Prefer this over disconnect/kill.
8. Verify: `scripts/Verify-HappExtraWhitelist2.ps1`.

## Agent skill

Copy or point Cursor/other agents at [`skills/happ-extra-whitelist2/SKILL.md`](skills/happ-extra-whitelist2/SKILL.md).

## Docs

- [Architecture](docs/architecture.md)
- [Install pipeline](docs/install-pipeline.md)
- [Routing: WHITELIST vs DEFAULT](docs/routing.md)
- [Extra Whitelist2 (DE→NL)](docs/extra-whitelist2.md)
- [Security](SECURITY.md)

## Scripts

| Script | Purpose |
|--------|---------|
| `Set-HappSubscriptionRefresh.ps1` | Registry: 60m auto-update |
| `Install-HappAutostart.ps1` | Task → `Happ.exe --autostart` |
| `Invoke-HappSoftOpen.ps1` | `happ://open` |
| `Get-HappRoutingNames.ps1` | RO: `activeRoutingName` + profile names |
| `Verify-HappExtraWhitelist2.ps1` | Smoke checks (no secrets printed) |

## License

MIT — see [LICENSE](LICENSE).
