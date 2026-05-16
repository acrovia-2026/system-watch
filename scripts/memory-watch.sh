#!/bin/bash
# memory-watch background monitor (skill of system-watch agent)

WARN_THRESHOLD=75
CRITICAL_THRESHOLD=90
SWAP_THRESHOLD=80
CHECK_INTERVAL=10
HEARTBEAT_TIMEOUT=300
LOG_FILE="$HOME/.kiro/agents/system-watch/logs/memory-watch.log"
TRENDS_FILE="$HOME/.kiro/agents/system-watch/logs/memory-watch-trends.csv"
PID_FILE="$HOME/.memory-watch.pid"
HEARTBEAT_FILE="$HOME/.memory-watch.heartbeat"
MAX_LOG_SIZE=2097152

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [memory-watch] $1" >> "$LOG_FILE"
}

rotate_log() {
    if [ -f "$LOG_FILE" ] && [ "$(stat -c%s "$LOG_FILE" 2>/dev/null || echo 0)" -gt "$MAX_LOG_SIZE" ]; then
        mv "$LOG_FILE" "${LOG_FILE}.1"
    fi
}

cleanup() {
    log "memory-watch stopped."
    rm -f "$PID_FILE"
    exit 0
}

trap cleanup SIGTERM SIGINT

echo $$ > "$PID_FILE"
touch "$HEARTBEAT_FILE"
log "memory-watch started (PID: $$)"

if [ ! -f "$TRENDS_FILE" ]; then
    echo "timestamp,mem_total_mb,mem_used_mb,mem_pct,swap_total_mb,swap_used_mb,swap_pct" > "$TRENDS_FILE"
fi

while true; do
    if [ -f "$HEARTBEAT_FILE" ]; then
        last_beat=$(stat -c %Y "$HEARTBEAT_FILE")
        now=$(date +%s)
        if [ $((now - last_beat)) -gt "$HEARTBEAT_TIMEOUT" ]; then
            log "No heartbeat for ${HEARTBEAT_TIMEOUT}s — auto-stopping."
            cleanup
        fi
    else
        log "Heartbeat file missing — auto-stopping."
        cleanup
    fi

    read mem_total mem_used mem_free <<< $(free -m | awk '/Mem:/ {print $2, $3, $4}')
    read swap_total swap_used swap_free <<< $(free -m | awk '/Swap:/ {print $2, $3, $4}')

    mem_pct=$((mem_used * 100 / mem_total))
    if [ "$swap_total" -gt 0 ]; then
        swap_pct=$((swap_used * 100 / swap_total))
    else
        swap_pct=0
    fi

    echo "$(date '+%Y-%m-%d %H:%M:%S'),$mem_total,$mem_used,$mem_pct,$swap_total,$swap_used,$swap_pct" >> "$TRENDS_FILE"

    if [ "$mem_pct" -ge "$CRITICAL_THRESHOLD" ]; then
        log "CRITICAL: Memory at ${mem_pct}% (${mem_used}MB/${mem_total}MB)"
        ps aux --sort=-%mem | head -6 | tail -5 | while read -r line; do
            log "  TOP: $line"
        done
    elif [ "$mem_pct" -ge "$WARN_THRESHOLD" ]; then
        log "WARN: Memory at ${mem_pct}% (${mem_used}MB/${mem_total}MB)"
        ps aux --sort=-%mem | head -6 | tail -5 | while read -r line; do
            log "  TOP: $line"
        done
    fi

    if [ "$swap_pct" -ge "$SWAP_THRESHOLD" ]; then
        log "WARN: Swap at ${swap_pct}% (${swap_used}MB/${swap_total}MB)"
    fi

    rotate_log
    sleep "$CHECK_INTERVAL" &
    wait $!
done
