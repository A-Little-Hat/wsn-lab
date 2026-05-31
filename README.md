# WSN Lab: MANET Routing Protocol Performance Analysis

This repository contains a wireless sensor network (WSN) simulation framework for comparing the performance of ad-hoc routing protocols using NS-2 (Network Simulator).

## Project Overview

This lab evaluates and compares the performance of two popular Ad-Hoc On-Demand Distance Vector (AODV) and Destination Sequenced Distance Vector (DSDV) routing protocols in mobile ad-hoc networks (MANETs). The simulation runs multiple scenarios with varying network sizes and generates comprehensive performance metrics.

## Features

- **Protocol Comparison**: Simulates AODV and DSDV routing protocols
- **Scalability Testing**: Tests with 30, 60, 100, and 150 network nodes
- **Comprehensive Metrics**: Evaluates three key performance indicators:
  - **PDR (Packet Delivery Ratio)**: Percentage of packets successfully delivered
  - **Delay**: Average end-to-end packet delivery latency
  - **Throughput**: Network throughput in bits per second
- **Automated Analysis**: AWK scripts for automatic metric extraction
- **Visualization**: Gnuplot-based graph generation

## Project Structure

```
wsn-lab/
├── run_all.sh                 # Main simulation script (runs all scenarios)
├── run_manet.tcl              # NS-2 TCL simulation script
├── plot_results.gnu           # Gnuplot configuration for visualization
│
├── scenarios/                 # Node mobility scenarios
│   ├── scen30.scen            # 30-node scenario
│   ├── scen60.scen            # 60-node scenario
│   ├── scen100.scen           # 100-node scenario
│   └── scen150.scen           # 150-node scenario
│
├── traffic/                   # Traffic generation patterns
│   ├── traffic30.tcl          # 30-node traffic
│   ├── traffic60.tcl          # 60-node traffic
│   ├── traffic100.tcl         # 100-node traffic
│   └── traffic150.tcl         # 150-node traffic
│
├── awk/                       # Metric extraction scripts
│   ├── pdr.awk                # Packet Delivery Ratio calculator
│   ├── delay.awk              # Average delay calculator
│   └── throughput.awk         # Throughput calculator
│
├── trace/                     # NS-2 simulation traces (generated)
│   └── *.tr, *.nam            # Trace files from simulations
│
├── results/                   # Output data (generated)
│   └── metrics.csv            # Compiled results from all scenarios
│
└── plots/                     # Generated graphs (generated)
    ├── pdr.png                # PDR comparison chart
    ├── delay.png              # Delay comparison chart
    └── throughput.png         # Throughput comparison chart
```

## Prerequisites

- **NS-2 (Network Simulator 2)**: The main simulation environment
  - Installation guide: https://www.isi.edu/nsnam/ns/
- **Gnuplot**: For graph generation
  - Installation: `apt-get install gnuplot` (Ubuntu/Debian) or brew install gnuplot (macOS)
- **AWK**: Text processing utility (usually pre-installed on Linux/macOS)
- **Bash**: Shell environment

## Installation

### 1. Install NS-2

```bash
# Ubuntu/Debian
sudo apt-get install ns2

# macOS (using Homebrew)
brew install ns2

# Or compile from source:
# Download from https://www.isi.edu/nsnam/ns/
```

### 2. Install Gnuplot

```bash
# Ubuntu/Debian
sudo apt-get install gnuplot

# macOS
brew install gnuplot

# Windows (download from gnuplot.info)
```

### 3. Clone Repository

```bash
git clone https://github.com/A-Little-Hat/wsn-lab.git
cd wsn-lab
```

## Usage

### Run All Simulations

Execute the main script to run all protocol/node combinations:

```bash
chmod +x run_all.sh
./run_all.sh
```

This script will:
1. Create necessary directories (trace, results, plots)
2. Clean up old trace files
3. Run simulations for:
   - AODV with 30, 60, 100, 150 nodes
   - DSDV with 30, 60, 100, 150 nodes
4. Extract metrics from trace files
5. Store results in `results/metrics.csv`

