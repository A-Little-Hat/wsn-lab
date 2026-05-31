set protocol [lindex $argv 0]
set nodes [lindex $argv 1]

if {$protocol == "" || $nodes == ""} {
    puts "Usage: ns run_manet.tcl <AODV|DSDV> <30|60|100|150>"
    exit 1
}

set val(nn) $nodes
set val(stop) 200

set ns_ [new Simulator]

set tracefd [open trace/${protocol}_${nodes}.tr w]
$ns_ trace-all $tracefd

set namfd [open trace/${protocol}_${nodes}.nam w]
$ns_ namtrace-all-wireless $namfd 1000 1000

set topo [new Topography]
$topo load_flatgrid 1000 1000

set god_ [create-god $val(nn)]

set chan_ [new Channel/WirelessChannel]

$ns_ node-config \
    -adhocRouting $protocol \
    -llType LL \
    -macType Mac/802_11 \
    -ifqType Queue/DropTail/PriQueue \
    -ifqLen 50 \
    -antType Antenna/OmniAntenna \
    -propType Propagation/TwoRayGround \
    -phyType Phy/WirelessPhy \
    -channel $chan_ \
    -topoInstance $topo \
    -agentTrace ON \
    -routerTrace OFF \
    -macTrace OFF

for {set i 0} {$i < $val(nn)} {incr i} {
    set node_($i) [$ns_ node]
}

source scenarios/scen${nodes}.scen
source traffic/traffic${nodes}.tcl

proc finish {} {
    global ns_ tracefd namfd

    $ns_ flush-trace

    close $tracefd
    close $namfd

    puts "Simulation Finished"

    exit 0
}

$ns_ at $val(stop) "finish"

puts "Running $protocol with $nodes nodes"

$ns_ run
