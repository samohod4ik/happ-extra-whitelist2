---
name: happ-extra-whitelist2
description: >-
  Use when setting up or auditing Happ on a Windows laptop with RoscomVPN
  WHITELIST routing, Extra Whitelist2 exits (DE then NL), 60-minute subscription
  refresh, and Happ.exe --autostart. Not for Throne-as-primary, not for inventing
  a WHITELIST2 routing profile, not for pasting subscription URLs.
---

# Happ Extra Whitelist2

## When to use

- User wants Happ as **primary** Windows proxy (mobile or home ISP).
- Need RoscomVPN **WHITELIST** routing + prefer **Extra Whitelist2** servers (DE → NL).
- Need subscription auto-update every **60 minutes** and logon autostart.

## When NOT to use

- Making Throne/Nekoray the primary tunnel.
- Looking for a public **WHITELIST2** *routing* profile (it does not exist — use WHITELIST routing + Extra Whitelist2 *server remarks*).
- Dumping or committing subscription URLs / `subs.db`.

## Hard rules

1. Never print or commit subscription URLs/tokens.
2. Prefer `happ://open` over disconnect/kill.
3. Do not enable another client's System Proxy/TUN while Happ is primary.
4. Do not invent Hermes- or host-specific paths in this public skill.

## Procedure

1. Confirm Happ installed; locate `Happ.exe`.
2. Ensure subscription present (user-private); do not log the URL.
3. Import RoscomVPN **WHITELIST** deeplink; enable Use routing; confirm via `scripts/Get-HappRoutingNames.ps1`.
4. In UI, connect a server remark containing `Extra Whitelist2`, preferring Germany then Netherlands.
5. `scripts/Set-HappSubscriptionRefresh.ps1` → 60.
6. `scripts/Install-HappAutostart.ps1`.
7. `scripts/Invoke-HappSoftOpen.ps1`.
8. `scripts/Verify-HappExtraWhitelist2.ps1` — all checks green or document gaps.

## Success criteria

- Happ processes running; autostart task present.
- `useRouting` on; active routing profile is the imported WHITELIST-based profile.
- Connected exit is Extra Whitelist2 DE or NL when those exist in the sub.
- Registry refresh interval is 60 minutes; auto-update enabled.
