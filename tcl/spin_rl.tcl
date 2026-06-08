# ==================================================
# SPIN-RL Network Wide Emulation
# ==================================================

if {$argc != 1} {
    puts "Usage: ns spin_rl.tcl <num_nodes>"
    exit
}

set val(nn) [lindex $argv 0]

set val(chan) Channel/WirelessChannel
set val(prop) Propagation/TwoRayGround
set val(netif) Phy/WirelessPhy
set val(mac) Mac/802_11
set val(ifq) Queue/DropTail/PriQueue
set val(ll) LL
set val(ant) Antenna/OmniAntenna

set val(ifqlen) 50
set val(x) 500
set val(y) 500
set val(stop) 100.0

set ns [new Simulator]

set tracefile [open "$env(HOME)/ns2/examples/spin-project/trace/RL_$val(nn).tr" w]
$ns trace-all $tracefile

set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

create-god $val(nn)

$ns node-config \
    -adhocRouting DSDV \
    -llType $val(ll) \
    -macType $val(mac) \
    -ifqType $val(ifq) \
    -ifqLen $val(ifqlen) \
    -antType $val(ant) \
    -propType $val(prop) \
    -phyType $val(netif) \
    -channelType $val(chan) \
    -topoInstance $topo \
    -agentTrace ON \
    -routerTrace ON \
    -macTrace ON \
    -movementTrace ON \
    -energyModel EnergyModel \
    -initialEnergy 100 \
    -txPower 0.6 \
    -rxPower 0.3 \
    -idlePower 0.001

for {set i 0} {$i < $val(nn)} {incr i} {

    set node_($i) [$ns node]

    $node_($i) set X_ [expr rand()*$val(x)]
    $node_($i) set Y_ [expr rand()*$val(y)]
    $node_($i) set Z_ 0.0

    $ns initial_node_pos $node_($i) 20
}

# ==================================================
# SPIN-RL TRAFFIC
# ==================================================

for {set i 1} {$i < $val(nn)} {incr i} {

    # ADV
    set adv_udp($i) [new Agent/UDP]
    $ns attach-agent $node_(0) $adv_udp($i)

    set adv_sink($i) [new Agent/Null]
    $ns attach-agent $node_($i) $adv_sink($i)

    $ns connect $adv_udp($i) $adv_sink($i)

    set adv($i) [new Application/Traffic/CBR]
    $adv($i) set packetSize_ 32
    $adv($i) set interval_ 10.0
    $adv($i) attach-agent $adv_udp($i)

    # REQ
    set req_udp($i) [new Agent/UDP]
    $ns attach-agent $node_($i) $req_udp($i)

    set req_sink($i) [new Agent/Null]
    $ns attach-agent $node_(0) $req_sink($i)

    $ns connect $req_udp($i) $req_sink($i)

    set req($i) [new Application/Traffic/CBR]
    $req($i) set packetSize_ 64
    $req($i) set interval_ 10.0
    $req($i) attach-agent $req_udp($i)

    # DATA
    set data_udp($i) [new Agent/UDP]
    $ns attach-agent $node_(0) $data_udp($i)

    set data_sink($i) [new Agent/Null]
    $ns attach-agent $node_($i) $data_sink($i)

    $ns connect $data_udp($i) $data_sink($i)

    set data($i) [new Application/Traffic/CBR]
    $data($i) set packetSize_ 512
    $data($i) set interval_ 10.0
    $data($i) attach-agent $data_udp($i)

    # ACK
    set ack_udp($i) [new Agent/UDP]
    $ns attach-agent $node_($i) $ack_udp($i)

    set ack_sink($i) [new Agent/Null]
    $ns attach-agent $node_(0) $ack_sink($i)

    $ns connect $ack_udp($i) $ack_sink($i)

    set ack($i) [new Application/Traffic/CBR]
    $ack($i) set packetSize_ 16
    $ack($i) set interval_ 10.0
    $ack($i) attach-agent $ack_udp($i)

    # Scheduling

    $ns at 1.0 "$adv($i) start"
    $ns at 2.0 "$req($i) start"
    $ns at 3.0 "$data($i) start"
    $ns at 4.0 "$ack($i) start"

    $ns at 95.0 "$adv($i) stop"
    $ns at 95.0 "$req($i) stop"
    $ns at 95.0 "$data($i) stop"
    $ns at 95.0 "$ack($i) stop"
}

proc finish {} {

    global ns tracefile

    $ns flush-trace

    close $tracefile

    puts "Simulation Finished"

    exit 0
}

$ns at $val(stop) "finish"

$ns run
