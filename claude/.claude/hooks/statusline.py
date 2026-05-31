#!/usr/bin/env python3
"""Claude Code status line assembler.

Renders each section through its own Starship profile (so the glyphs and colour
thresholds stay native), then fits them to the terminal width Claude Code hands
us in $COLUMNS:

  • wide   -> one line with everything
  • narrow -> shed low-value extras in priority order (reset times, output
              style, lines diff, dir/branch, cost), always keeping model +
              context + the rate-limit gauges
  • too narrow for even those -> break into two rows (identity + context on the
              first, rate limits on the second) so the limits survive instead of
              being chopped off the right edge

Reads the Claude status JSON on stdin; prints the status line on stdout.
Everything degrades to silence on missing data.
"""

import sys, os, re, json, time, subprocess, unicodedata

ANSI = re.compile(r"\x1b\[[0-9;]*m")


def starship(profile, payload):
    try:
        r = subprocess.run(
            ["starship", "statusline", "claude-code", "--profile", profile],
            input=payload, capture_output=True, text=True, timeout=3)
        return r.stdout.strip("\n").rstrip()
    except Exception:
        return ""


def dwidth(s):
    """Display columns: emoji/CJK count as 2, variation selectors as 0."""
    s = ANSI.sub("", s).replace("️", "")
    w = 0
    for ch in s:
        o = ord(ch)
        if 0x1F000 <= o <= 0x1FAFF:
            w += 2
        elif unicodedata.east_asian_width(ch) in ("W", "F"):
            w += 2
        else:
            w += 1
    return w


def until(epoch):
    delta = int(epoch - time.time())
    if delta <= 0:
        return "now"
    days, rem = divmod(delta, 86400)
    h, m = divmod(rem // 60, 60)
    if days:
        return "%dd%dh" % (days, h)
    if h:
        return "%dh%dm" % (h, m)
    return "%dm" % m


def main():
    raw = sys.stdin.read()
    try:
        d = json.loads(raw)
    except Exception:
        return
    try:
        cols = int(os.environ.get("COLUMNS") or 0)
    except ValueError:
        cols = 0
    if cols <= 0:
        cols = 10000  # unknown width: don't shed, let the terminal decide

    gauge_cache = {}

    def gauge(pct):
        k = str(pct)
        if k not in gauge_cache:
            gauge_cache[k] = starship(
                "claude-gauge", json.dumps({"context_window": {"used_percentage": pct}}))
        return gauge_cache[k]

    seg = {}

    db = starship("cc-dirbranch", raw)
    if db:
        seg["dirbranch"] = "📁 " + db

    c = d.get("cost") or {}
    a, r = c.get("total_lines_added") or 0, c.get("total_lines_removed") or 0
    if a or r:
        seg["lines"] = "📝 \033[32m+%d\033[0m/\033[31m-%d\033[0m" % (a, r)

    model = starship("cc-model", raw)
    if model:
        seg["model"] = model

    cw = d.get("context_window") or {}
    if cw.get("used_percentage") is not None:
        seg["context"] = "🧠 " + gauge(cw["used_percentage"])

    cost = starship("cc-cost", raw)
    if cost:
        seg["cost"] = cost

    style = (d.get("output_style") or {}).get("name") or ""
    if style and style != "default":
        seg["style"] = "🎨 " + style

    rl = d.get("rate_limits") or {}
    for key, lbl, emoji in (("five_hour", "5h", "🕔"), ("seven_day", "7d", "📅")):
        w = rl.get(key) or {}
        p = w.get("used_percentage")
        if p is None:
            continue
        seg[key] = "%s %s %s" % (emoji, lbl, gauge(p))
        if w.get("resets_at"):
            seg[key + "_reset"] = "\033[2;37m(%s)\033[0m" % until(w["resets_at"])

    def join(keys):
        return " ".join(seg[k] for k in keys if k in seg)

    def fits(keys):
        return dwidth(join(keys)) <= cols

    # --- one line: drop extras in priority order until it fits -----------------
    ORDER = ["dirbranch", "lines", "model", "context", "cost", "style",
             "five_hour", "five_hour_reset", "seven_day", "seven_day_reset"]
    active = [k for k in ORDER if k in seg]
    for victim in ["seven_day_reset", "five_hour_reset", "style",
                   "lines", "dirbranch", "cost"]:
        if fits(active):
            break
        if victim in active:
            active.remove(victim)
    if fits(active):
        sys.stdout.write(join(active))
        return

    # --- two rows: identity + context, then the rate limits --------------------
    def fit_row(order, drop):
        act = [k for k in order if k in seg]
        for v in drop:
            if dwidth(join(act)) <= cols:
                break
            if v in act:
                act.remove(v)
        return join(act)

    row1 = fit_row(["dirbranch", "lines", "model", "context", "cost", "style"],
                   ["style", "dirbranch", "lines", "cost", "model"])  # context kept
    row2 = fit_row(["five_hour", "five_hour_reset", "seven_day", "seven_day_reset"],
                   ["seven_day_reset", "five_hour_reset", "seven_day", "five_hour"])
    out = row1
    if row2.strip():
        out += "\n" + row2
    sys.stdout.write(out)


main()
