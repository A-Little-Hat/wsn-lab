#!/bin/bash

BASE="$HOME/ns2/examples/spin-project"

echo "Nodes,PDR,Throughput,Delay" \
> "$BASE/results/bc_metrics.csv"

for n in 20 40 60 80 100 120 140 160 180 200
do

    echo "Running $n"

    ns "$BASE/tcl/spin_bc.tcl" $n > /dev/null

    pdr=$(awk -f "$BASE/awk/pdr.awk" \
        "$BASE/trace/BC_${n}.tr")

    thr=$(awk -f "$BASE/awk/throughput.awk" \
        "$BASE/trace/BC_${n}.tr")

    delay=$(awk -f "$BASE/awk/delay.awk" \
        "$BASE/trace/BC_${n}.tr")

    echo "$n,$pdr,$thr,$delay" \
    >> "$BASE/results/bc_metrics.csv"

done

cat "$BASE/results/bc_metrics.csv"
