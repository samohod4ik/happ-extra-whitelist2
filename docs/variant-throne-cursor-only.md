# Variant: Throne Cursor-only vs Happ full-proxy

Two **mutually exclusive primary** install paths on a **Windows** PC. Pick one owner of System Proxy / TUN. Do not run both as OS-wide proxy.

| | **1. Happ (full-proxy)** | **2. Throne Cursor-only** |
|---|-------------------------|---------------------------|
| Who is tunneled | Whole OS (Happ System Proxy + TUN) | Only `Cursor.exe` and the cursor-agent node |
| Rest of OS | Through Happ | **Direct** (no Throne System Proxy) |
| Routing | RoscomVPN **WHITELIST** | Per Throne skill (not a second Happ TUN) |
| Exits | Extra Whitelist2 DE then NL **when those remarks exist** | Per that skill / last used Throne outbound |
| Persistence | `Happ.exe --autostart` + autoconnect `lastused` | Per Throne skill (do not copy Happ `--autostart` here) |
| Skill | [`skills/happ-extra-whitelist2/SKILL.md`](../skills/happ-extra-whitelist2/SKILL.md) | [`skills/throne-cursor-only-public/`](../skills/throne-cursor-only-public/) |

## When to choose Happ

- Need the **whole machine** on the proxy (browser, agents, other apps).
- Remote access to the host **depends on the VPN**.
- Want WHITELIST split + Extra Whitelist2 DE/NL when those remarks exist.
- Need logon autostart **and** autoconnect (`lastused` / soft `happ://connect`).

Pipeline: [install-pipeline.md](install-pipeline.md) · [autoconnect.md](autoconnect.md).

## When to choose Throne Cursor-only

- Only Cursor (IDE + `cursor-agent`) must use the VPN.
- Everything else should stay on the ISP path.
- Happ is **not** the primary OS proxy on this machine (or Happ is unused).

Follow the Throne skill folder (SKILL, reference, cursor-http-proxy / pitfalls / research). Do not invent a second System Proxy.

## Hard rules (both variants)

1. **Never** enable Throne System Proxy and Happ System Proxy at the same time.
2. If Happ is primary: Throne is spare only — Throne System Proxy **off**, Throne TUN **off**.
3. If Throne Cursor-only is primary: Happ System Proxy **off**, Happ TUN **off**. Do not install Happ `--autostart` + connect nudge on that machine.
4. Never kill Happ (or drop `happ://disconnect`) while a remote session depends on the Happ tunnel.
5. No subscription URLs, tokens, or host-specific paths in this repo.

## Watch (Happ primary)

Process up, TUN/proxy down → soft `happ://connect`. Not kill.

## Watch (Throne Cursor-only)

If Cursor/`cursor-agent` is not going through the intended local proxy, follow the Throne skill pitfalls — do not "fix" it by turning on Happ System Proxy beside Throne.

---

## Русский

Два варианта, **не два системных прокси сразу**.

1. **Happ** — весь Windows через Happ (TUN/System Proxy), WHITELIST, Extra Whitelist2 DE→NL если remark есть, автозапуск + автоподключение `lastused`.
2. **Throne Cursor-only** — в VPN только Cursor.exe и cursor-agent; остальная ОС напрямую. См. `skills/throne-cursor-only-public/`.

Не включать System Proxy Happ и Throne вместе. Если Happ основной — Throne spare (без своего System Proxy/TUN).
