# Phase 1.5 Hosted Validation Report — GitHub Actions (poc-matmul)

Date prepared: 2026-10-17. **Status: HOSTED EXECUTION PENDING.**

This is the dedicated record for Phase 1.5 hosted validation. The local proof-of-concept results and exact commands are unchanged and remain in `docs/PHASE1_FEASIBILITY_REPORT.md` §§1–9; nothing there is restated here as hosted evidence. Reminder: all QEMU results in this project are **emulation results (QEMU TCG user-mode), not native RISC-V hardware measurements**.

## 1. Hosted execution status (verified 2026-10-17)

No hosted run has occurred. Verified on the development machine:
- The blueprint directory is not a git repository (`git status` → "fatal: not a git repository"); no remote exists.
- The `gh` CLI is not installed/authenticated.
- A recursive scan of the workspace found no hosted run logs, artifacts, run IDs, or run URLs.

Therefore there is NO hosted run ID, run URL, hosted tool versions, hosted commands output, hosted checksums, hosted timings, hosted artifacts, or hosted failures to record. Per project rules, none are invented. The §5 checklist stays empty until a real run exists.

## 2. Prepared validation artifact (unexecuted)

`.github/workflows/riscv-poc-hosted-validation.yml` — manual trigger (`workflow_dispatch`) only:
- `runs-on: ubuntu-24.04` (x64), `timeout-minutes: 20`, no secrets.
- Installs only `gcc-riscv64-linux-gnu clang qemu-user file` via apt; records OS and tool versions.
- Runs the existing `benchmarks/poc-matmul/run_poc.sh` **unchanged** — rv64gc scalar only, GCC + Clang, flags identical to `docs/PHASE1_FEASIBILITY_REPORT.md` §9; RVV deliberately excluded.
- Independently asserts checksum `0x326165c972aaa79d` on the native reference, GCC, and Clang outputs; fails on any compile, execution, or checksum error.
- Uploads raw outputs, logs, and environment metadata as the `riscv-poc-hosted-results` artifact (30-day retention).

No benchmark code was modified for this workflow; no verified blocking defect was found in the PoC.

## 3. Findings status (PASS / FAIL / PENDING / UNKNOWN)

| Finding | Status | Evidence |
|---|---|---|
| Local PoC compile/run/correctness (QEMU emulation) | PASS | `docs/PHASE1_FEASIBILITY_REPORT.md` §§3–4 |
| Local RVV execution correctness (QEMU emulation) | PASS | report §4 |
| Clang RVV timing anomaly diagnosed | UNKNOWN (open issue) | ~2453 ms vs ~116.8 ms GCC; undiagnosed (report §§5, 7) |
| Hosted workflow file prepared | PASS | `.github/workflows/riscv-poc-hosted-validation.yml` exists, reviewed 2026-10-17 |
| Hosted run executed | PENDING | no run occurred (§1 above) |
| Hosted checksum assertion | PENDING | — |
| Hosted timings captured | PENDING | — |
| Hosted environment versions recorded | PENDING | — |
| Persistent-worker suitability (queue claiming, repeated/concurrent jobs, persistence, quotas) | UNKNOWN | not tested; a single CI run would not prove it (§7) |
| Exact GitHub Free private-repo minute/storage allowance | UNKNOWN | not confirmable from consulted pages; owner must verify |


## 4. Free-tier constraints (official documentation consulted 2026-10-17)

Sources actually fetched on 2026-10-17:

