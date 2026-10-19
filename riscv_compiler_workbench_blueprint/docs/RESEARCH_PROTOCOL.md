# Research Protocol

## Research question
Compare GCC and LLVM/Clang on a documented subset of RISC-V-targeted workloads under equivalent, validated conditions.

## Relationship to the reference paper
The uploaded paper compares GCC 15.1.0 and LLVM/Clang 21.1.5, discusses scalar and vector configurations, and includes matrix operations, neural-network primitives, vector computations, and memory-access patterns. It describes QEMU user-mode emulation and statistical analysis. The paper's inventory and aggregate claims contain apparent inconsistencies that must be documented rather than silently reconciled.

This project is an independent evaluation inspired by the paper. Do not claim complete replication until inventory, versions, environment, and methodology have been verified.

## Workload categories
1. Matrix operations
2. Neural-network primitives
3. Vector computations
4. Memory-access patterns

The first suite should contain 1–2 feasibility workloads, then expand toward 8–12 representative workloads if the execution path works. Broader coverage is optional.

## Experimental controls
- Use equivalent inputs and correctness criteria for GCC and LLVM variants.
- Record exact source revision/hash, compiler version, target triple, flags, runtime/emulator version, OS/environment, and timestamps.
- Record warmup and measured repetition counts.
- Separate compilation duration from execution duration.
- Retain every trial outcome, including failures and invalid/correctness-failing runs.
- Do not compare unsupported or materially different configurations as if equivalent.
- Explain whether timings are emulated or native. The initial project has no physical RISC-V hardware.

## Metrics
- Execution time, with unit and timer method.
- Throughput, with exact operation/work unit definition.
- Throughput ratio = LLVM throughput / GCC throughput.
- Execution-time speedup = GCC time / LLVM time.
- Compilation time reported separately.
- Variability and confidence intervals where supported by the data.
- Suitable statistical tests only where sample size and assumptions justify them; disclose multiple-comparison handling.

## Validity rules
- A failed correctness check invalidates the performance result for that configuration.
- Report failed, missing, timed-out, and unsupported runs explicitly.
- Never silently discard outliers; if any exclusion rule is used, record it and show sensitivity where practical.
- Do not infer vectorization, register allocation, cache behavior, or other causes from performance alone. Use compiler diagnostics, assembly, or additional evidence.
- Emulated performance is not a substitute for native hardware validation.
- Do not claim the reference paper's results were reproduced unless the method and coverage justify that statement.

## Reporting labels
Every value must be identifiable as one of:
- Paper-reported
- Directly measured
- Derived from recorded measurements
- Not available / not validated

## Paper discrepancy log
Record and discuss apparent discrepancies in benchmark counts and aggregate performance claims found in the source paper. Do not silently choose a preferred count or reinterpret unexplained ratios.
