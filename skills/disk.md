# Skill: disk-watch

## Description
Monitors disk usage per partition with multi-tier alerts.

## Activation
On agent start, automatically:
1. Run `df -h` and report disk usage per partition
2. Flag any partition exceeding thresholds
3. Log results to `logs/disk-watch.log`
4. Rotate log if >2MB

## Thresholds
- Disk WARN: 80%
- Disk CRITICAL: 95%

## Behavior
- Reports usage for all mounted partitions (excludes tmpfs, devtmpfs)
- Logs top space-consuming directories on threshold hit (`du -sh /* 2>/dev/null | sort -rh | head -5`)
