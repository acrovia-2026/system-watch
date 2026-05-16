# system-watch

A kiro-cli agent that monitors system resources. Supports multiple skills (memory, disk, cpu, etc.) that run automatically on activation.

## Files

| File | Purpose |
|------|---------|
| `system-watch.json` | Agent configuration |
| `NOTES.md` | Persistent notes loaded on activation |

### skills/

| File | Purpose |
|------|---------|
| `memory.md` | Memory-watch skill documentation |
| `cpu.md` | CPU-watch skill documentation |
| `disk.md` | Disk-watch skill documentation |

### logs/

| File | Purpose |
|------|---------|
| `memory-watch.log` | Runtime log — alerts, start/stop events, top processes |
| `memory-watch-trends.csv` | Historical memory/swap snapshots every 10s |
| `cpu-watch.log` | CPU usage and load average log |
| `disk-watch.log` | Disk usage per partition log |

### scripts/

| File | Purpose |
|------|---------|
| `memory-watch.sh` | Background memory monitor loop |
| `memory-watchctl.sh` | Control interface (start/stop/status) |
| `install.sh` | Setup — permissions + cleanup of old agents |
| `test.sh` | Integration tests |

## Installation

```bash
cd ~/.kiro/agents/system-watch/scripts
chmod +x *.sh
./install.sh
```

## How to Use

### 1. Launch the agent

```bash
kilr
```

This automatically sends "hi" which triggers all active skills immediately — no typing needed. You'll see the status summary, then you're in a normal chat session.

### 2. Control memory monitor manually

```bash
~/.kiro/agents/system-watch/scripts/memory-watchctl.sh start
~/.kiro/agents/system-watch/scripts/memory-watchctl.sh status
~/.kiro/agents/system-watch/scripts/memory-watchctl.sh stop
```

### 3. View logs and trends

```bash
cat ~/.kiro/agents/system-watch/logs/memory-watch.log
column -t -s, ~/.kiro/agents/system-watch/logs/memory-watch-trends.csv | tail -20
```

### 4. Run tests

```bash
~/.kiro/agents/system-watch/scripts/test.sh
```

## Thresholds

| Metric | Level | Threshold |
|--------|-------|-----------|
| Memory | WARN | 75% |
| Memory | CRITICAL | 90% |
| Swap | WARN | 80% |
| CPU | WARN | 75% |
| CPU | CRITICAL | 90% |
| Load Avg | WARN | cores × 1.5 |
| Disk | WARN | 80% |
| Disk | CRITICAL | 95% |

## Adding New Skills

1. Create `skills/newskill.md` documenting the behavior
2. Add script(s) to `scripts/`
3. Add the skill file to `resources` in `system-watch.json`
4. Update the prompt in `system-watch.json` to include the new skill's activation steps
5. Update `NOTES.md` to list the new skill as active

## Heartbeat

The memory monitor auto-stops after 300 seconds without a heartbeat. The agent touches `~/.memory-watch.heartbeat` on activation.
