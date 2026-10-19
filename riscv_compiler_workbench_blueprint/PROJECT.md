# RISC-V Compiler Research Workbench

## Purpose
A hosted research application for running controlled GCC-versus-LLVM experiments on supported RISC-V workloads, inspecting compiler output, comparing measurements, and sharing reproducible reports.

## Product goals
- Premium, responsive research interface with six areas: landing page, Experiment Studio, Performance Lab, Compiler Inspector, Reproducibility & Reports, and Experiment History.
- Real benchmark execution through a restricted hosted Linux worker.
- Friend accounts with private-by-default experiments and explicitly shared completed reports.
- Traceable measurements and reproducible configuration metadata.
- Free-tier hosting only, accepting sleep, quotas, and slower jobs.

## Non-negotiable rules
1. Never fabricate measurements, benchmark progress, compiler capabilities, or successful runs.
2. Distinguish paper-reported values, measured values, and derived statistics.
3. Do not claim full replication until the source methodology and benchmark inventory have been reconciled and validated.
4. Do not claim emulated performance is equivalent to native RISC-V hardware performance.
5. Do not accept arbitrary shell commands, arbitrary source uploads, or unrestricted compiler flags.
6. Enforce ownership, quotas, and visibility in the backend, not only in the frontend.
7. Do not begin implementation until the owner explicitly authorizes it.

## Constraints
- Schedule target: 2–3 days for an aggressive MVP.
- Hosting budget: free tiers only.
- Development machine: Windows laptop, basic Core i5, 8 GB RAM.
- No physical RISC-V hardware.
- Full paper coverage is not guaranteed within the schedule.

## Initial release definition
A user can sign in, submit a permitted experiment, see real job status, inspect genuine GCC/LLVM results for the supported subset, review raw trials and metadata, export results, and explicitly share a completed report.

## Deferred unless time allows
- Full paper benchmark inventory and exact paper-wide replication.
- Native hardware validation.
- Large-scale concurrency.
- Advanced live streaming; polling is acceptable initially.
- PDF export if HTML, CSV, and JSON are already reliable.
