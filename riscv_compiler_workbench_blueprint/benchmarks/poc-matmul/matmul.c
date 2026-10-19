/*
 * poc-matmul.c -- Minimal deterministic benchmark for the RISC-V Compiler
 * Research Workbench, Phase 1 feasibility test.
 *
 * Workload    : N x N integer matrix multiply-accumulate, ITERS iterations.
 * Determinism : fixed-seed 64-bit LCG fills inputs; integer-only arithmetic
 *               (unsigned wrap is well-defined); no FP, no I/O dependencies,
 *               no time-of-day, no pointer/address-dependent output.
 * Correctness : 64-bit FNV-1a checksum over the final C matrix, printed as
 *               hex. Must match the native x86_64 reference build exactly.
 * Timing      : CLOCK_MONOTONIC around the compute loop only.
 * License     : written for this project; free to use, modify, redistribute.
 */
#include <stdint.h>
#include <stdio.h>
#include <time.h>

#define N     64
#define ITERS 300

static uint32_t A[N * N], B[N * N], C[N * N];

static uint64_t lcg_state = 0x2545F4914F6CDD1DULL;

static uint32_t lcg_next(void)
{
    lcg_state = lcg_state * 6364136223846793005ULL + 1442695040888963407ULL;
    return (uint32_t)(lcg_state >> 32);
}

int main(void)
{
    for (int i = 0; i < N * N; i++) {
        A[i] = lcg_next() & 0xFFFFu;
        B[i] = lcg_next() & 0xFFFFu;
        C[i] = 0u;
    }

    struct timespec t0, t1;
    clock_gettime(CLOCK_MONOTONIC, &t0);

    for (int it = 0; it < ITERS; it++) {
        for (int i = 0; i < N; i++) {
            for (int k = 0; k < N; k++) {
                uint32_t a = A[i * N + k];
                const uint32_t *brow = &B[k * N];
                uint32_t *crow = &C[i * N];
                for (int j = 0; j < N; j++) {
                    crow[j] += a * brow[j]; /* unsigned wrap: defined */
                }
            }
        }
    }

    clock_gettime(CLOCK_MONOTONIC, &t1);

    /* FNV-1a 64-bit over the bytes of C (little-endian byte order) */
    uint64_t h = 1469598103934665603ULL;
    for (int i = 0; i < N * N; i++) {
        uint32_t v = C[i];
        for (int b = 0; b < 4; b++) {
            h ^= (uint64_t)(v & 0xFFu);
            h *= 1099511628211ULL;
            v >>= 8;
        }
    }

    long long ns = (long long)(t1.tv_sec - t0.tv_sec) * 1000000000LL
                 + (long long)(t1.tv_nsec - t0.tv_nsec);

    printf("CHECKSUM=0x%016llx\n", (unsigned long long)h);
    printf("ELAPSED_NS=%lld\n", ns);
    printf("STATUS=OK\n");
    return 0;
}
