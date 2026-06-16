set terminal pngcairo size 1200,800
set output '../result/plot/throughput_comparison.png'

set title "LEACH vs Rumor Routing - Throughput"
set xlabel "Number of Nodes"
set ylabel "Throughput (Kbps)"

set grid
set key top left

plot \
'data/leach.dat' using 1:3 with linespoints lw 3 pt 7 title 'LEACH', \
'data/rumor.dat' using 1:3 with linespoints lw 3 pt 5 title 'Rumor Routing'
