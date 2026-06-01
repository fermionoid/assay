#!/bin/sh
# test_capture.sh: dependency-free test for bin/assay-capture.
# Stdlib and POSIX shell only. No installs. Run from anywhere:
#   sh tests/test_capture.sh

set -eu

# Locate the script relative to this test file.
here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
capture="$here/../bin/assay-capture"

pass=0
fail=0

ok() { pass=$((pass + 1)); echo "ok   - $1"; }
no() { fail=$((fail + 1)); echo "FAIL - $1"; }

# Fresh temp context dir, cleaned up on exit.
tmp=$(mktemp -d 2>/dev/null || mktemp -d -t assaytest)
trap 'rm -rf "$tmp"' EXIT INT TERM
mkdir -p "$tmp/branches/self" "$tmp/branches/work"

# 1. --dir captures to the right inbox.
out=$("$capture" --dir "$tmp" self "first capture")
if grep -q "first capture" "$tmp/branches/self/inbox.md"; then
  ok "--dir appends the text to the branch inbox"
else
  no "--dir did not append text"
fi

# 2. The appended line matches the "- [ISO8601] text" format.
last=$(tail -n 1 "$tmp/branches/self/inbox.md")
if echo "$last" | grep -Eq '^- \[[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}[+-][0-9]{4}\] first capture$'; then
  ok "line matches '- [ISO8601] text' format"
else
  no "line format wrong: $last"
fi

# 3. Append-only: a second capture adds a line, keeps the first.
"$capture" --dir "$tmp" self "second capture" >/dev/null
n=$(grep -c "capture" "$tmp/branches/self/inbox.md")
if [ "$n" -eq 2 ]; then
  ok "captures are append-only (2 lines present)"
else
  no "expected 2 capture lines, found $n"
fi

# 4. $ASSAY_DIR is honored when --dir is absent.
ASSAY_DIR="$tmp" "$capture" work "via env" >/dev/null
if grep -q "via env" "$tmp/branches/work/inbox.md"; then
  ok "\$ASSAY_DIR resolves the context dir"
else
  no "\$ASSAY_DIR was not honored"
fi

# 5. --dir overrides $ASSAY_DIR.
other=$(mktemp -d 2>/dev/null || mktemp -d -t assaytest2)
mkdir -p "$other/branches/self"
ASSAY_DIR="$tmp" "$capture" --dir "$other" self "override" >/dev/null
if grep -q "override" "$other/branches/self/inbox.md" && \
   ! grep -q "override" "$tmp/branches/self/inbox.md"; then
  ok "--dir overrides \$ASSAY_DIR"
else
  no "--dir did not override \$ASSAY_DIR"
fi
rm -rf "$other"

# 6. Unknown branch fails with non-zero exit and writes nothing.
if "$capture" --dir "$tmp" ghost "nope" >/dev/null 2>&1; then
  no "unknown branch should have failed but exited 0"
else
  ok "unknown branch exits non-zero"
fi

# 7. Missing arguments print usage and exit non-zero.
if "$capture" --dir "$tmp" self >/dev/null 2>&1; then
  no "missing text should have failed but exited 0"
else
  ok "missing text exits non-zero"
fi

# 8. Multi-word text is captured whole.
"$capture" --dir "$tmp" self "three word phrase" >/dev/null
if tail -n 1 "$tmp/branches/self/inbox.md" | grep -q "three word phrase"; then
  ok "multi-word text captured whole"
else
  no "multi-word text mangled"
fi

echo
echo "passed: $pass  failed: $fail"
[ "$fail" -eq 0 ]
