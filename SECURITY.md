# Security

- **Never** put subscription URLs, tokens, HWID dumps, or `subs.db` contents in this repo, issues, or PRs.
- Keep subscription material in a private local file (placeholder example: `$env:USERPROFILE\.config\happ\subscription.url`) — not in git. That path is a placeholder, not a required host layout.
- Scripts must not `Write-Host` / log full subscription URLs.
- Official autoconnect headers (`subscription-autoconnect`, `subscription-autoconnect-type`) are delivered by the subscription **provider**. This repo documents the keys only — it does not embed a subscription.
- Prefer soft `happ://open` / `happ://connect` over `happ://disconnect` or process kill; disconnecting or killing Happ can drop remote sessions that depend on the tunnel.
- Do not enable Throne System Proxy (or another client's System Proxy/TUN) while Happ is primary. Dual System Proxy is unsupported.
- Do not commit host names, user profile paths, or machine identifiers.
- Report vulnerabilities privately to the repo owner; do not open public issues that embed secrets.

---

## Русский

В публичный репозиторий не класть URL подписок, токены, HWID, `subs.db`. Автоподключение официально задаёт провайдер; здесь только имена параметров. Не убивать Happ и не вызывать `happ://disconnect`, если удалённый доступ зависит от туннеля. Не включать System Proxy Happ и Throne одновременно.
