# API Specification

## Conventions
- Base path: `/api/v1`
- Authenticated routes require a valid session.
- Every object read or mutated must pass server-side authorization.
- Use typed request/response schemas and a consistent error envelope.
- Backend is authoritative for capabilities, limits, job state, and visibility.

## Proposed endpoints
| Method | Path | Purpose |
|---|---|---|
| GET | `/health` | Service/dependency health |
| GET | `/environment` | Validated compiler/target/runtime capabilities |
| GET | `/benchmarks` | Approved workloads and supported configurations |
| POST | `/experiments` | Create a private experiment |
| GET | `/experiments` | List caller's experiments |
| GET | `/experiments/{id}` | Read an authorized experiment |
| POST | `/experiments/{id}/jobs` | Submit a permitted job |
| GET | `/jobs/{id}` | Get job status and progress |
| POST | `/jobs/{id}/cancel` | Request cancellation when supported |
| GET | `/experiments/{id}/artifacts` | List authorized artifacts |
| GET | `/experiments/{id}/export` | Export authorized results |
| POST | `/reports/{id}/share` | Create a share link for a completed report |
| DELETE | `/reports/{id}/share` | Revoke a share link |

## Job submission validation
Validate benchmark IDs, compiler choices, target settings, approved flags, repetitions, warmups, and estimated workload against server-defined limits. Reject unknown fields or unsupported combinations clearly.

## Suggested job states
`queued`, `claimed`, `running`, `completed`, `failed`, `cancelled`, `timed_out`.

## Error categories
- Authentication required
- Not authorized / not found
- Invalid configuration
- Unsupported target or feature
- Quota exceeded
- Worker unavailable
- Compilation failed
- Correctness check failed
- Runtime failed
- Timed out
- Cancelled
- Internal service error

Do not return secrets, raw environment secrets, or unrestricted internal paths in error responses.
