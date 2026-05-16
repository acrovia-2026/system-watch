#!/bin/bash
# system-watch test script (memory skill)

CTL="$HOME/.kiro/agents/system-watch/scripts/memory-watchctl.sh"
LOG="$HOME/.kiro/agents/system-watch/logs/memory-watch.log"
CSV="$HOME/.kiro/agents/system-watch/logs/memory-watch-trends.csv"
HB="$HOME/.memory-watch.heartbeat"
PASS=0
FAIL=0

step() { echo -e "\n[$1] $2"; }
pass() { echo "  ✅ PASSED"; ((PASS++)); }
fail() { echo "  ❌ FAILED: $1"; ((FAIL++)); }

# Clean state
"$CTL" stop &>/dev/null
rm -f "$LOG" "$CSV"

step 1 "Start monitor"
touch "$HB"
"$CTL" start &>/dev/null
sleep 2
if "$CTL" status 2>/dev/null | grep -q "running"; then
    pass
else
    fail "Monitor did not start"
fi

step 2 "Verify CSV output"
if [ -f "$CSV" ] && [ "$(wc -l < "$CSV")" -ge 2 ]; then
    pass
else
    fail "CSV missing or no data rows"
fi

step 3 "Verify log has start entry"
if grep -q "memory-watch started" "$LOG"; then
    pass
else
    fail "Start entry not in log"
fi

step 4 "Stop monitor"
"$CTL" stop &>/dev/null
sleep 3
if "$CTL" status 2>/dev/null | grep -q "not running"; then
    pass
else
    fail "Monitor did not stop"
fi

step 5 "Heartbeat auto-stop test"
touch "$HB"
"$CTL" start &>/dev/null
sleep 2
touch -d "310 seconds ago" "$HB"
echo "  Waiting for auto-stop (~12s)..."
sleep 12
if "$CTL" status 2>/dev/null | grep -q "not running"; then
    pass
else
    fail "Monitor did not auto-stop on stale heartbeat"
fi

step 6 "Verify auto-stop log message"
if grep -q "No heartbeat" "$LOG"; then
    pass
else
    fail "Expected heartbeat timeout log not found"
fi

echo -e "\n--- Results: $PASS passed, $FAIL failed ---"
