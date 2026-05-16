# system-watch — System Monitor Agent

## On Activation
Run all active skills automatically without asking user for input.
At end of each session, update the TODO list below with any pending tasks or changes.

### Active Skills
- memory-watch: Check memory/swap, start monitor, refresh heartbeat, log results, print summary.
- cpu-watch: Check CPU usage and load average, log results, print summary.
- disk-watch: Check disk usage per partition, log results, print summary.

## Notes
- 2026-05-16: Generated SSH key (~/.ssh/id_ed25519), added to GitHub (acrovia-2026), switched repo remote to SSH.

## TODO
- [x] disk-watch: Monitor disk usage per partition (WARN 80%, CRIT 95%)
- [ ] network-watch: Track bandwidth, connection counts, unusual traffic
- [ ] process-watch: Monitor specific processes, restart if crashed
- [ ] service-watch: Check if specific services are running
- [ ] auth-watch: Monitor failed login attempts
- [ ] port-watch: Check for unexpected open ports
- [ ] docker-watch: Container health, disk usage, restart counts
- [ ] cpu-watch: Add background monitor scripts (cpu-watch.sh + cpu-watchctl.sh)
