#!/bin/bash

NODES=(10 20 30 40 50)
SPEEDS=(5 10 15 20)
PAUSES=(0 10 20 30 40)

mkdir -p results

echo "Starting academic experiment..."
echo "Total simulations: 200"

# CSV headers
echo "Model,Nodes,Speed,Pause,PDR,Throughput,Delay,Loss,Overhead" > results/all_results.csv

run_experiment() {
    MODEL=$1
    TCL=$2
    N=$3
    S=$4
    P=$5

    echo "Running $MODEL | Nodes=$N Speed=$S Pause=$P"

    ns $TCL $N $S $P

    TRACE="${MODEL}_${N}_${S}_${P}.tr"

    PDR=$(awk -f metrics/pdr.awk $TRACE)
    THR=$(awk -f metrics/throughput.awk $TRACE)
    DEL=$(awk -f metrics/delay.awk $TRACE)
    LOS=$(awk -f metrics/loss.awk $TRACE)
    OVR=$(awk -f metrics/overhead.awk $TRACE)

    echo "$MODEL,$N,$S,$P,$PDR,$THR,$DEL,$LOS,$OVR" >> results/all_results.csv

    mv $TRACE results/
    mv "${MODEL}_${N}_${S}_${P}.nam" results/
}

# RWP
for N in "${NODES[@]}"; do
    for S in "${SPEEDS[@]}"; do
        for P in "${PAUSES[@]}"; do
            run_experiment "rwp" "rwp.tcl" $N $S $P
        done
    done
done

# RW
for N in "${NODES[@]}"; do
    for S in "${SPEEDS[@]}"; do
        for P in "${PAUSES[@]}"; do
            run_experiment "rw" "rw.tcl" $N $S $P
        done
    done
done

echo "===================================="
echo "All experiments completed."
echo "Results saved in results/all_results.csv"
echo "===================================="
