# Skill: memory-watch

## Description
Monitors system memory and swap usage with multi-tier alerts, per-process tracking, and trend logging.

## Activation
On agent start, automatically:
1. Run `free -h` and report memory/swap status
2. Touch `~/.memory-watch.heartbeat`
3. Check monitor via `~/.kiro/agents/system-watch/scripts/memory-watchctl.sh status`
4. Start if not running
5. Log results to `logs/memory-watch.log`
6. Rotate log if >2MB

## Thresholds
- Memory WARN: 75%
- Memory CRITICAL: 90%
- Swap WARN: 80%

## Behavior
- Check interval: 10 seconds
- Heartbeat timeout: 300 seconds
- Auto-stops when heartbeat expires
- Logs top 5 memory-consuming processes on threshold hit
- Appends snapshots to `logs/memory-watch-trends.csv` every cycle

## Scripts
- `scripts/memory-watch.sh` — Background monitor loop
- `scripts/memory-watchctl.sh` — Control (start/stop/status)
