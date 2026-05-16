#!/bin/bash
# system-watch install: set permissions, clean up old agents

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

chmod +x "$SCRIPT_DIR"/*.sh

# Stop old memory-watch monitor if running
if [ -f "$HOME/.memory-watch.pid" ] && kill -0 "$(cat "$HOME/.memory-watch.pid")" 2>/dev/null; then
    kill "$(cat "$HOME/.memory-watch.pid")" 2>/dev/null
    echo "Stopped old monitor."
fi

# Remove old agents
rm -f "$HOME/.memory-watch.pid" "$HOME/.memory-watch.heartbeat"
rm -f "$HOME/kiro_ww.sh" "$HOME/kiro_wwctl.sh" "$HOME/.kiro_ww.pid" "$HOME/.kiro_ww.heartbeat"
rm -rf "$HOME/.kiro/agents/kiro_ww"
rm -rf "$HOME/.kiro/agents/memory-watch"

echo "system-watch installed. Old agents removed."
echo "Control memory skill: ~/.kiro/agents/system-watch/scripts/memory-watchctl.sh {start|stop|status}"
