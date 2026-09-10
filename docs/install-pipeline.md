# Install pipeline

Ordered steps for a clean Windows laptop.

1. **Download / install Happ** from the vendor (FlyFrog / happ.su). Note `Happ.exe` path (often `C:\Program Files\FlyFrogLLC\Happ\Happ.exe`).
2. **First launch** — complete vendor onboarding; leave System Proxy + TUN as Happ manages them.
3. **Subscription** — add via UI or private URL file. Never paste the URL into git/chat logs.
4. **Routing** — import RoscomVPN **WHITELIST** ([routing.md](routing.md)); enable Use routing.
5. **Exit pick** — Extra Whitelist2, DE → NL ([extra-whitelist2.md](extra-whitelist2.md)).
6. **Refresh interval** — `scripts/Set-HappSubscriptionRefresh.ps1` → 60 minutes.
7. **Autostart** — `scripts/Install-HappAutostart.ps1` → `Happ.exe --autostart`.
8. **Soft open** — `scripts/Invoke-HappSoftOpen.ps1`.
9. **Verify** — `scripts/Verify-HappExtraWhitelist2.ps1`.

## Failure modes

| Symptom | Likely cause | Soft fix |
|---------|--------------|----------|
| No servers | Sub not added / update failed | UI Update; check registry 60m; `happ://open` |
| Full tunnel, no split | Routing empty / Use routing off | Re-import WHITELIST; enable useRouting |
| Wrong country | Connected to non-Extra-Whitelist2 or non-DE/NL | Reselect in UI |
| Remote agents drop | Disconnect/kill Happ | Prefer soft open; avoid disconnect |
