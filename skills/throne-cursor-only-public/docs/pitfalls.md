# Подводные камни

Типичные сбои при настройке Throne + Cursor-only split tunnel.

## TUN и права администратора

- Режим **TUN** требует elevation. «Запуск от имени администратора» без реальных прав → TUN не поднимется.
- Ошибка вида `configure tun interface: create adapter: Cannot create a file when that file already exists | open existing adapter: Element not found` — залипший/битый TUN-адаптер. В UI Throne: **Сброс** ядра, затем снова нода → TUN. Не включать System Proxy «вместо».
- Без TUN process-rules **не** видят чужой трафик: split по `Cursor.exe` не работает.

## System Proxy — не fallback

System Proxy пишет WinINET на **всю** ОС: ломает сосуществование с другим VPN/корпоративным каналом и уводит в proxy приложения, которые должны остаться direct. Для проверки «открывается ли Cursor» это ложный позитив.

Правильный fallback без TUN: app-level `http.proxy` только в Cursor → mixed inbound Throne. См. [cursor-http-proxy.md](cursor-http-proxy.md).

## GUI сбрасывает маршрутизацию

После кликов в UI Throne часто сам ставит:

- `active_routing=Default` (default outbound = proxy → при TUN уезжает весь ПК)
- `dns_final_out=remote` (split-horizon intranet/SSO получает публичные IP → WAF 403)

После любой UI-сессии проверить: профиль **Cursor only**, `dns_final_out=direct`.

## Allowlist обязателен

Cursor матчится **по процессу**. Всё, что не direct-правило, уходит в VPN — включая SSO и intranet-имена. Пустой allowlist = агент не достанет внутренние DNS. Агент должен **спросить** список, не выдумывать и не читать PAC с диска без вложения в чат.

## Пути процессов локальны

`Cursor.exe` и `cursor-agent\versions\<hash>\node.exe` различаются по машинам и обновлениям. После смены каталога Throne, обновления Cursor или переноса на другую машину — снова CIM-запрос. Не матчить голый `node.exe` (системный Node уйдёт в proxy).

## Подписка

- URL только в UI Throne, не в skill/git/чат.
- Форматы других клиентов (например `vpn://`) Throne может не принять — тогда ручной профиль или конвертация.
- Автообновление (`sub_auto_update`) требует, чтобы Throne **работал**. Обновление может остановить активный профиль (#1305); таймер в части сборок сбоил (#1528) — после refresh проверить ноду + TUN.

## Автозапуск

С Throne 1.1.2 — **Task Scheduler** из UI (не registry). Один раз UAC при создании задачи; если Throne был elevated, последующие старты тоже elevated. Путь установки лучше ASCII — Unicode-пути ломали autostart в части сборок.

## Агент уже сидит на Throne

Если текущий Cursor/agent ходит через этот же Throne, **нельзя** из агента гасить Throne/ядро/TUN или переписывать `throne.db` — агент отрежет сам себя. UI-правки делает пользователь.

## Tun routing

`enable_tun_routing=true` вместе с process rules и Strict off → петли (Throne #1365). Держать **Off**.
