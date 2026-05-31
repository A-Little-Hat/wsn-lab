set val(nn) 30

# Scenario file expects this exact name
set ns_ [new Simulator]

set tracefd [open test.tr w]
$ns_ trace-all $tracefd

set topo [new Topography]
$topo load_flatgrid 1000 1000

# Scenario file expects god_
set god_ [create-god $val(nn)]

set chan_ [new Channel/WirelessChannel]

$ns_ node-config \
    -adhocRouting AODV \
    -llType LL \
    -macType Mac/802_11 \
    -ifqType Queue/DropTail/PriQueue \
    -ifqLen 50 \
    -antType Antenna/OmniAntenna \
    -propType Propagation/TwoRayGround \
    -phyType Phy/WirelessPhy \
    -channel $chan_ \
    -topoInstance $topo

for {set i 0} {$i < $val(nn)} {incr i} {
    set node_($i) [$ns_ node]
}

source scenarios/scen30.scen

puts "Scenario loaded successfully"

exit 0
