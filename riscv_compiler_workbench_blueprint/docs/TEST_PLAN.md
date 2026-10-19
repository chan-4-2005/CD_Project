# Test Plan

## 1. Toolchain feasibility
- Verify GCC and LLVM versions and RISC-V target support.
- Compile a minimal workload with both compilers.
- Execute through the proposed runtime/emulator.
- Validate expected output and capture genuine timing values.
- Confirm generated artifacts and results survive worker restart.
- Record resource use and execution limits.

## 2. Unit tests
- Request/configuration validation and allowlists.
- Metric formulas and unit conversions.
- Job-state transition rules.
- Quota calculations.
- Share-token creation/revocation behavior.
- Serialization/export formatting.

## 3. Integration tests
- Authenticated experiment creation.
- Job queue and worker claim/lease.
- Successful run and persistence.
- Compile failure, correctness failure, timeout, cancellation, and worker interruption.
- Retry without duplicate accepted trial data.
- Artifact retrieval with authorization.
- CSV/JSON export round-trip checks.

## 4. Security tests
- User A cannot read User B's private experiments or artifacts.
- Share links expose only intended completed reports.
- Revoked share links stop working.
- Unknown benchmark IDs and arbitrary commands are rejected.
- Unapproved flags/configurations are rejected.
- Quotas cannot be bypassed by direct API calls.
- Secrets are absent from browser bundles and public logs.

## 5. Scientific validity tests
- GCC and LLVM use equivalent inputs and declared comparable settings.
- Correctness failures invalidate the corresponding performance result.
- Raw observations reproduce displayed summaries within defined rounding.
- Throughput ratio and time-speedup formulas are tested.
- Charts identify sample count, units, and aggregation.
- Missing/failed trials are visible and handled according to protocol.
- Emulation is labelled accurately.

## 6. End-to-end release test
Using a separate friend account: register, sign in, submit a supported job, observe genuine progress/status, inspect results and artifacts, export data, share a completed report, and revoke the share link.
