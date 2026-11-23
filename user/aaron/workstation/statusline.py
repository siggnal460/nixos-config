#!/usr/bin/env python3
"""Claude Code status line: model, directory, session cost, and context usage.

Reads the session JSON on stdin; see https://code.claude.com/docs/en/statusline
for the schema. Most fields are absent or null early in a session, so every
lookup falls back instead of raising -- a crash here blanks the status line.
"""

import json
import os
import sys

DIM = "\033[2m"
CYAN = "\033[2;36m"
GREEN = "\033[2;32m"
RESET = "\033[0m"


def cost_segment(data):
    """Session cost in USD, accumulated across all API calls since /clear."""
    cost_usd = (data.get("cost") or {}).get("total_cost_usd")
    if not isinstance(cost_usd, (int, float)):
        return DIM + "cost: n/a" + RESET
    return GREEN + "${:.2f}".format(cost_usd) + RESET


def context_segment(data):
    """Remaining context tokens plus the share of the window already used."""
    window = data.get("context_window") or {}
    size = window.get("context_window_size")
    used = window.get("total_input_tokens")

    left = None
    if isinstance(size, int) and isinstance(used, int):
        left = max(size - used, 0)
    else:
        remaining_pct = window.get("remaining_percentage")
        if isinstance(size, int) and isinstance(remaining_pct, (int, float)):
            left = int(size * remaining_pct / 100)

    if left is None or not size:
        return DIM + "context: n/a" + RESET

    share = left / size
    # Warm colours as the window fills up.
    colour = "\033[2;33m"
    if share < 0.1:
        colour = "\033[1;31m"
    elif share < 0.25:
        colour = "\033[2;31m"

    used_pct = window.get("used_percentage")
    if not isinstance(used_pct, (int, float)):
        used_pct = 100 - share * 100

    return (
        colour + format(left, ",") + " tokens left" + RESET
        + DIM + " ({:.0f}% used)".format(used_pct) + RESET
    )


def main():
    try:
        data = json.load(sys.stdin)
    except Exception:
        return

    model = (data.get("model") or {}).get("display_name") or "?"
    cwd = (data.get("workspace") or {}).get("current_dir") or data.get("cwd") or ""
    directory = os.path.basename(cwd.rstrip("/")) or cwd or "?"

    print(
        CYAN + model + RESET
        + DIM + " in " + RESET + CYAN + directory + RESET
        + DIM + " | " + RESET + cost_segment(data)
        + DIM + " | " + RESET + context_segment(data),
        end="",
    )


main()
