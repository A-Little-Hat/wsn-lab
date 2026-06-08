#!/bin/bash

BASE="$HOME/ns2/examples/spin-project"

mkdir -p "$BASE/results"

echo "Nodes,PDR,Throughput,Delay" > "$BASE/results/rl_metrics.csv"

for n in 20 40 60 80 100 120 140 160 180 200
do
    echo "Running SPIN-RL with $n nodes..."

    ns "$BASE/tcl/spin_rl.tcl" $n > /dev/null

    pdr=$(awk -f "$BASE/awk/pdr.awk" \
        "$BASE/trace/RL_${n}.tr")

    thr=$(awk -f "$BASE/awk/throughput.awk" \
        "$BASE/trace/RL_${n}.tr")

    delay=$(awk -f "$BASE/awk/delay.awk" \
        "$BASE/trace/RL_${n}.tr")

    echo "$n,$pdr,$thr,$delay" \
        >> "$BASE/results/rl_metrics.csv"

done

echo ""
echo "========== SPIN-RL Results =========="
cat "$BASE/results/rl_metrics.csv"
