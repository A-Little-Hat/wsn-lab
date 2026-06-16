#!/bin/bash

mkdir -p data
mkdir -p ../result/plot

./prepare_data.sh

gnuplot plot_pdr.gnu
gnuplot plot_throughput.gnu
gnuplot plot_delay.gnu

echo "Plots generated in result/plot/"
