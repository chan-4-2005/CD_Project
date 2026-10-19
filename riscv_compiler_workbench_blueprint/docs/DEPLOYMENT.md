# Deployment Plan

## Provider constraint
Free tiers only. Provider terms and quotas change, so verify current official documentation during setup. Treat all hosting selections as provisional until a real worker test passes.

## Phase 1 local feasibility (verified 2026-10-17)
Local development validation passed on WSL2 Ubuntu-24.04.3 LTS: riscv64-linux-gnu-gcc 13.3.0 and clang 18.1.3 cross-compiled the poc-matmul benchmark (rv64gc, static); qemu-riscv64 8.2.2 (user-mode) executed both binaries with identical correctness checksums; timing was captured via CLOCK_MONOTONIC. rv64gcv builds also executed correctly under QEMU with vlen=128. Full measured data: `docs/PHASE1_FEASIBILITY_REPORT.md`.

All of these results are emulation measurements under QEMU user-mode (TCG), not native RISC-V hardware measurements, and the emulated timings are not usable as performance figures. The local Clang rv64gcv timing anomaly (~2453 ms vs ~116.8 ms for GCC rv64gcv) remains undiagnosed and is an open issue; no RVV performance claim is made.

This local result does NOT validate any hosted free-tier worker. The deployment sequence below still starts at step 1 (verify current free-tier terms) and step 2 (prove compiler/runtime feasibility in the actual worker). Free-tier worker risks: QEMU/TCG throttling, ephemeral filesystems (results must be pushed externally per trial), sleep/idle policies killing jobs, and per-day quotas.

## Phase 1.5 hosted worker evaluation (status: HOSTED EXECUTION PENDING, 2026-10-17)
GitHub Actions standard hosted runners were evaluated as the free-tier validation environment. Official sources consulted on 2026-10-17:
- `actions/runner-images` README (https://raw.githubusercontent.com/actions/runner-images/main/README.md): Ubuntu 24.04 x64 image labels are `ubuntu-latest` or `ubuntu-24.04`; `ubuntu-latest` currently maps to Ubuntu 24.04 — the same release validated locally. A newer Ubuntu 26.04 image exists; the workflow deliberately pins `ubuntu-24.04`.
- GitHub Docs "About billing for GitHub Actions" (https://docs.github.com/en/billing/managing-billing-for-your-products/managing-billing-for-github-actions/about-billing-for-github-actions): verbatim, "GitHub Actions usage is free for self-hosted runners and for public repositories that use standard GitHub-hosted runners." Private repositories consume a plan-based monthly free quota of minutes/artifact storage/cache storage; verbatim, "Any usage beyond the included amounts is billed to your account"; with no payment method on file, verbatim, "usage is blocked once you use up your quota." Published overage reference rates: Linux 2-core (x64) $0.006 per minute; shared artifact storage $0.25 per GB/month. Exact Free-plan monthly minute/storage amounts could not be confirmed from the fetched pages — **UNKNOWN**; the owner must verify them in GitHub billing settings before choosing repository visibility. Do not guess.

A minimal manually triggered validation workflow exists at `.github/workflows/riscv-poc-hosted-validation.yml` (reuses the existing PoC script unchanged, asserts the documented checksum `0x326165c972aaa79d`, uploads raw artifacts, 20-minute cap, no secrets, rv64gc scalar only — RVV excluded pending anomaly diagnosis). Status: **HOSTED EXECUTION PENDING** — the workflow has NOT been executed. No hosted run ID, run URL, hosted logs, or hosted artifacts exist; a hosted run cannot be triggered from this machine (no git repository, no remote, no `gh` CLI). No hosted tool versions, checksums, timings, or failures are recorded because none have been produced. Owner execution steps: `docs/PHASE1_FEASIBILITY_REPORT.md` §11. Consolidated record and evidence checklist to fill from the real run: `docs/PHASE1_5_HOSTED_VALIDATION_REPORT.md`.

Important: a GitHub Actions runner is ephemeral and event-triggered. Even a successful hosted run would validate the toolchain/execution path only; it would NOT prove suitability as a persistent production worker (no job-queue claiming, no durable local state). The worker architecture must separately demonstrate repeated jobs, concurrency behavior, durable persistence, and quota compliance before being adopted.

## Service responsibilities
- Frontend hosting: static/SSR web interface; no long-running benchmark execution.
- API hosting: authentication-aware request processing and job submission; no long compiler jobs inside ordinary request handlers.
- Database/auth provider: durable records and accounts.
- Worker host: isolated Linux environment with toolchains and runtime.
- Artifact storage: durable storage with explicit access control; do not rely on worker-local files.

## Required configuration
- Separate development and production environment variables.
- Keep privileged credentials server-side.
- Document rotation and recovery.
- Restrict CORS to expected origins.
- Apply request, job, and artifact-size limits.
- Use health checks and structured, redacted logs.

## Deployment sequence
1. Verify current free-tier terms and limits.
2. Prove compiler/runtime feasibility in the worker.
3. Provision database/auth and validate access rules.
4. Deploy API and test job persistence.
5. Deploy worker and test restart recovery.
6. Deploy frontend and configure API origin.
7. Run the end-to-end friend-account test.
8. Document known limitations and shutdown/recovery steps.

## Go/no-go
Do not describe the product as supporting real experiments until the deployed worker has completed a genuine run and the resulting raw observations have been persisted and independently checked.
