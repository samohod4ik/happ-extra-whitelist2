#!/usr/bin/env python3
"""Static gates for the public Happ Extra Whitelist2 skill.

Run from repo root: python3 tests/test_public_surface.py
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

FORBIDDEN_HOST = [
    (re.compile(r"\bHermes\b", re.I), "host-specific Hermes"),
    (re.compile(r"Марьин"), "host-specific Марьино"),
    (re.compile(r"\balexm\b", re.I), "host-specific username"),
    (re.compile(r"DESKTOP-[A-Z0-9]+", re.I), "host-specific computer name"),
    (re.compile(r"C:\\Hermes", re.I), "private Hermes path"),
]

# Laptop-only framing (desktop/laptop together is OK).
LAPTOP_ONLY = re.compile(
    r"(skill for Windows laptops|Windows laptops\b|clean Windows laptop|"
    r"Windows laptop with|on a Windows laptop)",
    re.I,
)

SECRETISH_URL = re.compile(
    r"https?://[^\s)>\"]*(token|uuid|hwid|subs\.db|/sub/)[^\s)>\"]*",
    re.I,
)

KILL_HAPP = re.compile(r"Stop-Process\s+.*Happ", re.I)
START_DISCONNECT = re.compile(r"Start-Process\s+['\"]happ://disconnect", re.I)


def iter_public_text() -> list[Path]:
    paths: list[Path] = []
    paths.extend(ROOT.glob("*.md"))
    paths.extend(ROOT.glob("docs/**/*.md"))
    paths.extend(ROOT.glob("skills/**/*.md"))
    paths.extend(ROOT.glob("scripts/*.ps1"))
    paths.extend(ROOT.glob("fixtures/*"))
    return [p for p in paths if p.is_file()]


def read(p: Path) -> str:
    return p.read_text(encoding="utf-8")


def fail(msg: str) -> None:
    print(f"FAIL {msg}")
    raise SystemExit(1)


def main() -> None:
    required = [
        ROOT / "scripts" / "Set-HappAutoconnect.ps1",
        ROOT / "scripts" / "Invoke-HappSoftConnect.ps1",
        ROOT / "scripts" / "Install-HappAutostart.ps1",
        ROOT / "scripts" / "Invoke-HappSoftOpen.ps1",
        ROOT / "docs" / "autoconnect.md",
        ROOT / "docs" / "install-pipeline.md",
        ROOT / "docs" / "variant-throne-cursor-only.md",
        ROOT / "skills" / "happ-extra-whitelist2" / "SKILL.md",
        ROOT / "skills" / "throne-cursor-only-public" / "README.md",
        ROOT / "SECURITY.md",
        ROOT / "README.md",
    ]
    for p in required:
        if not p.is_file():
            fail(f"missing required file: {p.relative_to(ROOT)}")

    for p in iter_public_text():
        text = read(p)
        rel = p.relative_to(ROOT)
        for rx, label in FORBIDDEN_HOST:
            if rx.search(text):
                fail(f"{rel}: forbidden {label}")
        if LAPTOP_ONLY.search(text):
            fail(f"{rel}: laptop-only framing (say Windows / Windows PC)")
        if SECRETISH_URL.search(text):
            fail(f"{rel}: looks like a subscription/secret URL")
        if p.suffix.lower() == ".ps1":
            if KILL_HAPP.search(text):
                fail(f"{rel}: kills Happ")
            if START_DISCONNECT.search(text):
                fail(f"{rel}: starts happ://disconnect")

    skill = read(ROOT / "skills" / "happ-extra-whitelist2" / "SKILL.md")
    pipeline = read(ROOT / "docs" / "install-pipeline.md")
    autoconnect_doc = read(ROOT / "docs" / "autoconnect.md")
    security = read(ROOT / "SECURITY.md")
    extra = read(ROOT / "docs" / "extra-whitelist2.md")
    routing = read(ROOT / "docs" / "routing.md")
    set_ac = read(ROOT / "scripts" / "Set-HappAutoconnect.ps1")
    soft_c = read(ROOT / "scripts" / "Invoke-HappSoftConnect.ps1")
    install = read(ROOT / "scripts" / "Install-HappAutostart.ps1")
    verify = read(ROOT / "scripts" / "Verify-HappExtraWhitelist2.ps1")

    for label, text in (
        ("SKILL.md", skill),
        ("install-pipeline.md", pipeline),
        ("autoconnect.md", autoconnect_doc),
    ):
        for needle in (
            "autostart",
            "autoconnect",
            "lastused",
            "happ://connect",
            "Extra Whitelist2",
        ):
            if needle.lower() not in text.lower():
                fail(f"{label}: missing {needle}")

    if not re.search(r"never (kill|Stop-Process)|do not kill|не убивать", skill, re.I):
        fail("SKILL.md: missing hard rule to never kill Happ")
    if "Watch" not in skill and "watch" not in skill:
        fail("SKILL.md: missing Watch guidance")
    if "WHITELIST2" not in routing or "Do not invent" not in routing:
        fail("routing.md: must warn not to invent WHITELIST2 routing")
    if "when those" not in extra.lower() and "if those" not in extra.lower() and "if present" not in extra.lower():
        fail("extra-whitelist2.md: must treat DE/NL Extra Whitelist2 as preference-when-present")
    if "subscription URL" not in security.lower() and "subscription URLs" not in security:
        fail("SECURITY.md: must forbid subscription URLs")

    if "happ://connect" not in set_ac or "happ://connect" not in soft_c:
        fail("connect scripts must invoke happ://connect")
    if "subscription-autoconnect" not in set_ac or "lastused" not in set_ac:
        fail("Set-HappAutoconnect.ps1 must document official lastused headers")
    if re.search(r"New-ItemProperty[\s\S]{0,200}[Aa]uto[Cc]onnect", set_ac):
        fail("Set-HappAutoconnect.ps1 must not invent autoconnect registry values")
    if "Set-HappAutoconnect.ps1" not in install:
        fail("Install-HappAutostart.ps1 should wire the autoconnect nudge")
    if "Autoconnect" not in verify and "autoconnect" not in verify:
        fail("Verify-HappExtraWhitelist2.ps1 must check the autoconnect nudge")
    if "SkipAutoconnectCheck" not in verify:
        fail("Verify-HappExtraWhitelist2.ps1 must allow -SkipAutoconnectCheck")
    if "Get-Process Happ" not in set_ac:
        fail("Set-HappAutoconnect.ps1 must wait for Happ.exe before happ://connect")

    readme = read(ROOT / "README.md")
    variant = read(ROOT / "docs" / "variant-throne-cursor-only.md")
    if "Throne Cursor-only" not in readme or "Happ" not in readme:
        fail("README.md must list Happ and Throne Cursor-only variants")
    if "System Proxy" not in variant or "Cursor.exe" not in variant:
        fail("variant-throne-cursor-only.md must contrast Cursor-only vs full-proxy")
    if not re.search(r"Never.*System Proxy|не включать System Proxy", skill, re.I):
        fail("SKILL.md must forbid dual Happ+Throne System Proxy")
    ru = skill.split("Русский", 1)[-1]
    if "Watch" not in ru:
        fail("SKILL.md RU section must include Watch")
    if "local" not in autoconnect_doc.lower() or "official" not in autoconnect_doc.lower():
        fail("autoconnect.md must separate official headers from local happ://connect")

    print("PASS public surface gates")


if __name__ == "__main__":
    try:
        main()
    except SystemExit as e:
        if e.code not in (0, 1):
            raise
        sys.exit(e.code)
