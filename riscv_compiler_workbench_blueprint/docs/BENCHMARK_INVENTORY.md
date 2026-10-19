# Benchmark Inventory

## Status
One feasibility benchmark validated locally on 2026-10-17 (see `docs/PHASE1_FEASIBILITY_REPORT.md`). Hosted validation is **HOSTED EXECUTION PENDING**: the prepared workflow `.github/workflows/riscv-poc-hosted-validation.yml` has not been executed, and no hosted run ID, URL, logs, or artifacts exist (record: `docs/PHASE1_5_HOSTED_VALIDATION_REPORT.md`). All poc-matmul runtime data is QEMU user-mode emulation, not native RISC-V hardware measurement. All other entries remain unvalidated until their source, build, execution, and correctness paths have been tested in the target hosted worker.

## Initial inventory table
| ID | Category | Source/revision | Input profile | GCC supported | LLVM supported | Runtime validated | Correctness method | Status |
|---|---|---|---|---|---|---|---|---|
| poc-matmul | Matrix operations | `benchmarks/poc-matmul/matmul.c` (in-repo, fixed-seed LCG, integer 64x64 matmul x300) | Fixed seed, no external input | Yes (riscv64-linux-gnu-gcc 13.3.0, rv64gc + rv64gcv, static) | Yes (clang 18.1.3, rv64gc + rv64gcv, static) | Locally yes — emulation only (qemu-riscv64 8.2.2 user-mode, WSL Ubuntu-24.04; not native RISC-V hardware); hosted worker HOSTED EXECUTION PENDING | FNV-1a 64-bit checksum == native x86_64 reference checksum (0x326165c972aaa79d) | Validated locally 2026-10-17 (PASS, emulated); Clang RVV timing anomaly undiagnosed; hosted-worker validation HOSTED EXECUTION PENDING |
| pending-001 | Matrix operations | TBD | TBD | TBD | TBD | TBD | TBD | Not validated |
| pending-002 | Neural-network primitives | TBD | TBD | TBD | TBD | TBD | TBD | Not validated |

Add entries for vector computations and memory-access patterns as feasible. Do not populate this inventory with imagined benchmarks or claim that entries have passed before testing.

## Required fields for each benchmark
- Stable benchmark ID and human-readable name
- Category
- Source URL or repository, license, commit/revision, and source hash
- Input generation and fixed seed where applicable
- Build instructions and required libraries
- GCC and LLVM target/flag compatibility
- Runtime/emulator requirements
- Expected output and correctness test
- Operation count or throughput unit definition
- Known limitations and resource requirements
- Validation date and test evidence

## Scope progression
1. Feasibility: 1–2 workloads, both compilers, correctness and genuine measurements.
2. Representative suite: approximately 8–12 workloads across as many categories as feasible.
3. Optional expansion: approximately 12–20 if time and worker quotas permit.
4. Full paper coverage is not a three-day release requirement.
