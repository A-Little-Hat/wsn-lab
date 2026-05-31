set val(nn) 30
set val(stop) 300

set ns_ [new Simulator]

set tracefd [open DSDV_30.tr w]
$ns_ trace-all $tracefd

set namfd [open DSDV_30.nam w]
$ns_ namtrace-all-wireless $namfd 1000 1000

set topo [new Topography]
$topo load_flatgrid 1000 1000

set god_ [create-god $val(nn)]

set chan_ [new Channel/WirelessChannel]

$ns_ node-config \
    -adhocRouting DSDV \
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
    -routerTrace ON \
    -macTrace ON

for {set i 0} {$i < $val(nn)} {incr i} {
    set node_($i) [$ns_ node]
}

source scenarios/scen30.scen
source traffic/traffic30.tcl

proc finish {} {
    global ns_ tracefd namfd

    $ns_ flush-trace

    close $tracefd
    close $namfd

    puts "Simulation Finished"
    exit 0
}

$ns_ at $val(stop) "finish"

puts "Starting DSDV Simulation..."

$ns_ run
