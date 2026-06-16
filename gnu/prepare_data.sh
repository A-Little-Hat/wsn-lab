#!/bin/bash

ROOT=$(dirname "$(dirname "$(realpath "$0")")")

TRACE_DIR="$ROOT/trace"
AWK_SCRIPT="$ROOT/awk/metrics.awk"
DATA_DIR="$ROOT/gnu/data"

mkdir -p "$DATA_DIR"

echo "#Nodes PDR Throughput Delay" > "$DATA_DIR/leach.dat"
echo "#Nodes PDR Throughput Delay" > "$DATA_DIR/rumor.dat"

for f in "$TRACE_DIR"/leach_*.tr
do
    [ -f "$f" ] || continue

    nodes=$(basename "$f" .tr | sed 's/leach_//')

    metrics=$(awk -f "$AWK_SCRIPT" "$f")

    echo "$nodes $metrics" >> "$DATA_DIR/leach.dat"
done

for f in "$TRACE_DIR"/rumor_*.tr
do
    [ -f "$f" ] || continue

    nodes=$(basename "$f" .tr | sed 's/rumor_//')

    metrics=$(awk -f "$AWK_SCRIPT" "$f")

    echo "$nodes $metrics" >> "$DATA_DIR/rumor.dat"
done

sort -n "$DATA_DIR/leach.dat" -o "$DATA_DIR/leach.dat"
sort -n "$DATA_DIR/rumor.dat" -o "$DATA_DIR/rumor.dat"

echo "Data prepared successfully."
