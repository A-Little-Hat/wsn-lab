#!/bin/bash

# ==========================================================
# LEACH vs Rumor Routing Simulation Suite
# NS-2.35
# ==========================================================

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

TCL_DIR="$PROJECT_ROOT/tcl"
TRACE_DIR="$PROJECT_ROOT/trace"
NAM_DIR="$PROJECT_ROOT/nam"
RESULT_DIR="$PROJECT_ROOT/result"
PLOT_DIR="$RESULT_DIR/plot"
GNU_DIR="$PROJECT_ROOT/gnu"

NODES=(20 40 60 80 100 120 140 160 180 200)

mkdir -p "$TRACE_DIR"
mkdir -p "$NAM_DIR"
mkdir -p "$RESULT_DIR"
mkdir -p "$PLOT_DIR"

echo "==============================================="
echo "LEACH and Rumor Routing Simulation Suite"
echo "==============================================="
echo ""

# ----------------------------------------------------------
# LEACH SIMULATIONS
# ----------------------------------------------------------

echo "Running LEACH Simulations"
echo "=================================================="

for n in "${NODES[@]}"
do
    echo -n "Running LEACH with $n nodes ... "

    if ns "$TCL_DIR/leach.tcl" "$n" > /dev/null 2>&1
    then
        echo "✓"
    else
        echo "✗"
        echo "Failed at LEACH ($n nodes)"
        exit 1
    fi
done

echo ""

# ----------------------------------------------------------
# RUMOR SIMULATIONS
# ----------------------------------------------------------

echo "Running Rumor Routing Simulations"
echo "=================================================="

for n in "${NODES[@]}"
do
    echo -n "Running Rumor with $n nodes ... "

    if ns "$TCL_DIR/rumor.tcl" "$n" > /dev/null 2>&1
    then
        echo "✓"
    else
        echo "✗"
        echo "Failed at Rumor Routing ($n nodes)"
        exit 1
    fi
done

echo ""

# ----------------------------------------------------------
# DATA PREPARATION
# ----------------------------------------------------------

echo "Preparing metric datasets"
echo "=================================================="

cd "$GNU_DIR"

chmod +x prepare_data.sh
./prepare_data.sh

echo "✓ Metric extraction completed"

echo ""

# ----------------------------------------------------------
# PLOT GENERATION
# ----------------------------------------------------------

echo "Generating graphs"
echo "=================================================="

chmod +x run_plots.sh
./run_plots.sh

echo "✓ Graph generation completed"

echo ""

# ----------------------------------------------------------
# REPORT
# ----------------------------------------------------------

REPORT_FILE="$RESULT_DIR/SIMULATION_REPORT.txt"

{
echo "================================================="
echo "LEACH vs RUMOR ROUTING REPORT"
echo "================================================="
echo ""
echo "Execution Time : $(date)"
echo ""
echo "Node Counts:"
printf '%s\n' "${NODES[@]}"
echo ""
echo "Trace Directory:"
echo "$TRACE_DIR"
echo ""
echo "NAM Directory:"
echo "$NAM_DIR"
echo ""
echo "Plot Directory:"
echo "$PLOT_DIR"
echo ""
echo "Data Files:"
echo "$GNU_DIR/data/leach.dat"
echo "$GNU_DIR/data/rumor.dat"
echo ""
echo "Status: SUCCESS"
echo ""
echo "Generated Plots:"
echo "1. pdr_comparison.png"
echo "2. throughput_comparison.png"
echo "3. delay_comparison.png"
} > "$REPORT_FILE"

echo "==============================================="
echo "SIMULATION COMPLETED SUCCESSFULLY"
echo "==============================================="
echo ""
echo "Report : $REPORT_FILE"
echo "Plots  : $PLOT_DIR"
echo ""

exit 0