- GitHub Docs — "About billing for GitHub Actions" (https://docs.github.com/en/billing/managing-billing-for-your-products/managing-billing-for-github-actions/about-billing-for-github-actions):
  - Verbatim: "GitHub Actions usage is free for self-hosted runners and for public repositories that use standard GitHub-hosted runners."
  - Private repositories receive a plan-based quota of free minutes, artifact storage, and cache storage; verbatim: "Any usage beyond the included amounts is billed to your account."
  - Verbatim: "If your account does not have a valid payment method on file, usage is blocked once you use up your quota."
  - Published overage reference rates: Linux 2-core (x64) $0.006 per minute; shared artifact storage $0.25 per GB/month; Actions cache $0.07 per GB/month.
  - The exact Free-plan monthly included minutes and storage amounts could not be confirmed from the fetched page (tables truncated or linked out) → **UNKNOWN**. The owner must check the current numbers in GitHub billing settings before choosing repository visibility. Do not guess.
- actions/runner-images README (https://raw.githubusercontent.com/actions/runner-images/main/README.md):
  - The Ubuntu 24.04 x64 image YAML labels are `ubuntu-latest` or `ubuntu-24.04`, i.e. `ubuntu-latest` currently maps to Ubuntu 24.04 — the same release validated locally in WSL — and the workflow's pinned `ubuntu-24.04` label is valid. (A newer Ubuntu 26.04 image also exists; pinning 24.04 is intentional.)

Known free-tier constraints relevant to this project (documented risks, not yet observed in a hosted run):
- Ephemeral runner filesystem: results must be pushed to external storage per trial; nothing persists between runs.
- Event-triggered execution: no always-on worker; a CI success would not demonstrate job-queue claiming or long-running service behavior.
- Shared tenancy: QEMU/TCG timing variability is expected; hosted timings would be emulation measurements under load, not hardware performance.

## 5. Evidence to record from the actual hosted run (empty until it happens)

Fill in ONLY from the completed run's log and `riscv-poc-hosted-results` artifact. Do not guess.

| Field | Value |
|---|---|
| Run ID | (none — no run occurred) |
| Run URL | (none) |
| Workflow conclusion | (none) |
| Trigger time (UTC) | (none) |
| Runner label / OS build | (none) |
| gcc-riscv64-linux-gnu version | (none) |
| clang version | (none) |
| qemu-riscv64 version | (none) |
| Reference checksum (x86_64) | (none hosted) |
| GCC rv64gc checksum | (none hosted) |
| Clang rv64gc checksum | (none hosted) |
| ELAPSED_NS (GCC rv64gc, qemu) | (none hosted) |
| ELAPSED_NS (Clang rv64gc, qemu) | (none hosted) |
| Artifact name / retention | (none hosted) |
| Failures encountered | (none hosted) |

## 6. Owner steps to execute the hosted run

1. Decide visibility. Public repo → Actions minutes free. Private → consumes plan quota; verify the current free allowance in billing settings first and do not add a payment method.
2. Create a new empty GitHub repository (no paid features).
3. Push the blueprint directory as the repository root (`git init -b main`, commit, `git remote add origin <url>`, push) — exact sequence in `docs/PHASE1_FEASIBILITY_REPORT.md` §11.
4. GitHub UI → Actions → "riscv-poc-hosted-validation" → "Run workflow" on `main`.
5. Provide the completed run log and the `riscv-poc-hosted-results` artifact for review; record them in §5 above.

## 7. PASS / FAIL criteria and interpretation limits

- **PASS**: workflow exits 0; all three logged checksums equal `0x326165c972aaa79d`; versions and ELAPSED_NS timings present in the artifact; §5 filled from the artifact.
- **FAIL**: any compile, execution, or checksum error, or a non-zero workflow exit.
- A PASS only validates the toolchain/execution path on an **ephemeral, event-triggered CI runner**. It does **NOT** prove suitability as a persistent production worker: no job-queue claiming, no durable local state, no evidence for repeated or concurrent jobs, no long-term quota data. If GitHub Actions becomes the worker model, results must be pushed to external storage per trial and the job model adapted (scheduled polling or API-triggered dispatch), then separately tested.

## 8. Carried-over open issues

1. Clang RVV timing anomaly (~2453 ms vs ~116.8 ms GCC, under QEMU emulation) — undiagnosed; RVV is excluded from the hosted workflow until diagnosed. No RVV performance claim may be made.
2. All current execution data is QEMU emulation, not native RISC-V hardware measurement.
3. Exact GitHub Free minute/storage allowance — UNKNOWN; owner verification required.
4. Persistent-worker suitability (repeated jobs, concurrency, persistence, quotas) — UNKNOWN until separately tested.
