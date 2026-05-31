#!/bin/bash

mkdir -p results
mkdir -p trace

rm -f trace/*.tr
rm -f trace/*.nam

echo "Protocol,Nodes,PDR,Delay,Throughput" > results/metrics.csv

for protocol in AODV DSDV
do
    for nodes in 30 60 100 150
    do
        echo "====================================="
        echo "Running $protocol with $nodes nodes"
        echo "====================================="

        ns run_manet.tcl $protocol $nodes

        if [ ! -f trace/${protocol}_${nodes}.tr ]; then
                echo "Simulation failed: $protocol $nodes"
                exit 1
        fi

        pdr=$(awk -f awk/pdr.awk trace/${protocol}_${nodes}.tr \
              | grep "PDR" \
              | awk '{print $3}')

        delay=$(awk -f awk/delay.awk trace/${protocol}_${nodes}.tr \
                | grep "Average Delay" \
                | awk '{print $4}')

        throughput=$(awk -f awk/throughput.awk trace/${protocol}_${nodes}.tr \
                     | grep "Throughput" \
                     | awk '{print $3}')

        echo "$protocol,$nodes,$pdr,$delay,$throughput" \
            >> results/metrics.csv

    done
done

echo
echo "Results stored in:"
echo "results/metrics.csv"
