#!/usr/bin/env ns

# ==========================================================
# Rumor Routing-like Wireless Sensor Network Simulation
# NS-2.35 Compatible
# Usage: ns rumor.tcl <num_nodes>
# ==========================================================

if {$argc < 1} {
    puts "Usage: ns rumor.tcl <num_nodes>"
    exit 1
}

set num_nodes [lindex $argv 0]
set sim_time 100.0

# ----------------------------------------------------------
# Simulator
# ----------------------------------------------------------

set ns [new Simulator]

set BASE_DIR [file normalize [file dirname [info script]]]

set tracefd [open "$BASE_DIR/../trace/rumor_${num_nodes}.tr" w]
set namfd   [open "$BASE_DIR/../nam/rumor_${num_nodes}.nam" w]

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
# Sink Node
# ----------------------------------------------------------

set sink_node [expr $num_nodes - 1]

set sink [new Agent/Null]
$ns attach-agent $node_($sink_node) $sink

# ----------------------------------------------------------
# Rumor Routing-like Traffic
# ----------------------------------------------------------
# Random event generators sending queries
# through a flat network structure.
# ----------------------------------------------------------

set num_sources [expr int($num_nodes * 0.20)]

if {$num_sources < 2} {
    set num_sources 2
}

puts "Rumor Sources: $num_sources"

for {set i 0} {$i < $num_sources} {incr i} {

    set src [expr int(rand()*($num_nodes-1))]

    set udp($i) [new Agent/UDP]
    $ns attach-agent $node_($src) $udp($i)

    $ns connect $udp($i) $sink

    set cbr($i) [new Application/Traffic/CBR]
    $cbr($i) attach-agent $udp($i)

    # Smaller packets, more frequent updates
    $cbr($i) set packetSize_ 128
    $cbr($i) set interval_ 0.5

    set start_time [expr 1 + rand()*20]

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

puts "Running Rumor Routing simulation with $num_nodes nodes..."

$ns run

