# Security

- **Never** put subscription URLs, tokens, HWID dumps, or `subs.db` contents in this repo, issues, or PRs.
- Keep subscription material in a private local file (example placeholder path in scripts: `$env:USERPROFILE\.config\happ\subscription.url`) — not in git.
- Scripts must not `Write-Host` / log full subscription URLs.
- Prefer soft `happ://open` over `happ://disconnect` or process kill; disconnecting can drop remote agent sessions that depend on the tunnel.
- Throne / Nekoray / sing-box GUIs are spare only: do not enable their System Proxy or TUN while Happ is primary.
- Report vulnerabilities privately to the repo owner; do not open public issues that embed secrets.
