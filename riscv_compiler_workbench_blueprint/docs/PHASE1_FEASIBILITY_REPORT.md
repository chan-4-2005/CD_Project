# Phase 1 Feasibility Report — RISC-V Benchmark Execution Environment

Date: 2026-10-17. All findings below were directly measured on the development machine on this date. Nothing here is inferred, projected, or paper-reported.

## 1. Development environment (verified)

| Item | Verified value |
|---|---|
| Host OS | Windows 11 Home Single Language, build 26300, x64 |
| Shell | PowerShell (Windows PowerShell), not cmd.exe |
| MSYS2 | C:\msys64; native GCC 13.2.0 (x86_64) at ucrt64\bin\gcc.exe |
| MSYS2 RISC-V toolchain | Available via pacman (12.2.0, bare-metal/newlib) but NOT installed |
| WSL2 | Ubuntu 24.04.3 LTS, 8 vCPUs, ~3.7 GiB RAM, ~952 GB free disk |
| WSL GCC (native) | gcc 13.3.0 (Ubuntu 13.3.0-6ubuntu2~24.04.1) |
| WSL cross GCC | riscv64-linux-gnu-gcc 13.3.0 (installed via apt during this session) |
| WSL Clang | Ubuntu clang 18.1.3 (installed via apt during this session) |
| WSL QEMU | qemu-riscv64 8.2.2 user-mode (installed via apt during this session) |
| Physical RISC-V hardware | None |

## 2. Minimal benchmark: poc-matmul

Location: `benchmarks/poc-matmul/matmul.c` (in-repo, written for this project).

- Workload: 64×64 unsigned-integer matrix multiply-accumulate, 300 iterations.
- Determinism: fixed-seed 64-bit LCG fills inputs; integer-only arithmetic.
- Correctness: FNV-1a 64-bit checksum over final C matrix, printed as hex.
- Timing: CLOCK_MONOTONIC around the compute loop only.
- License: project-authored; no external dependency.
- Reference checksum (all valid builds): `0x326165c972aaa79d`.

## 3. Compilation results (all PASS)

| Compiler | Target | Flags | Result |
|---|---|---|---|
| riscv64-linux-gnu-gcc 13.3.0 | rv64gc | -march=rv64gc -mabi=lp64d -O2 -static | ELF 64-bit RISC-V, static |
| clang 18.1.3 | rv64gc | -target riscv64-linux-gnu -march=rv64gc -O2 -static | ELF 64-bit RISC-V, static |
| riscv64-linux-gnu-gcc 13.3.0 | rv64gcv | -march=rv64gcv -mabi=lp64d -O2 -static | Build OK |
| clang 18.1.3 | rv64gcv | -target riscv64-linux-gnu -march=rv64gcv -O2 -static | Build OK |

## 4. Execution results (qemu-riscv64 8.2.2, user-mode)

| Binary | CHECKSUM | Correct? |
|---|---|---|
| Native x86_64 reference (gcc -O2 -static) | 0x326165c972aaa79d | Reference |
| GCC rv64gc under qemu | 0x326165c972aaa79d | PASS |
| Clang rv64gc under qemu | 0x326165c972aaa79d | PASS |
| GCC rv64gcv under qemu (-cpu rv64,v=true,vlen=128) | 0x326165c972aaa79d | PASS |
| Clang rv64gcv under qemu (-cpu rv64,v=true,vlen=128) | 0x326165c972aaa79d | PASS |

## 5. Timing observations (measured, emulated — NOT native)

ELAPSED_NS across 3 repeats (rv64gc):

| Run | Native x86_64 ref | GCC rv64gc (qemu) | Clang rv64gc (qemu) |
|---|---|---|---|
| 1 | 16,758,304 | 125,127,305 | 147,446,126 |
| 2 | 16,081,664 | 121,928,197 | 112,377,585 |
| 3 | 16,145,993 | 126,395,621 | 113,021,201 |

RVV single-run observation: GCC rv64gcv ~116.8 ms; Clang rv64gcv ~2453 ms (anomalous, undiagnosed). The Clang RVV anomaly requires investigation before any RVV performance claim is made.

Note: QEMU TCG (Tiny Code Generator) timing variability is expected and does not represent native hardware performance.

## 6. Locally verified capabilities vs. hosted-worker validation needed

