# WSN Mobility Model Comparison Framework

## Project Overview

This repository contains a comprehensive academic framework for comparing two mobility models in Mobile Ad-hoc Networks (MANETs):
- **Random Walk (RW)** - Simple mobility model where nodes move in random directions
- **Random Waypoint (RWP)** - Enhanced mobility model where nodes select random waypoints and move toward them

The framework uses **NS-2 (Network Simulator 2)** to conduct extensive simulations and generates comparative performance analysis across multiple network metrics.

---

## Project Structure

```
compare/
├── rw.tcl                 # Random Walk mobility model simulation script
├── rwp.tcl                # Random Waypoint mobility model simulation script
├── run_all.sh             # Main orchestration script (200 simulations)
├── prepare_data.py        # Data processing and aggregation script
├── analyze.awk            # AWK analysis script (legacy)
├── plot_all.gnu           # Gnuplot visualization script
├── metrics/               # Individual metric computation scripts
│   ├── pdr.awk           # Packet Delivery Ratio calculator
│   ├── throughput.awk    # Throughput calculator
│   ├── delay.awk         # Delay calculator
│   ├── loss.awk          # Packet Loss calculator
│   └── overhead.awk      # Routing Overhead calculator
├── results/               # Output directory (generated after simulation)
│   ├── all_results.csv   # Aggregated simulation results
│   ├── *.tr              # NS-2 trace files
│   └── *.nam             # NS-2 visualization files
├── graphs/                # Graph data and visualizations (generated)
│   ├── data/             # Processed data files for plotting
│   └── *.png             # Generated comparison graphs
└── README.md              # This file
```

---

## System Requirements

### Prerequisites
- **NS-2 (Network Simulator 2)** - Latest version with AODV support
- **Python 3.x** - For data processing
- **Pandas** - For DataFrame operations (`pip install pandas`)
- **Gnuplot** - For graph generation
- **AWK** - For trace file analysis
- **Bash** - For script execution (Linux/Mac or WSL on Windows)

### Installation

#### Linux/Mac
```bash
# Install NS-2 and dependencies
sudo apt-get install ns2 ns2-allinone python3 python3-pip gnuplot awk

# Install Python dependencies
pip install pandas
```

#### Windows
Use **Windows Subsystem for Linux (WSL)** or **Cygwin** with the above packages.

---

## Simulation Parameters

### Variable Parameters
The simulations test different combinations of:

| Parameter | Values | Description |
|-----------|--------|-------------|
| **Number of Nodes** | 10, 20, 30, 40, 50 | Network size |
| **Speed (m/s)** | 5, 10, 15, 20 | Maximum node velocity |
| **Pause Time (sec)** | 0, 10, 20, 30, 40 | Duration of node pauses |

**Total Simulations:** 200 (100 for RW + 100 for RWP)

### Fixed Simulation Parameters

Both models use identical network configurations:

```
Simulation Time:        200 seconds
Network Area:           1000m × 1000m
Transmission Range:     ~250m (TwoRayGround model)
Network Protocol:       AODV (Ad-hoc On-Demand Distance Vector)
MAC Layer:              IEEE 802.11
Queue Type:             DropTail Priority Queue (max 50 packets)
Packet Size:            512 bytes
Traffic Rate:           200 kbps (CBR - Constant Bit Rate)
Antenna:                OmniDirectional
Propagation Model:      Two-Ray Ground
```

---

## Performance Metrics

The framework measures five key performance indicators:

### 1. **Packet Delivery Ratio (PDR)**
- **Formula:** (Packets Received / Packets Sent) × 100
- **Unit:** Percentage (%)
- **Description:** Indicates network reliability
- **Calculation File:** `metrics/pdr.awk`

### 2. **Throughput**
- **Formula:** (Total Bits Received × 8) / (Simulation Time × 1000)
- **Unit:** Kilobits per second (kbps)
- **Description:** Network capacity utilization
- **Calculation File:** `metrics/throughput.awk`

### 3. **Average Delay**
- **Unit:** Seconds
- **Description:** End-to-end latency of successful packets
- **Calculation File:** `metrics/delay.awk`

### 4. **Packet Loss**
- **Unit:** Percentage or count
- **Description:** Percentage of dropped packets
- **Calculation File:** `metrics/loss.awk`

### 5. **Routing Overhead**
- **Unit:** Ratio/Count
- **Description:** Control packet ratio relative to data packets
- **Calculation File:** `metrics/overhead.awk`

---

## Usage Guide

### Quick Start

#### 1. Run All Simulations
```bash
./run_all.sh
```
This will:
- Create simulation directories
- Run 200 NS-2 simulations (both RW and RWP models)
- Extract metrics from trace files
- Generate CSV results
- Display progress and completion message

**Estimated Runtime:** 2-4 hours depending on system performance

#### 2. Process Simulation Data
```bash
python3 prepare_data.py
```
This will:
- Read the aggregated results CSV
- Create graph data files for three comparison dimensions
- Organize data in `graphs/data/` directory

