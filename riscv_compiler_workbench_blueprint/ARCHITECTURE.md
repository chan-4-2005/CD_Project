# Architecture

## Proposed shape
Use a modular application backend plus a separate benchmark worker. Avoid microservices beyond the worker boundary.

```text
Next.js + TypeScript frontend
            |
            v
FastAPI application API
            |
            +------ Supabase PostgreSQL / Auth
            |
            v
Durable job records / claimable queue
            |
            v
Restricted Linux benchmark worker
  - approved benchmark sources
  - GCC and LLVM RISC-V toolchains
  - validated runtime/emulator
  - timing, correctness, artifact capture
```

## Components
- Frontend: Next.js, TypeScript, Tailwind CSS, restrained Motion for React and selective React Three Fiber use on the landing page.
- API: Python + FastAPI with typed schemas and server-side authorization.
- Persistence/authentication: Supabase PostgreSQL and Auth.
- Worker: isolated Linux execution environment with validated toolchains and runtime.
- Charts: Recharts or equivalent, with accessible tables as a fallback.

## Key boundaries
- Browser code never executes compiler commands.
- API requests validate a fixed set of benchmark IDs and supported configurations.
- Long-running jobs do not execute inside request handlers.
- Persist a job record before dispatching work.
- The worker reports state transitions and persists trial-level results.
- Artifacts are linked to the exact experiment, compiler build, and configuration that generated them.
- Keep privileged credentials server-side.

## Job reliability
- Use durable queued/claimable job records.
- Record worker lease/heartbeat and attempt count.
- Detect stale jobs after worker restarts.
- Retry only according to an explicit policy; avoid duplicate accepted trials.
- Use explicit terminal states: completed, failed, cancelled, timed out.
- Preserve partial results and explain why a run did not complete.

## Hosting feasibility gate
Before implementing the full app, prove that the proposed free worker can:
1. Install or access the required GCC and LLVM RISC-V toolchains.
2. Compile one approved workload with both compilers.
3. Execute it through the validated runtime/emulator.
4. check correctness and record genuine timing data.
5. persist results outside ephemeral worker storage.
6. stay within resource, duration, and usage limits.

If this fails, narrow the workload or revise the worker arrangement. Do not substitute fake data.

## Security boundaries
- No arbitrary shell input.
- No arbitrary executable uploads in the initial release.
- Strict allowlists for targets, flags, and workload IDs.
- CPU, memory, runtime, output-size, and concurrency limits.
- Temporary workspaces per job, cleaned up after completion.
- Network access from benchmark processes restricted where practical.
- Every experiment/artifact/report read checks authorization.
