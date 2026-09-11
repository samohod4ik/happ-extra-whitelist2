# Throne: только Cursor через VPN

Публичный skill для Cursor Agent: на Windows ставит/настраивает [Throne](https://throneproj.github.io) так, чтобы **через подписку/VPN шёл только трафик Cursor IDE и cursor-agent**. Остальной трафик ОС (браузер, другие приложения, корпоративный канал при наличии) идёт как обычно.

Файлы агента: [`SKILL.md`](SKILL.md), [`reference.md`](reference.md). Подводные камни: [`docs/pitfalls.md`](docs/pitfalls.md). Fallback без TUN: [`docs/cursor-http-proxy.md`](docs/cursor-http-proxy.md). Выводы research: [`docs/research-cursor-http-proxy.md`](docs/research-cursor-http-proxy.md).

## Что сказать Cursor

Пример промпта:

> Настрой VPN только для Cursor по skill `throne-cursor-only-public`. Allowlist внутренних DNS/доменов: \<вставить\>. Ссылку подписки в чат не присылаю — вставлю в UI Throne сам (`Ctrl+V`).

Нужно от пользователя:

1. **Allowlist** суффиксов/хостов/CIDR, которые должны остаться direct (корпоративный DNS / локальная сеть).
2. Подписку — только в окно Throne, не в чат/git/skill.

Агент **не выдумывает** домены и не читает PAC с диска, пока список не прислали в этот чат.

## Быстрый порядок

1. Portable ZIP Throne → `<THRONE_DIR>\Throne.exe`.
2. Импорт подписки в UI → Refresh.
3. Профиль **Cursor only** (default outbound = direct; в proxy только `Cursor.exe` и `cursor-agent\...\node.exe`).
4. Allowlist **выше** process-правил.
5. Запуск **от администратора** → нода → **TUN on**, **System Proxy off**.
6. Логи: Cursor → `socks[proxy]`; прочие приложения → `direct`; allowlist/RFC1918 → `direct`.
7. UI: автозапуск с Windows (elevated Task Scheduler) + автообновление подписки **каждые 30 минут**.

## Сосуществование с другим VPN / корпоративной сетью

Проксируется процесс Cursor (и agent при TUN-правилах), не вся ОС. Имена intranet/SSO в allowlist → `direct`. Без allowlist Cursor утащит их на датацентровый IP → типичны timeout / WAF 403.

## Portable и смена машины

Throne Portable ZIP ставится в любой каталог (`<THRONE_DIR>`). Пути process-правил **локальны для машины**: после копирования каталога или установки Cursor в другое место заново снять `Cursor.exe` / `cursor-agent\...\node.exe` (CIM-запрос в [`reference.md`](reference.md)). Allowlist тоже уточнять на месте. TUN по-прежнему требует прав администратора на той ОС, где его включают.

## Если нет прав на TUN

Не включать System Proxy (WinINET на всю ОС). Вариант: нода в Throne, TUN off, System Proxy off + в Cursor `http.proxy` на mixed inbound и при необходимости HTTP/1.1. См. [`docs/cursor-http-proxy.md`](docs/cursor-http-proxy.md).

## Чего skill намеренно не делает

- Не публикует URL подписок и чужие внутренние домены.
- Не рекомендует System Proxy как способ «просто проверить».
- Не обходит политики доступа / WAF / SSO подменой клиента.