| Capability | Locally verified | Hosted worker |
|---|---|---|
| Cross-compile with GCC for rv64gc/rv64gcv | PASS | PENDING |
| Cross-compile with Clang for rv64gc/rv64gcv | PASS | PENDING |
| Execute via qemu-riscv64 user-mode (emulation) | PASS | PENDING |
| Correctness checksum verification | PASS | PENDING |
| CLOCK_MONOTONIC timing capture | PASS | PENDING |
| Durable result persistence across restarts | N/A (local) | PENDING |
| Resource/quota limits under free tier | N/A (local) | PENDING |
| RVV execution correctness (emulated) | PASS | PENDING |
| RVV performance measurement validity (emulated) | UNKNOWN — Clang timing anomaly undiagnosed (§5, §7) | PENDING — RVV excluded from hosted workflow until the anomaly is diagnosed |

Labels: PASS = measured and confirmed; PENDING = not yet tested in the hosted environment; UNKNOWN = cannot be determined from current evidence.

## 7. Blockers and free-tier hosting risks

1. **No hosted worker validated.** Local WSL success does not guarantee a free-tier container/VM can install packages, run QEMU, or persist results.
2. **QEMU/TCG CPU throttling** on shared free-tier instances may make timings unreliable or jobs exceed time limits.
3. **Ephemeral filesystems** (e.g., Fly.io, Railway free tier) lose data on restart; results must be pushed to external DB/storage per trial.
4. **Sleep/idle policies** may kill long-running compilation or emulation jobs.
5. **Package install permissions**: some free tiers disallow apt-get or restrict to read-only root FS.
6. **Clang RVV timing anomaly** (~2.4 s vs ~0.12 s) must be diagnosed before RVV benchmarks are included.
7. **No paid services** may be introduced; if no free tier supports the workload, scope must narrow.

## 8. Go/No-Go recommendation

**GO (conditional).** The local toolchain, compilation, execution, and correctness paths are fully validated. The smallest proof-of-concept works end-to-end on this machine. The next mandatory gate is repeating the identical sequence inside a candidate free-tier hosted Linux worker (e.g., GitHub Actions free runner, Oracle Cloud Free Tier, or Fly.io free allowance) and confirming:
- Package installation succeeds.
- Both compilers produce valid RISC-V binaries.
- QEMU executes them correctly.
- Results persist outside the ephemeral worker.
- Resource limits are sufficient for the benchmark suite.

Until that hosted-worker validation passes, do NOT proceed to application implementation.

## 9. Exact commands for next validation step

```bash
# Inside the candidate hosted worker (Ubuntu 24.04 or equivalent):
sudo apt-get update -qq
sudo apt-get install -y gcc-riscv64-linux-gnu clang qemu-user

# Compile:
riscv64-linux-gnu-gcc -march=rv64gc -mabi=lp64d -O2 -static -o m_gcc matmul.c
clang -target riscv64-linux-gnu --gcc-toolchain=/usr \
      --sysroot=/usr/riscv64-linux-gnu -march=rv64gc -O2 -static -o m_clang matmul.c
gcc -O2 -static -o m_ref matmul.c

# Execute and verify:
./m_ref | head -1          # expect CHECKSUM=0x326165c972aaa79d
qemu-riscv64 ./m_gcc | head -1
qemu-riscv64 ./m_clang | head -1
# All three must print the identical checksum.

# Record: compiler versions, qemu version, wall time, resource limits,
# and whether results survive a worker restart.
```

## 10. Files created/modified in this phase

- `benchmarks/poc-matmul/matmul.c` — minimal deterministic benchmark (NEW)
- `benchmarks/poc-matmul/run_poc.sh` — full PoC script (NEW)
- `benchmarks/poc-matmul/launch_poc.sh` — WSL launcher (NEW)
- `docs/PHASE1_FEASIBILITY_REPORT.md` — this report (NEW)
- `docs/BENCHMARK_INVENTORY.md` — updated with poc-matmul entry (MODIFIED)
- `docs/DEPLOYMENT.md` — added Phase 1 local feasibility section (MODIFIED)
- `memory-bank/progress.md` — updated with verified findings (MODIFIED)

Phase 1.5 additions:
- `.github/workflows/riscv-poc-hosted-validation.yml` — hosted validation workflow (NEW, unexecuted)
- `docs/PHASE1_5_HOSTED_VALIDATION_REPORT.md` — dedicated Phase 1.5 hosted-validation record (NEW)

## 11. Phase 1.5 hosted worker validation — status: HOSTED EXECUTION PENDING (2026-10-17)

