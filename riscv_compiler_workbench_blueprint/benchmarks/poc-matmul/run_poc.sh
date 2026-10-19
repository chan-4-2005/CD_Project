#!/usr/bin/env bash
# Phase 1 feasibility proof of concept for the RISC-V Compiler Research Workbench.
# Run inside WSL Ubuntu-24.04:  bash run_poc.sh
# Compiles poc-matmul with GCC and Clang for rv64gc (static), runs both under
# qemu-riscv64 user-mode, compares checksums against the native x86_64
# reference build, and reports compile + execution timing.
set -euo pipefail

SRC_DIR="$(cd "$(dirname "$0")" && pwd)"
WORK=/tmp/riscv-poc
mkdir -p "$WORK"
cp "$SRC_DIR/matmul.c" "$WORK/"
cd "$WORK"

echo "===== Toolchain versions ====="
riscv64-linux-gnu-gcc --version | head -1
clang --version | head -1
qemu-riscv64 --version | head -1
gcc --version | head -1
echo

echo "===== Build: native x86_64 reference (GCC) ====="
{ time gcc -O2 -static -o matmul_ref matmul.c ; } 2>&1
echo "===== Build: RISC-V rv64gc (riscv64-linux-gnu-gcc) ====="
{ time riscv64-linux-gnu-gcc -march=rv64gc -mabi=lp64d -O2 -static \
      -o matmul_gcc_rv64gc matmul.c ; } 2>&1
echo "===== Build: RISC-V rv64gc (Clang) ====="
{ time clang -target riscv64-linux-gnu --gcc-toolchain=/usr \
      --sysroot=/usr/riscv64-linux-gnu -march=rv64gc -O2 -static \
      -o matmul_clang_rv64gc matmul.c ; } 2>&1
echo

echo "===== File types ====="
file matmul_ref matmul_gcc_rv64gc matmul_clang_rv64gc
echo

echo "===== Run: native x86_64 reference ====="
./matmul_ref | tee ref_out.txt
echo "===== Run: GCC rv64gc under qemu-riscv64 ====="
{ time qemu-riscv64 ./matmul_gcc_rv64gc ; } 2>&1 | tee gcc_run.log
grep -v -E '^(real|user|sys)' gcc_run.log > gcc_out.txt || true
cat gcc_out.txt
echo "===== Run: Clang rv64gc under qemu-riscv64 ====="
{ time qemu-riscv64 ./matmul_clang_rv64gc ; } 2>&1 | tee clang_run.log
grep -v -E '^(real|user|sys)' clang_run.log > clang_out.txt || true
cat clang_out.txt
echo

echo "===== Correctness check ====="
get_ck() { sed -n 's/^CHECKSUM=//p' "$1" | head -1; }
ref_ck=$(get_ck ref_out.txt)
gcc_ck=$(get_ck gcc_out.txt)
clang_ck=$(get_ck clang_out.txt)
echo "reference (x86_64) : $ref_ck"
echo "riscv gcc          : $gcc_ck"
echo "riscv clang        : $clang_ck"
if [[ -n "$ref_ck" && "$gcc_ck" == "$ref_ck" && "$clang_ck" == "$ref_ck" ]]; then
    echo "RESULT: PASS - all checksums match"
else
    echo "RESULT: FAIL - checksum mismatch or missing output"
    exit 1
fi
