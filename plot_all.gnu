set datafile separator ","

set terminal pngcairo size 1600,1000 enhanced font "Arial,18"

set border linewidth 1.5
set grid
set key box
set pointsize 1.5

# ==================================================
# PDR
# ==================================================

set output "results/graphs/pdr_comparison.png"

set title "SPIN-BC vs SPIN-RL Packet Delivery Ratio"
set xlabel "Number of Nodes"
set ylabel "PDR (%)"

plot \
"results/comparison.csv" using 1:2 with linespoints lw 3 pt 7 title "SPIN-BC", \
"results/comparison.csv" using 1:3 with linespoints lw 3 pt 5 title "SPIN-RL"

# ==================================================
# Throughput
# ==================================================

set output "results/graphs/throughput_comparison.png"

set title "SPIN-BC vs SPIN-RL Throughput"
set xlabel "Number of Nodes"
set ylabel "Throughput (kbps)"

plot \
"results/comparison.csv" using 1:4 with linespoints lw 3 pt 7 title "SPIN-BC", \
"results/comparison.csv" using 1:5 with linespoints lw 3 pt 5 title "SPIN-RL"

# ==================================================
# Delay
# ==================================================

set output "results/graphs/delay_comparison.png"

set title "SPIN-BC vs SPIN-RL End-to-End Delay"
set xlabel "Number of Nodes"
set ylabel "Delay (seconds)"

plot \
"results/comparison.csv" using 1:6 with linespoints lw 3 pt 7 title "SPIN-BC", \
"results/comparison.csv" using 1:7 with linespoints lw 3 pt 5 title "SPIN-RL"

# ==================================================
# Control Overhead
# ==================================================

# ==================================================
# Control Overhead
# ==================================================

reset

set terminal pngcairo size 1600,1000 enhanced font "Arial,18"

set output "results/graphs/control_overhead.png"

set title "Control Overhead Comparison"

set style data histograms
set style fill solid
set boxwidth 0.8

set xlabel "Protocol"
set ylabel "Control/Data Ratio"

set yrange [0:*]

plot "results/plotdata/control_overhead.dat" using 2:xticlabels(1) \
with histograms title "Control Overhead"
