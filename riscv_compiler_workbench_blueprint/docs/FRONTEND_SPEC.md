# Frontend Specification

## Visual direction
Premium, dark research-workbench aesthetic with strong typography, disciplined spacing, subtle depth, and limited accent colors. Use cinematic 3D selectively on the landing page; keep experiment and analysis screens data-first. Support keyboard navigation, reduced motion, responsive layouts, and readable contrast.

## Areas
1. Landing page: research purpose, architecture overview, clear sign-in/workbench entry, selective 3D animation.
2. Experiment Studio: benchmark selection, compiler/target/approved flags, repetition settings, preflight status, resource estimate, submission.
3. Live monitor: actual queue/running state, trial progress only when measured, logs/errors, cancellation where supported.
4. Performance Lab: time/throughput, ratio/speedup, per-benchmark and category filters, variability and confidence intervals when justified.
5. Compiler Inspector: versions, flags, commands, diagnostics, assembly/disassembly when available.
6. Reproducibility & History: run history, compare, rerun configuration, raw-data exports, manifest, HTML/PDF report where feasible, share/revoke controls.

## Truthful UI rules
- Never hardcode sample metrics into live-results views.
- Empty state must explain how to run the first experiment.
- Show “not available” instead of inventing missing assembly or unsupported capability.
- Show actual job state and timestamp from the backend.
- Disclose emulation and methodology limitations near relevant charts/reports.
- Label paper-reported, measured, and derived values differently.
- Charts must show units, comparison definition, sample count, and aggregation method.
- Use accessible tables for precise values and chart alternatives.

## Performance
Avoid expensive 3D on analysis screens. Prefer polling initially; add server-sent events only if time and hosting allow. Keep the app usable on an 8 GB RAM Windows laptop and smaller displays.
