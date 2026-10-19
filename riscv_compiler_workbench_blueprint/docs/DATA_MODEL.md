# Data Model

## Entities
### User
Authentication identity and account-level settings. Managed through the auth provider.

### Benchmark
Stable ID, name, category, source revision/hash, input definition, correctness method, operation-count definition, validation status.

### Experiment
Owner ID, selected benchmark/configuration, creation timestamp, visibility, descriptive metadata.

### Job
Experiment ID, queue state, owner, timestamps, attempt count, worker lease/heartbeat, timeout, cancellation request, failure category and detail.

### CompilerBuild
Compiler name/version, target triple, supported features, executable/toolchain identity, runtime and environment details.

### Trial
Job/benchmark/compiler/configuration reference, trial index, warmup/measured classification, raw timing values, correctness result, exit status, error metadata, timestamps.

### Artifact
Experiment/job/trial reference, type, storage key, content hash, size, media type, creation timestamp, access policy.

### Analysis
Metric definitions, aggregation method, included/excluded observations, statistical tests, confidence intervals, warnings, analysis version.

### Report
Experiment reference, report snapshot/version, included artifacts, visibility, share-token hash, creation/revocation timestamps.

## Integrity rules
- Store raw observations independently from derived summaries.
- Store units and definitions with every metric.
- Link each result to the exact benchmark revision and compiler configuration.
- Never store only the aggregate if trial-level observations are available.
- Keep private objects inaccessible by default.
- Share links expose only the intended report and explicitly included artifacts.
- Avoid persisting secrets in environment metadata or logs.