#### 3. Generate Visualization Plots
```bash
gnuplot plot_all.gnu
```
This will:
- Create PNG comparison graphs
- Generate 15 graphs (5 metrics × 3 parameters)
- Save outputs to `graphs/` directory

### Individual Simulation Execution

Run a single simulation manually:

```bash
# Random Walk Model
ns rw.tcl <nodes> <maxspeed> <pause>
ns rw.tcl 20 10 20

# Random Waypoint Model
ns rwp.tcl <nodes> <maxspeed> <pause>
ns rwp.tcl 20 10 20
```

**Output Files:**
- `rw_20_10_20.tr` - Trace file (binary event log)
- `rw_20_10_20.nam` - Visualization file (can be played with NAM)

---

## File Descriptions

### Simulation Scripts

#### `rw.tcl` - Random Walk Mobility Model
- **Implementation:** Pure random walk without explicit waypoints
- **Movement Logic:** Nodes move with random offset changes (±100m) every interval
- **Key Function:** `random_walk()` procedure iteratively generates movement commands
- **Lines:** 202

#### `rwp.tcl` - Random Waypoint Mobility Model  
- **Implementation:** Nodes select random waypoints and travel to them
- **Movement Logic:** Sequential waypoint selection with random speeds
- **Unique Feature:** Built-in pause time at each waypoint
- **Differences from RW:** More realistic mobility pattern with intentional pauses

### Data Processing

#### `run_all.sh` - Main Orchestration Script
- **Purpose:** Execute all 200 simulations and aggregate results
- **Process:**
  1. Validates bash environment
  2. Creates results directory
  3. Nested loops: Nodes → Speeds → Pause Times
  4. Calls AWK metric calculators on each trace
  5. Appends results to CSV
  6. Moves trace and NAM files to results/

#### `prepare_data.py` - Data Aggregation
- **Purpose:** Convert raw CSV to per-metric pivot tables
- **Process:**
  1. Load `results/all_results.csv`
  2. Filter for three scenarios:
     - **Nodes varying:** Speed=10, Pause=20 (fixed)
     - **Speed varying:** Nodes=30, Pause=20 (fixed)
     - **Pause varying:** Nodes=30, Speed=10 (fixed)
  3. Create pivot tables for each metric
  4. Output to `graphs/data/*.dat` files

### Metric Calculators (AWK Scripts)

#### `metrics/pdr.awk`
```awk
Variables: sent, recv, drop, bytes
Events:    "s" + "AGT" → count sent
           "r" + "AGT" → count received + bytes
           "D"         → count dropped
Output:    PDR (%), Throughput (kbps), Drop count
```

#### `metrics/throughput.awk`
- Calculates total bytes received
- Computes (bytes × 8) / (time × 1000) in kbps

#### `metrics/delay.awk`
- Computes delay using send/receive event timestamps
- Averages across all received packets

#### `metrics/loss.awk`
- Calculates dropped packets vs. total packets
- Returns loss percentage

#### `metrics/overhead.awk`
- Counts control packets (routing) vs. data packets
- Computes ratio for efficiency analysis

### Visualization

#### `plot_all.gnu` - Gnuplot Configuration
- **Purpose:** Generate 15 comparison graphs from processed data
- **Format:** PNG output (1200×800 pixels)
- **Graphs:**
  - **Nodes Series:** 5 metrics × varying node count
  - **Speed Series:** 5 metrics × varying speed
  - **Pause Series:** 5 metrics × varying pause time
- **Style:** Line plots with point markers, legend, grid

---

## Output Structure

### Results Directory (`results/`)

#### CSV Format: `all_results.csv`
```
Model,Nodes,Speed,Pause,PDR,Throughput,Delay,Loss,Overhead
rw,10,5,0,87.5,156.2,0.045,12.5,2.3
rwp,10,5,0,89.2,162.4,0.041,10.8,2.1
...
```

#### Trace Files (`*.tr`)
- Binary format: Event-driven simulation trace
- Used by AWK scripts for metric extraction
- Can be analyzed with other NS-2 tools

#### NAM Files (`*.nam`)
- Visualization format for NS-2 animator
- Shows node positions and packet flows
- Format: `[model]_[nodes]_[speed]_[pause].nam`

### Graphs Directory (`graphs/`)

#### Data Files (`graphs/data/*.dat`)
Pivot tables in CSV format:
```
Nodes,rw,rwp           (nodes_pdr.dat)
10,85.5,87.2
20,82.3,84.9
...
```

#### Graph Files (`graphs/*.png`)
15 PNG files following naming pattern:
- `nodes_pdr.png`, `nodes_throughput.png`, etc.
- `speed_pdr.png`, `speed_throughput.png`, etc.
- `pause_pdr.png`, `pause_throughput.png`, etc.

---

## Analysis Workflow