### Run Individual Simulation

To run a specific protocol and node configuration:

```bash
ns run_manet.tcl <PROTOCOL> <NODES>
```

Example:
```bash
ns run_manet.tcl AODV 30
ns run_manet.tcl DSDV 100
```

### Generate Graphs

After simulations complete, generate visualization plots:

```bash
gnuplot plot_results.gnu
```

This creates three PNG files in the `plots/` directory:
- `pdr.png` - Packet Delivery Ratio comparison
- `delay.png` - Average delay comparison
- `throughput.png` - Throughput comparison

## Simulation Configuration

### Network Parameters

- **Topology**: 1000m × 1000m flat grid
- **Simulation Duration**: 200 seconds
- **MAC Protocol**: 802.11
- **Queue Type**: DropTail with Priority
- **Queue Length**: 50 packets
- **Antenna**: Omnidirectional
- **Propagation Model**: Two-Ray Ground
- **Physical Layer**: WirelessPhy

### Routing Protocols

**AODV (Ad-Hoc On-Demand Distance Vector)**
- Reactive (on-demand) protocol
- Broadcasts route discovery queries when needed
- Lower control overhead for sparse traffic
- Better for mobile networks

**DSDV (Destination Sequenced Distance Vector)**
- Proactive (table-driven) protocol
- Maintains routes to all destinations proactively
- Regular updates sent periodically
- Better for dense, static networks

## Output Interpretation

### metrics.csv Structure

```
Protocol,Nodes,PDR,Delay,Throughput
AODV,30,98.45,0.025,950000
AODV,60,95.20,0.032,920000
...
```

### Key Metrics

- **PDR (%)**: Higher is better (ideally 100% means all packets delivered)
- **Delay (seconds)**: Lower is better (indicates faster packet delivery)
- **Throughput (bps)**: Higher is better (indicates more data transferred)

## Trace Analysis

Trace files contain detailed simulation logs:
- `*.tr` files: Packet-level trace data (used by AWK scripts)
- `*.nam` files: Network Animator format (can be visualized with NAM)

To visualize a simulation with Network Animator:

```bash
nam trace/AODV_30.nam
```

## Customization

### Modify Scenarios

Edit scenario files in `scenarios/` to change:
- Node mobility patterns
- Movement speed
- Pause times

### Modify Traffic

Edit traffic files in `traffic/` to change:
- Number of flows
- Flow rates
- Source/destination pairs

### Adjust Simulation Parameters

Edit `run_manet.tcl` to modify:
- Simulation duration (`set val(stop)`)
- Queue parameters
- Physical layer characteristics

## Troubleshooting

**Issue**: "ns: command not found"
- Solution: Ensure NS-2 is installed and in your PATH

**Issue**: "gnuplot: command not found"
- Solution: Install gnuplot using your package manager

**Issue**: "Simulation failed"
- Solution: Check that scenario and traffic files exist and are properly formatted

**Issue**: Empty metrics.csv
- Solution: Verify that AWK scripts can access trace files and have correct field extraction

## Dependencies Summary

| Tool | Version | Purpose |
|------|---------|---------|
| NS-2 | 2.35+ | Network simulation engine |
| Gnuplot | 5.0+ | Graph generation |
| AWK | GNU awk | Trace file parsing |
| Bash | 4.0+ | Script automation |

## Performance Notes

- Full simulation suite (8 scenarios) typically completes in 5-10 minutes
- Trace files can be large (>10MB per simulation)
- Graph generation is quick (<1 second per graph)

## References

- NS-2 Documentation: https://www.isi.edu/nsnam/ns/
- AODV Protocol: RFC 3561
- DSDV Protocol: RFC 3326
- Gnuplot: http://gnuplot.info/

## License

This project is part of MTech coursework in Wireless Sensor Networks.

## Author

Created for M.Tech Semester 2, WSN Lab - IIT/University, 2025

## Contributing

For modifications or improvements to simulation scenarios, contact the repository maintainer.

---

**Last Updated**: May 2026
