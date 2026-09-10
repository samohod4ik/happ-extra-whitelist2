# Extra Whitelist2 (server group)

**Extra Whitelist2** is a **remark / folder label** on subscription servers inside Happ — not a RoscomVPN routing profile.

## Selection policy

1. Filter servers whose remark/title contains `Extra Whitelist2` (exact phrase; do not use plain `Extra Whitelist` without `2`).
2. Prefer **Germany** (`Германия`, `Germany`, `DE`) among those.
3. Else prefer **Netherlands** (`Нидерланды`, `Netherlands`, `NL`).
4. Other Extra Whitelist2 countries (e.g. FI/SE/LT) are fallbacks only if DE/NL are missing or unhealthy.

## How to apply

Happ does not expose a stable public deeplink for "connect to remark X". Agents should:

1. Open Happ UI → server / profile list.
2. Locate the Extra Whitelist2 group or matching remarks.
3. Connect DE, else NL.
4. Confirm connectivity (e.g. a simple HTTPS probe the user allows).

Synthetic example labels (fixtures only): see `fixtures/example-server-labels.txt`.

## Do not

- Hardcode real hostnames, ports, or UUIDs from a live subscription.
- Confuse this label with RoscomVPN **WHITELIST** routing.
