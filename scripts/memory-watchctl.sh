#!/bin/bash
# memory-watch control script (skill of system-watch agent)

MONITOR="$HOME/.kiro/agents/system-watch/scripts/memory-watch.sh"
LOG_FILE="$HOME/.kiro/agents/system-watch/logs/memory-watch.log"
PID_FILE="$HOME/.memory-watch.pid"

case "$1" in
    start)
        if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
            echo "memory-watch already running (PID: $(cat "$PID_FILE"))"
        else
            nohup "$MONITOR" &>/dev/null &
            sleep 1
            echo "memory-watch started (PID: $(cat "$PID_FILE"))"
        fi
        ;;
    stop)
        if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
            kill "$(cat "$PID_FILE")" 2>/dev/null
            sleep 1
            echo "memory-watch stopped."
        else
            echo "memory-watch not running."
        fi
        ;;
    status)
        if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
            echo "memory-watch running (PID: $(cat "$PID_FILE"))"
            tail -5 "$LOG_FILE" 2>/dev/null
        else
            echo "memory-watch not running."
        fi
        ;;
    *)
        echo "Usage: memory-watchctl.sh {start|stop|status}"
        exit 1
        ;;
esac
