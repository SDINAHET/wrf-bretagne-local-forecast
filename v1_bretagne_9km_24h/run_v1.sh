#!/bin/bash
set -e

echo "WRF Bretagne V1 - 9 km / 24h"

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_DIR="$BASE_DIR/src"
RUN_DIR="$SRC_DIR/WRF/run"

echo "Dossier V1 : $BASE_DIR"
echo "Dossier run WRF : $RUN_DIR"

cp "$BASE_DIR/namelist.input" "$RUN_DIR/namelist.input"

cd "$RUN_DIR"

echo "Lancement real.exe..."
mpirun -np 2 ./real.exe

echo "Lancement wrf.exe..."
mpirun -np 2 ./wrf.exe

mkdir -p "$BASE_DIR/output/wrfout"
cp wrfout_d01_* "$BASE_DIR/output/wrfout/" 2>/dev/null || true

echo "Simulation terminée."
