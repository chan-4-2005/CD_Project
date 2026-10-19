#!/usr/bin/env bash
set -euo pipefail
SRC='/mnt/d/CD_Project/RISC-V_Compiler_Research_Workbench_Blueprint_Docs/riscv_compiler_workbench_blueprint/benchmarks/poc-matmul'
TMP=/tmp/riscv-poc-src
mkdir -p "$TMP"
tr -d '\r' < "$SRC/matmul.c"   > "$TMP/matmul.c"
tr -d '\r' < "$SRC/run_poc.sh" > "$TMP/run_poc.sh"
bash "$TMP/run_poc.sh"
