# Project Guidelines for Coding Agents

1. Read `PROJECT.md`, `ARCHITECTURE.md`, and the relevant `docs/` files before changing anything.
2. Do not start implementation unless the project owner explicitly authorizes it.
3. Do not invent benchmark results, compiler versions, environment capabilities, or test outcomes.
4. Keep changes small and testable; explain files changed and commands/tests run.
5. Never accept arbitrary shell commands or untrusted compiler flags from users.
6. Enforce authorization and quotas server-side.
7. Store raw observations and metadata; do not persist only aggregates.
8. Label measured, derived, paper-reported, and unavailable values distinctly.
9. Never claim emulation equals native RISC-V hardware performance.
10. If a test cannot be run, state that clearly instead of claiming it passed.
11. Preserve private-by-default experiment access and revocable report sharing.
12. Do not add infrastructure complexity without a concrete requirement.
