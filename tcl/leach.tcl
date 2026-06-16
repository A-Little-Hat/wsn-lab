#!/usr/bin/env ns

# ==========================================================
# LEACH-like Wireless Sensor Network Simulation
# NS-2.35 Compatible
# Usage: ns leach.tcl <num_nodes>
# ==========================================================

if {$argc < 1} {
    puts "Usage: ns leach.tcl <num_nodes>"
    exit 1
}

set num_nodes [lindex $argv 0]
set sim_time 100.0

# ----------------------------------------------------------
# Simulator
# ----------------------------------------------------------

set ns [new Simulator]

set BASE_DIR [file normalize [file dirname [info script]]]

set tracefd [open "$BASE_DIR/../trace/leach_${num_nodes}.tr" w]
set namfd   [open "$BASE_DIR/../nam/leach_${num_nodes}.nam" w]

$ns trace-all $tracefd
$ns namtrace-all-wireless $namfd 1000 1000

# ----------------------------------------------------------
# Topology
# ----------------------------------------------------------

set topo [new Topography]
$topo load_flatgrid 1000 1000

create-god $num_nodes

# ----------------------------------------------------------
# Wireless Configuration
# ----------------------------------------------------------

set chan [new Channel/WirelessChannel]

$ns node-config \
    -adhocRouting DSDV \
    -llType LL \
    -macType Mac/802_11 \
    -ifqType Queue/DropTail/PriQueue \
    -ifqLen 50 \
    -antType Antenna/OmniAntenna \
    -propType Propagation/TwoRayGround \
    -phyType Phy/WirelessPhy \
    -channel $chan \
    -topoInstance $topo \
    -agentTrace ON \
    -routerTrace ON \
    -macTrace ON

# ----------------------------------------------------------
# Node Creation
# ----------------------------------------------------------

for {set i 0} {$i < $num_nodes} {incr i} {

    set node_($i) [$ns node]

    set x [expr rand()*1000]
    set y [expr rand()*1000]

    $node_($i) set X_ $x
    $node_($i) set Y_ $y
    $node_($i) set Z_ 0

    $ns initial_node_pos $node_($i) 20
}

# ----------------------------------------------------------
# Cluster Head Selection (LEACH-like)
# ----------------------------------------------------------

set num_clusters [expr int(sqrt($num_nodes))]
if {$num_clusters < 1} {
    set num_clusters 1
}

set cluster_heads {}

for {set i 0} {$i < $num_clusters} {incr i} {

    set ch [expr int(rand()*$num_nodes)]

    while {[lsearch $cluster_heads $ch] != -1} {
        set ch [expr int(rand()*$num_nodes)]
    }

    lappend cluster_heads $ch
}

puts "Cluster Heads: $cluster_heads"

# ----------------------------------------------------------
# Base Station
# ----------------------------------------------------------

set sink_node [expr $num_nodes - 1]

set sink [new Agent/Null]
$ns attach-agent $node_($sink_node) $sink

# ----------------------------------------------------------
# Traffic Generation
# ----------------------------------------------------------

for {set i 0} {$i < $num_nodes - 1} {incr i} {

    set udp($i) [new Agent/UDP]
    $ns attach-agent $node_($i) $udp($i)

    $ns connect $udp($i) $sink

    set cbr($i) [new Application/Traffic/CBR]
    $cbr($i) attach-agent $udp($i)

    $cbr($i) set packetSize_ 512
    $cbr($i) set interval_ 1.0

    set start_time [expr 1.0 + rand()*10.0]

    $ns at $start_time "$cbr($i) start"
    $ns at [expr $sim_time - 5] "$cbr($i) stop"
}

# ----------------------------------------------------------
# Finish Procedure
# ----------------------------------------------------------

proc finish {ns tracefd namfd} {

    $ns flush-trace

    close $tracefd
    close $namfd

    puts "Simulation Completed"

    exit 0
}

$ns at $sim_time "finish $ns $tracefd $namfd"

puts "Running LEACH simulation with $num_nodes nodes..."

$ns run