```
┌─────────────────┐
│  run_all.sh     │ → Executes 200 simulations
└────────┬────────┘
         ↓
    *.tr files (in results/)
         ↓
    ├─ pdr.awk
    ├─ throughput.awk      → Extract metrics
    ├─ delay.awk
    ├─ loss.awk
    └─ overhead.awk
         ↓
    all_results.csv
         ↓
┌─────────────────┐
│ prepare_data.py │ → Pivot & aggregate
└────────┬────────┘
         ↓
    graphs/data/*.dat
         ↓
┌─────────────────┐
│ plot_all.gnu    │ → Generate graphs
└────────┬────────┘
         ↓
    graphs/*.png (15 files)
```

---

## Expected Results Summary

### Random Walk vs Random Waypoint Characteristics

| Aspect | Random Walk | Random Waypoint |
|--------|-------------|-----------------|
| **Mobility Pattern** | Aimless, continuous | Directional, paused |
| **Typical PDR** | 80-88% | 85-92% |
| **Throughput** | 150-170 kbps | 160-180 kbps |
| **Delay** | Higher variability | Lower variability |
| **Overhead** | Slightly higher | Slightly lower |
| **Realism** | Low | High |

---

## Troubleshooting

### Issue: NS-2 Not Found
**Solution:**
```bash
which ns
# If not found, install NS-2 or add to PATH
export PATH=$PATH:/usr/bin/ns  # Adjust path as needed
```

### Issue: AWK Script Errors
**Solution:**
- Ensure trace files are in `results/` directory
- Check trace file format compatibility with AWK scripts
- Verify AWK installation: `awk --version`

### Issue: Python Module Not Found
**Solution:**
```bash
pip install pandas
# Or
pip3 install pandas
```

### Issue: Gnuplot Not Producing Graphs
**Solution:**
```bash
# Test gnuplot
gnuplot --version

# Manual graph generation
gnuplot
> load "plot_all.gnu"
```

### Issue: Simulations Running Too Long
**Solution:**
- Reduce node count in `run_all.sh` for testing
- Reduce pause/speed combinations
- Run on high-performance system

---

## Customization Guide

### Modify Simulation Parameters

Edit `run_all.sh`:
```bash
NODES=(10 20 30 40 50)      # Change node values
SPEEDS=(5 10 15 20)          # Change speed values
PAUSES=(0 10 20 30 40)       # Change pause values
```

### Adjust Network Configuration

Edit `rw.tcl` or `rwp.tcl`:
```tcl
set val(x)         1000       # Network width
set val(y)         1000       # Network height
set val(stop)      200.0      # Simulation duration
set val(pktsize)   512        # Packet size
set val(rate)      200k       # Traffic rate
```

### Change Traffic Pattern

Modify traffic generation in TCL scripts:
```tcl
set cbr [new Application/Traffic/CBR]
$cbr set packetSize_ 512      # Change packet size
$cbr set rate_ 200k           # Change rate
```

---

## Output File Naming Convention

```
Simulation Results:
[model]_[nodes]_[speed]_[pause].tr     (trace)
[model]_[nodes]_[speed]_[pause].nam    (visualization)

Data Aggregates:
[type]_pdr.dat, [type]_throughput.dat, etc.
where type ∈ {nodes, speed, pause}

Graphs:
[type]_[metric].png
where type ∈ {nodes, speed, pause}
and   metric ∈ {pdr, throughput, delay, loss, overhead}
```

---
## Comparison Summary
- **Random Walk (RW)**: Simpler, less realistic, generally lower PDR and throughput, higher delay and overhead
- **Random Waypoint (RWP)**: More realistic, higher PDR and throughput, lower delay and overhead, better performance in dynamic scenarios
- **Overall:** RWP is typically preferred for realistic MANET simulations, while RW can be used for theoretical analysis or baseline comparisons
- **Full summary**: Refer [COMPARISON ANALYSIS](COMPARISON_ANALYSIS.md) for detailed analysis and insights

---

## References & Standards

- **NS-2 Documentation:** https://www.isi.edu/nsnam/ns/
- **AODV Protocol:** RFC 3561
- **IEEE 802.11:** Wireless LAN standard
- **Mobility Models:** "Comparative Performance Evaluation of Wireless Ad-hoc Networks" literature

---

## Notes for Researchers

1. **Reproducibility:** All random seeds are system-determined; for reproduction, modify NS-2 seed initialization
2. **Statistical Significance:** 200 simulations provide reasonable confidence intervals for comparison
3. **Mobility Impact:** Random Waypoint generally shows better performance due to lower link breakage rates
4. **Scalability:** Performance degrades significantly beyond 50 nodes (recommend testing up to 100)
5. **Real-world Application:** Results assume ideal channel conditions; real deployments show higher packet loss

---

## License & Attribution

Academic framework for WSN performance analysis. Suitable for research, coursework, and comparative studies.

**Created for:** M.Tech Semester 2 - WSN Lab  
**Use Case:** Mobility Model Comparison Study

---

## Contact & Support

For issues or improvements, refer to:
- NS-2 documentation and community forums
- AODV protocol specifications
- Trace file format documentation in NS-2 user guides

---

**Last Updated:** 2025-05-24  
**Compatibility:** NS-2.35+, Python 3.6+, Gnuplot 4.6+