GitHub Actions standard GitHub-hosted runners were evaluated as the free-tier hosted validation environment. The minimal validation workflow was created but has NOT been executed. As of 2026-10-17 no hosted run exists: there is no run ID, no run URL, and no hosted logs or artifacts anywhere in the workspace, so no hosted versions, commands, checksums, timings, or failures can be recorded. Hosted validation is therefore **HOSTED EXECUTION PENDING** — not PASS, not FAIL. The dedicated record and evidence checklist for the real run are in `docs/PHASE1_5_HOSTED_VALIDATION_REPORT.md`. The local PoC results and commands in §§1–9 above are unchanged and are emulation results (QEMU TCG), not native RISC-V hardware measurements.

### Verified facts (official documentation consulted 2026-10-17)
- Runner images — source: actions/runner-images README (https://raw.githubusercontent.com/actions/runner-images/main/README.md). The Ubuntu 24.04 x64 image YAML labels are `ubuntu-latest` or `ubuntu-24.04`, i.e. ubuntu-latest currently maps to Ubuntu 24.04 — the same Ubuntu release validated locally in WSL. (A newer Ubuntu 26.04 image also exists; the workflow deliberately pins `ubuntu-24.04`.)
- Billing — source: GitHub Docs, "About billing for GitHub Actions" (https://docs.github.com/en/billing/managing-billing-for-your-products/managing-billing-for-github-actions/about-billing-for-github-actions). Verbatim: "GitHub Actions usage is free for self-hosted runners and for public repositories that use standard GitHub-hosted runners." **Private** repositories consume a plan-based monthly free quota of minutes, artifact storage, and cache storage; verbatim: "Any usage beyond the included amounts is billed to your account." With no payment method on file, verbatim: "usage is blocked once you use up your quota." Published overage reference rates: Linux 2-core (x64) $0.006 per minute; shared artifact storage $0.25 per GB/month; Actions cache $0.07 per GB/month.
- Exact GitHub Free monthly included minute/storage amounts could not be confirmed from the fetched page (tables truncated or linked out) — labelled **UNKNOWN**; the owner must verify them in GitHub billing settings before choosing repository visibility. Do not guess.

### Local machine findings (verified 2026-10-17)
- The blueprint directory is not a git repository; no remote exists.
- The `gh` CLI is not installed/authenticated.
- Conclusion: a hosted run cannot be triggered from this environment.

### Artifact prepared
- `.github/workflows/riscv-poc-hosted-validation.yml` — manual-trigger (workflow_dispatch) workflow on `ubuntu-24.04`, 20-minute timeout cap, no secrets. It installs only `gcc-riscv64-linux-gnu clang qemu-user file`, records OS/tool versions, runs the existing `benchmarks/poc-matmul/run_poc.sh` unchanged (rv64gc scalar only, GCC + Clang, identical flags to §9; no RVV), independently asserts the documented checksum `0x326165c972aaa79d` on all three outputs, collects raw outputs/timings/environment metadata, uploads them as the `riscv-poc-hosted-results` artifact (30-day retention), and fails on any compile/execution/checksum error.

### Owner actions required to convert PENDING to PASS/FAIL
1. Decide visibility. Public repo → Actions minutes free. Private → consumes plan quota; verify current free allowance first and do not add a payment method.
2. Create a new empty GitHub repository (no paid features).
3. Push the blueprint directory as the repository root:
   ```
   cd riscv_compiler_workbench_blueprint
   git init -b main
   git add .
   git commit -m "Phase 1 blueprint + PoC benchmark + Phase 1.5 validation workflow"
   git remote add origin <your-repo-url>
   git push -u origin main
   ```
4. GitHub UI → Actions → "riscv-poc-hosted-validation" → "Run workflow" on main.
5. Provide the completed run log and the `riscv-poc-hosted-results` artifact for review.

### HOSTED EXECUTION PASS criteria
- Workflow exits 0; all three logged checksums equal `0x326165c972aaa79d`; versions and ELAPSED_NS timings present in the artifact.

### CI runner vs persistent worker (evidence-based caution)
A GitHub-hosted runner is ephemeral and event-triggered. Even a successful run validates the toolchain/execution path only; it does NOT demonstrate a continuously available worker service (no job-queue claiming, no durable local state). If GitHub Actions becomes the worker model, results must be pushed to external storage per trial and the job model adapted (scheduled polling or API-triggered dispatch). Untested: repeated jobs, concurrency, long-term quotas, persistence across runs.

### Dedicated record
`docs/PHASE1_5_HOSTED_VALIDATION_REPORT.md` holds the consolidated Phase 1.5 status, the free-tier constraint citations, and the fill-in evidence checklist to complete from the real run's log and artifact once it exists.
