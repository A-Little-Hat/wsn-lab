set terminal pngcairo size 1200,800
set output '../result/plot/delay_comparison.png'

set title "LEACH vs Rumor Routing - Average Delay"
set xlabel "Number of Nodes"
set ylabel "Delay (s)"

set grid
set key top left

plot \
'data/leach.dat' using 1:4 with linespoints lw 3 pt 7 title 'LEACH', \
'data/rumor.dat' using 1:4 with linespoints lw 3 pt 5 title 'Rumor Routing'
