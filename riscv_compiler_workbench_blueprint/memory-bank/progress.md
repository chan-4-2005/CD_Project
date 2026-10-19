# Progress

## Completed
- Product scope and six product areas defined.
- Initial architecture and data entities planned.
- Research integrity rules and measurement definitions documented.
- Friend access, quotas, privacy, and report sharing policy drafted.
- Three-day MVP target and release tests defined.
- Phase 1 local feasibility validated 2026-10-17 (details: `docs/PHASE1_FEASIBILITY_REPORT.md`):
  - Environment inspected: Windows 11 x64 + WSL2 Ubuntu 24.04.3; MSYS2 GCC 13.2.0 (x86_64 only); WSL gcc 13.3.0.
  - Installed in WSL: riscv64-linux-gnu-gcc 13.3.0, clang 18.1.3, qemu-riscv64 8.2.2 (user-mode). All free/local.
  - Created minimal deterministic benchmark `benchmarks/poc-matmul/matmul.c` (integer matmul, fixed seed, FNV-1a checksum) plus `run_poc.sh` / `launch_poc.sh`.
  - Compiled with both GCC (rv64gc, rv64gcv) and Clang (rv64gc, rv64gcv), static; executed under qemu-riscv64.
  - Correctness PASS: checksum 0x326165c972aaa79d identical across native x86_64 reference, GCC rv64gc, Clang rv64gc, and both RVV builds on every run.
  - Genuine timing captured (3 repeats each); emulated run-to-run spread and one Clang-RVV anomaly recorded, not yet diagnosed.
- Updated `docs/BENCHMARK_INVENTORY.md` and `docs/DEPLOYMENT.md` with verified findings only.
- Phase 1.5 hosted-worker evaluation prepared 2026-10-17 (details: `docs/PHASE1_FEASIBILITY_REPORT.md` §11):
  - Evaluated GitHub Actions standard hosted runners; verified from official docs that `ubuntu-latest` maps to Ubuntu 24.04 and that Actions minutes are free for public repositories (private repos consume plan quotas; exact free amounts UNKNOWN — owner must verify).
  - Verified locally: blueprint directory is not a git repository, no remote, `gh` CLI unavailable — a hosted run cannot be triggered from this machine.
  - Created minimal manual-trigger workflow `.github/workflows/riscv-poc-hosted-validation.yml` (ubuntu-24.04, installs gcc-riscv64-linux-gnu/clang/qemu-user/file, runs existing run_poc.sh unchanged for rv64gc GCC+Clang, asserts checksum 0x326165c972aaa79d, uploads artifacts, 20-min cap, no secrets, no RVV).
  - Status: HOSTED EXECUTION PENDING — workflow created but NOT executed; owner must create/push a repo and trigger it manually (exact steps in report §11).
- Phase 1 documentation finalized 2026-10-17:
  - Created `docs/PHASE1_5_HOSTED_VALIDATION_REPORT.md` — dedicated Phase 1.5 record: HOSTED EXECUTION PENDING, prepared-workflow description, PASS/FAIL/PENDING/UNKNOWN findings table, free-tier citations, and an evidence checklist that stays empty until a real hosted run's log/artifact exists (no fabricated run data).
  - Re-verified official sources 2026-10-17: GitHub Actions billing docs (public repos free on standard hosted runners; private repos quota-based with overage billed and usage blocked without a payment method on file; overage reference $0.006/min Linux 2-core, $0.25/GB-month artifact storage) and actions/runner-images README (Ubuntu 24.04 x64 labels `ubuntu-latest` / `ubuntu-24.04`; newer Ubuntu 26.04 image exists). Exact Free-plan monthly minute/storage allowance remains UNKNOWN.
  - Confirmed again: no git repository/remote, no `gh` CLI, and no hosted run logs or artifacts anywhere in the workspace → HOSTED EXECUTION PENDING preserved. Local PoC results and commands untouched; QEMU labeled emulation-only throughout; Clang RVV timing anomaly preserved as an open issue; no benchmark code modified; no backend/frontend/auth/DB/queue implemented; Phase 2 not started.

## Not completed
- No hosted free-tier worker provisioned or validated — HOSTED EXECUTION PENDING (workflow `.github/workflows/riscv-poc-hosted-validation.yml` prepared but not executed; no run ID, URL, logs, or artifacts exist). Evidence checklist awaiting the real run: `docs/PHASE1_5_HOSTED_VALIDATION_REPORT.md` §5.
- No benchmark validated in the hosted target environment.
- Exact GitHub Free minute/storage quotas not confirmed (UNKNOWN).
- No repository/application implementation (frontend, API, DB) — intentionally deferred per Phase 1 rules and awaiting owner authorization.
- No deployment performed.
- Clang RVV timing anomaly not diagnosed (open issue; RVV excluded from hosted workflow until resolved).
- Paper inventory reconciliation not started.
- Worker-model suitability beyond single CI run (repeated jobs, concurrency, persistence) untested; a single successful GitHub Actions run would not prove suitability as a persistent production worker.

## Current blocker
Owner action required: create a GitHub repository (public recommended for free Actions minutes), push the blueprint directory, and manually trigger the `riscv-poc-hosted-validation` workflow (steps: `docs/PHASE1_FEASIBILITY_REPORT.md` §11 and `docs/PHASE1_5_HOSTED_VALIDATION_REPORT.md` §6). Then provide the run log and `riscv-poc-hosted-results` artifact so the evidence checklist can be filled and hosted validation marked PASS or FAIL. Do not proceed to application implementation until hosted validation passes and the owner authorizes the next phase.
