set datafile separator ","

set terminal png size 1000,700

# PDR
set output "plots/pdr.png"
set title "Packet Delivery Ratio"
set xlabel "Number of Nodes"
set ylabel "PDR (%)"

plot \
"results/metrics.csv" using 2:3 every ::1::4 with linespoints title "AODV", \
"results/metrics.csv" using 2:3 every ::5::8 with linespoints title "DSDV"

# Delay
set output "plots/delay.png"
set title "Average End-to-End Delay"
set xlabel "Number of Nodes"
set ylabel "Delay (sec)"

plot \
"results/metrics.csv" using 2:4 every ::1::4 with linespoints title "AODV", \
"results/metrics.csv" using 2:4 every ::5::8 with linespoints title "DSDV"

# Throughput
set output "plots/throughput.png"
set title "Throughput"
set xlabel "Number of Nodes"
set ylabel "Throughput (bps)"

plot \
"results/metrics.csv" using 2:5 every ::1::4 with linespoints title "AODV", \
"results/metrics.csv" using 2:5 every ::5::8 with linespoints title "DSDV"
