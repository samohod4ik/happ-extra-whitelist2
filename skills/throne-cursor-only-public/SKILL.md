---
name: throne-cursor-only-public
description: >-
  Use when installing or configuring Throne (throneproj) on Windows so only
  Cursor IDE and cursor-agent traffic uses a VPN/subscription tunnel, or when
  TUN process rules break intranet, SSO, or split-horizon DNS. Do not use for
  whole-OS proxying or for evading workplace controls.
---

# Throne: Cursor-only tunnel (public)

Windows-only. Portable Throne. Config is SQLite `<THRONE_DIR>\config\throne.db`, not loose JSON. Profile **Cursor only**: default outbound **direct**. Proxy only `Cursor.exe` and `cursor-agent\versions\*\node.exe`. TUN on, System Proxy off.

This skill ships **no organization domains**. RFC1918 bypass is not enough for named intranet.

## Hard gate (do this first)

Cursor and cursor-agent are matched **by process**. After that, every destination that is not already a direct rule goes through the VPN.

If the user does not provide an allowlist, models and agent tools **cannot reach internal hosts**: SSO, issue trackers, package registries, intranet names, split-horizon names that resolve to private IPs only on corporate DNS. Typical symptom: timeout or WAF/SSO 403 from a datacenter IP.

**Before writing `throne.db` or telling the user to enable TUN:**

1. State that gap in one sentence.
2. Ask for the allowlist. Do not invent hostnames.
3. Apply only what they confirmed in **this conversation**.

Ask for:

- domain suffixes (PAC `*.corp.example` → `.corp.example`)
- exact hosts (short names and FQDNs)
- extra CIDRs beyond RFC1918, if any
- optional keywords (separate rule; AND if mixed with domain fields)

Allowlist source is **only** what the user pasted or attached in this chat. Do not read PAC, WPAD, WinINET, proxy settings, other skills, or files on disk to discover domains unless the user attached those files here. Empty allowlist is valid only after they confirm RFC1918-only.

Do **not** put subscription URLs, tokens, usernames, or absolute home paths into the skill, git, or chat logs. Paste the subscription only in the Throne UI.

Use only with the device owner's approval. Do not use split tunnel to evade monitoring or filtering.

## Download and install

1. https://throneproj.github.io/get_started/installation/ — Windows **Portable ZIP**, not the EXE installer.
2. Extract so `Throne.exe` is `<THRONE_DIR>\Throne.exe` (directory the user chose).
3. First run creates `config\throne.db`.

## Import subscription

1. `Ctrl+V` on the main window, or Settings → Groups → type Subscription → URL.
2. Update / Refresh the group.
3. Keep the URL in the UI only.

## Autostart (elevated) and subscription refresh

Do this in the **Throne UI** after Cursor-only routing works. Prefer built-in controls over hand-rolled `schtasks` (Throne ≥1.1.2 uses Task Scheduler; elevated session → future boots stay elevated without UAC each time).

