# Skill: cpu-watch

## Description
Monitors CPU usage with multi-tier alerts and per-process tracking.

## Activation
On agent start, automatically:
1. Run `mpstat 1 1` or `top -bn1` and report CPU usage
2. Check if load average exceeds thresholds
3. Log results to `logs/cpu-watch.log`
4. Rotate log if >2MB

## Thresholds
- CPU WARN: 75%
- CPU CRITICAL: 90%
- Load Average WARN: number of cores × 1.5

## Behavior
- Reports overall CPU usage and load average
- Logs top 5 CPU-consuming processes on threshold hit
- Appends snapshots to `logs/cpu-watch-trends.csv` every cycle
