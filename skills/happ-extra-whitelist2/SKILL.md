---
name: happ-extra-whitelist2
description: >-
  Use when setting up or auditing Happ as the primary proxy client on Windows
  (desktop, laptop, or VM) with RoscomVPN WHITELIST routing, Extra Whitelist2
  exits (DE then NL when those remarks exist), 60-minute subscription refresh,
  Happ.exe --autostart, and autoconnect lastused. Not for other-clients-as-primary,
  not for inventing a WHITELIST2 routing profile, not for pasting subscription URLs.
---

# Happ Extra Whitelist2

Portable public skill. Scope is **Windows** (any PC), not a single host or laptop-only playbook.

## When to use

- User wants Happ as **primary** Windows proxy client.
- Need RoscomVPN **WHITELIST** routing + prefer **Extra Whitelist2** servers (DE → NL) **when those remarks exist**.
- Need subscription auto-update every **60 minutes**, logon **autostart**, and **autoconnect** (`lastused`).

## When NOT to use

- Making another client (Throne/Nekoray/sing-box GUI, etc.) the primary tunnel.
- Looking for a public **WHITELIST2** *routing* profile (it does not exist — use WHITELIST routing + Extra Whitelist2 *server remarks* if present).
- Dumping or committing subscription URLs / `subs.db`.

## Autostart vs autoconnect

| | Autostart | Autoconnect |
|---|-----------|-------------|
| Does | Starts Happ at logon (`Happ.exe --autostart`) | Brings TUN / System Proxy up |
| Official | Windows Scheduled Task (vendor `app-auto-start` is Android-only) | `subscription-autoconnect` + `subscription-autoconnect-type: lastused` |
| Local fallback | Discover `Happ.exe`; register the task | Settings toggle if present; delayed `happ://connect` (30–60s) |
| Docs | [install-pipeline.md](../../docs/install-pipeline.md) | [autoconnect.md](../../docs/autoconnect.md) |

Prefer **lastused** (last selected server). Prefer Extra Whitelist2 DE then NL **when those remarks exist**.

## Hard rules

1. Never print or commit subscription URLs/tokens.
2. Prefer `happ://open` (focus) and `happ://connect` (tunnel) over disconnect/kill.
3. **Never kill Happ** and never call `happ://disconnect` when a remote session depends on the tunnel.
4. Do not enable another client's System Proxy/TUN while Happ is primary.
5. Do not invent host-specific paths, computer names, or a `WHITELIST2` routing profile.

## Procedure

1. Confirm Happ installed; **discover** `Happ.exe` (pass `-HappExe` if needed).
2. Ensure subscription present (user-private); do not log the URL.
3. Import RoscomVPN **WHITELIST** deeplink; enable Use routing; confirm via `scripts/Get-HappRoutingNames.ps1`.
4. If Extra Whitelist2 remarks exist, connect DE then NL in the UI. Otherwise keep `lastused`.
5. `scripts/Set-HappSubscriptionRefresh.ps1` → 60.
6. `scripts/Install-HappAutostart.ps1` (launch task + delayed connect nudge).
7. Ask the subscription provider for `subscription-autoconnect: 1` + `subscription-autoconnect-type: lastused` (headers or `#` body lines). Enable the Settings auto-connect toggle **if present**.
8. `scripts/Invoke-HappSoftOpen.ps1` and/or `scripts/Invoke-HappSoftConnect.ps1`.
9. `scripts/Verify-HappExtraWhitelist2.ps1` — all checks green or document gaps.

## Watch

If the Happ **process** is running but TUN / System Proxy is down:

1. Soft `happ://connect` (`scripts/Invoke-HappSoftConnect.ps1`).
2. Do **not** kill `Happ.exe`. Do **not** `happ://disconnect`.
3. If still down after a short wait, `happ://open` and inspect the UI; re-check provider autoconnect / lastused.
4. Only after the tunnel is up, verify routing + (if present) Extra Whitelist2 DE/NL.

## Success criteria

- Happ process running; **autostart** task present; **autoconnect** nudge task present (unless explicitly skipped).
- `useRouting` on; active routing profile is the imported WHITELIST-based profile.
- Connected exit is Extra Whitelist2 DE or NL **when those remarks exist**.
- Registry refresh interval is 60 minutes; auto-update enabled.

---

## Русский

Публичный навык для **Windows** (любой ПК), не персональный playbook. **Автозапуск ≠ автоподключение.** `--autostart` только запускает Happ; туннель — `lastused` от провайдера и/или мягкий `happ://connect`. Extra Whitelist2 DE→NL — если такие remark есть. Профиля маршрутизации `WHITELIST2` нет. URL подписки не писать. Если процесс жив, а TUN/прокси нет — `happ://connect`; **не убивать Happ** и не вызывать `happ://disconnect`, пока удалённый доступ зависит от туннеля.