1. Start `Throne.exe` with **Run as administrator**.
2. Preferences / menu: enable **start with Windows** / run at startup. Approve the one-time UAC prompt that creates the task.
3. Settings → Groups → subscription group: enable **automatic update**, interval **30** minutes (`sub_auto_update=30`). Leave `skip_auto_update=0` on that group.
4. Keep Throne running for the timer to fire. After an auto-update, re-check that the active node is still up (subscription mutations can stop the profile; Throne #1305, #1528).
5. After reboot: confirm the scheduled task launched Throne elevated, profile **Cursor only**, node selected, TUN on, System Proxy off. Restore `active_routing` / `dns_final_out=direct` if the GUI drifted.

ASCII-only install path is safer for the startup task (Unicode paths have broken autostart in past builds).

**Agent safety:** if this chat’s agent traffic already depends on Throne (TUN or Cursor `http.proxy` into Throne), do **not** stop Throne, kill `ThroneCore`, rewrite `throne.db`, or force-reset TUN from the agent. Tell the user to apply UI changes themselves. Restarting Throne from inside a Throne-routed agent session cuts the agent off mid-task.

## Portable install

Throne Portable ZIP can live in any `<THRONE_DIR>`. Process path rules are **machine-local**: resolve `Cursor.exe` and `cursor-agent\...\node.exe` with the CIM query on the machine where TUN runs (after Cursor updates or if the install path changed). Re-confirm the allowlist on that machine; do not reuse another host’s intranet list blindly. TUN still needs administrator rights on the OS that enables it.

## Modes (do not invert)

| Control | Value | Why |
|---------|--------|-----|
| TUN | On for process rules | `find_process` sees traffic that hits TUN |
| System Proxy | **Off** | Sets WinINET for the whole OS |
| Strict Route | **Off** | Blocks LAN / multi-homed DNS on Windows |
| DNS final outbound | **direct** | Split-horizon needs the OS/corporate resolver |
| Private range bypass | On | RFC1918 stays off TUN routes |
| Tun routing | **Off** | Process rules + Strict off → loops (Throne #1365) |
| Fake-IP / system DNS hijack | Off | Breaks browser and LAN names |

Start a node first, then enable TUN (Admin). Do not persist `tun_mode_enabled=true` before a node and **Cursor only** are selected.

Throne GUI often rewrites `active_routing=Default` and `dns_final_out=remote` on exit. Re-check those keys after any UI session.

## Route profile `Cursor only`

`default_outbound_id = -2` (direct). `-1` = proxy. First match wins — allowlist before process rules.

Resolve live `Cursor.exe` and agent `node.exe` on the machine (same CIM query as in [reference.md](reference.md)). Default install is often `%LOCALAPPDATA%\Programs\cursor\Cursor.exe`; do not assume it.

1. `hijack-dns` / protocol `dns`
2. `ip_is_private` → direct
3. CIDR `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`, `169.254.0.0/16` → direct
4. **User allowlist** → direct (extra CIDRs, suffixes, hosts, keywords; separate rules; generic `name` only)
5. `processName:Cursor.exe` + resolved `Cursor.exe` path → proxy
6. Resolved `%LOCALAPPDATA%\cursor-agent\versions\<ver>\node.exe` **and** regex `(?i)[\\/]cursor-agent[\\/]versions[\\/][^\\/]+[\\/]node\.exe$` → proxy

Do **not** add bare `processName:node.exe`. Names are case-sensitive.

SQL details: [reference.md](reference.md).

## Edit `throne.db`

0. If the allowlist question has not been answered in this chat, **stop** and return to Hard gate. Proceed with RFC1918-only only after the user said so.
1. If this chat’s agent traffic already depends on Throne (TUN or Cursor `http.proxy` into Throne), **stop**. Do not quit Throne, kill `ThroneCore`, rewrite `throne.db`, or reset TUN. Hand the UI/SQL steps to the user and wait.
2. Otherwise (first-time install / agent not on Throne): fully quit Throne (not tray).
3. Backup `config\throne.db` next to the app (no secrets in the backup name).
4. Write `route_profiles` / `route_rules` / `settings`.
5. Confirm `active_routing=Cursor only`, `current_route_id` = that id, `dns_final_out=direct`.
6. Start Throne, pick a node, TUN on, System Proxy off.

Never add `throne.db`, `*.db.bak*`, Throne logs, or Group/subscription exports to git. Publish only this skill folder (`SKILL.md`, `reference.md`, `README.md`, `docs/`), not the Throne install tree.

## Fallback when TUN / admin is blocked

If the user cannot elevate or TUN fails (adapter already exists / Element not found):

1. **Do not** enable System Proxy (WinINET for the whole OS — breaks coexistence with other VPNs / direct apps).
2. Leave Throne running with a selected node, System Proxy **off**, TUN **off**. Mixed inbound stays on `127.0.0.1:<inbound_socks_port>` (Throne default often `2080` — read the live inbound port).
3. Point **only Cursor** at that inbound via User Settings JSON (see [docs/cursor-http-proxy.md](docs/cursor-http-proxy.md)):

```json
{
  "http.proxy": "http://127.0.0.1:2080",
  "http.proxySupport": "override",
  "http.proxyStrictSSL": true,
  "cursor.general.disableHttp2": true
}
```

4. In Cursor **Browser & Network**, set HTTP Compatibility Mode to **HTTP/1.1** only if streaming fails or diagnostics say so, then **fully restart Cursor**.
5. Replace `2080` with the actual mixed inbound port. This path does **not** use process rules; only Cursor honors `http.proxy`. Other apps stay on the normal NIC / corp VPN. If `cursor-agent` must use the tunnel too, escalate to TUN + process rules — do not turn on System Proxy.

Prefer TUN + **Cursor only** when admin is available and agent/helpers must be covered. Use the app-proxy fallback when TUN is impossible or as a first isolation test. Do not enable TUN merely to fix HTTP/2 streaming (use HTTP/1.1 first).

## Verify in logs

Pass:

- `Cursor.exe` / `cursor-agent\...\node.exe` to the public Internet → `outbound/socks[proxy]`
- Same processes to allowlisted names or RFC1918 → `outbound/direct`
- Browser and other apps → `outbound/direct`

Expected noise: `svchost.exe` to the TUN DNS address. SOA for `.` alone is not a LAN outage.

Fail:

- Browser → `socks[proxy]` → System Proxy on or default outbound `-1`
- Intranet / SSO 403 → `dns_final_out=remote`, empty allowlist, or allowlist below process rules
- Agent → `direct` on Cursor cloud APIs → stale agent path/regex
- Whole PC on VPN → profile **Default** + TUN

After Stop, connections from the TUN address to the peer on high ports being reset is teardown, not a new bug.

When checking the DB, report pass/fail in prose. Do not paste `domain_*` / CIDR query rows into git, PRs, chat, or an updated skill.

## Do not

- Enable System Proxy "just to test"
- Use profile **Default** under TUN
- Match all `node.exe`
- Edit the DB while Throne is running and then click Routes / OK
- Turn on Tun routing to "fix" process rules
- Commit or paste the subscription URL
- Invent, scrape, or publish the user's internal domains
- Spoof User-Agent or otherwise bypass WAF/SSO
- Stop/restart Throne, reset TUN, or rewrite `throne.db` from an agent whose traffic already depends on Throne
- Put a subscription URL into the agent prompt or chat logs
