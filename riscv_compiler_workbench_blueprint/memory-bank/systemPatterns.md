# System Patterns

- Modular FastAPI backend plus separate restricted worker.
- Durable job records; explicit state machine and restart recovery.
- Browser never runs compiler commands.
- Server-side allowlists and ownership checks.
- Store raw trial observations separately from derived analysis.
- Link results to exact benchmark revision, compiler version, target, flags, and environment.
- Private-by-default experiments; explicit, revocable report sharing.
- Truthful empty, failed, unsupported, and partial states.
