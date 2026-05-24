set datafile separator ","
set terminal pngcairo size 1200,800 enhanced font "Arial,14"
set key top right
set grid

# ==========================
# NODE COMPARISON
# ==========================

set xlabel "Number of Nodes"

set ylabel "PDR (%)"
set title "PDR vs Number of Nodes"
set output "graphs/nodes_pdr.png"
plot "graphs/data/nodes_pdr.dat" using 1:2 with linespoints lw 3 title "Random Walk", \
     "graphs/data/nodes_pdr.dat" using 1:3 with linespoints lw 3 title "Random Waypoint"

set ylabel "Throughput (kbps)"
set title "Throughput vs Number of Nodes"
set output "graphs/nodes_throughput.png"
plot "graphs/data/nodes_throughput.dat" using 1:2 with linespoints lw 3 title "Random Walk", \
     "graphs/data/nodes_throughput.dat" using 1:3 with linespoints lw 3 title "Random Waypoint"

set ylabel "Delay (sec)"
set title "Delay vs Number of Nodes"
set output "graphs/nodes_delay.png"
plot "graphs/data/nodes_delay.dat" using 1:2 with linespoints lw 3 title "Random Walk", \
     "graphs/data/nodes_delay.dat" using 1:3 with linespoints lw 3 title "Random Waypoint"

set ylabel "Packet Loss (%)"
set title "Packet Loss vs Number of Nodes"
set output "graphs/nodes_loss.png"
plot "graphs/data/nodes_loss.dat" using 1:2 with linespoints lw 3 title "Random Walk", \
     "graphs/data/nodes_loss.dat" using 1:3 with linespoints lw 3 title "Random Waypoint"

set ylabel "Routing Overhead"
set title "Routing Overhead vs Number of Nodes"
set output "graphs/nodes_overhead.png"
plot "graphs/data/nodes_overhead.dat" using 1:2 with linespoints lw 3 title "Random Walk", \
     "graphs/data/nodes_overhead.dat" using 1:3 with linespoints lw 3 title "Random Waypoint"

# ==========================
# SPEED COMPARISON
# ==========================

set xlabel "Speed (m/s)"

set ylabel "PDR (%)"
set title "PDR vs Speed"
set output "graphs/speed_pdr.png"
plot "graphs/data/speed_pdr.dat" using 1:2 with linespoints lw 3 title "Random Walk", \
     "graphs/data/speed_pdr.dat" using 1:3 with linespoints lw 3 title "Random Waypoint"

set ylabel "Throughput (kbps)"
set title "Throughput vs Speed"
set output "graphs/speed_throughput.png"
plot "graphs/data/speed_throughput.dat" using 1:2 with linespoints lw 3 title "Random Walk", \
     "graphs/data/speed_throughput.dat" using 1:3 with linespoints lw 3 title "Random Waypoint"

set ylabel "Delay (sec)"
set title "Delay vs Speed"
set output "graphs/speed_delay.png"
plot "graphs/data/speed_delay.dat" using 1:2 with linespoints lw 3 title "Random Walk", \
     "graphs/data/speed_delay.dat" using 1:3 with linespoints lw 3 title "Random Waypoint"

set ylabel "Packet Loss (%)"
set title "Packet Loss vs Speed"
set output "graphs/speed_loss.png"
plot "graphs/data/speed_loss.dat" using 1:2 with linespoints lw 3 title "Random Walk", \
     "graphs/data/speed_loss.dat" using 1:3 with linespoints lw 3 title "Random Waypoint"

set ylabel "Routing Overhead"
set title "Routing Overhead vs Speed"
set output "graphs/speed_overhead.png"
plot "graphs/data/speed_overhead.dat" using 1:2 with linespoints lw 3 title "Random Walk", \
     "graphs/data/speed_overhead.dat" using 1:3 with linespoints lw 3 title "Random Waypoint"

# ==========================
# PAUSE COMPARISON
# ==========================

set xlabel "Pause Time (sec)"

set ylabel "PDR (%)"
set title "PDR vs Pause Time"
set output "graphs/pause_pdr.png"
plot "graphs/data/pause_pdr.dat" using 1:2 with linespoints lw 3 title "Random Walk", \
     "graphs/data/pause_pdr.dat" using 1:3 with linespoints lw 3 title "Random Waypoint"

set ylabel "Throughput (kbps)"
set title "Throughput vs Pause Time"
set output "graphs/pause_throughput.png"
plot "graphs/data/pause_throughput.dat" using 1:2 with linespoints lw 3 title "Random Walk", \
     "graphs/data/pause_throughput.dat" using 1:3 with linespoints lw 3 title "Random Waypoint"

set ylabel "Delay (sec)"
set title "Delay vs Pause Time"
set output "graphs/pause_delay.png"
plot "graphs/data/pause_delay.dat" using 1:2 with linespoints lw 3 title "Random Walk", \
     "graphs/data/pause_delay.dat" using 1:3 with linespoints lw 3 title "Random Waypoint"

set ylabel "Packet Loss (%)"
set title "Packet Loss vs Pause Time"
set output "graphs/pause_loss.png"
plot "graphs/data/pause_loss.dat" using 1:2 with linespoints lw 3 title "Random Walk", \
     "graphs/data/pause_loss.dat" using 1:3 with linespoints lw 3 title "Random Waypoint"

set ylabel "Routing Overhead"
set title "Routing Overhead vs Pause Time"
set output "graphs/pause_overhead.png"
plot "graphs/data/pause_overhead.dat" using 1:2 with linespoints lw 3 title "Random Walk", \
     "graphs/data/pause_overhead.dat" using 1:3 with linespoints lw 3 title "Random Waypoint"