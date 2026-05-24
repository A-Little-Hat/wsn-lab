# ============================================================
# Random Waypoint Mobility Model (Academic Version)
# Comparative MANET Performance Analysis
# Usage:
#   ns rwp.tcl <nodes> <maxspeed> <pause>
# Example:
#   ns rwp.tcl 20 10 20
# ============================================================

if {$argc != 3} {
    puts "Usage: ns rwp.tcl <nodes> <maxspeed> <pause>"
    exit 1
}

# -----------------------------
# Input Parameters
# -----------------------------
set val(nn)        [lindex $argv 0]
set val(maxspeed)  [lindex $argv 1]
set val(pause)     [lindex $argv 2]

# -----------------------------
# Fixed Simulation Parameters
# -----------------------------
set val(chan)      Channel/WirelessChannel
set val(prop)      Propagation/TwoRayGround
set val(netif)     Phy/WirelessPhy
set val(mac)       Mac/802_11
set val(ifq)       Queue/DropTail/PriQueue
set val(ll)        LL
set val(ant)       Antenna/OmniAntenna
set val(ifqlen)    50
set val(rp)        AODV

set val(x)         1000
set val(y)         1000
set val(stop)      200.0
set val(pktsize)   512
set val(rate)      200k

puts "======================================"
puts "Random Waypoint Simulation"
puts "Nodes      : $val(nn)"
puts "Max Speed  : $val(maxspeed)"
puts "Pause Time : $val(pause)"
puts "======================================"

# -----------------------------
# Simulator
# -----------------------------
set ns [new Simulator]

# Unique filenames
set tracefile "rwp_$val(nn)_$val(maxspeed)_$val(pause).tr"
set namfile   "rwp_$val(nn)_$val(maxspeed)_$val(pause).nam"

set tracefd [open $tracefile w]
$ns trace-all $tracefd

set namtrace [open $namfile w]
$ns namtrace-all-wireless $namtrace $val(x) $val(y)

# -----------------------------
# Topography
# -----------------------------
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

create-god $val(nn)

set chan_1_ [new $val(chan)]

# -----------------------------
# Node Configuration
# -----------------------------
$ns node-config \
    -adhocRouting $val(rp) \
    -llType $val(ll) \
    -macType $val(mac) \
    -ifqType $val(ifq) \
    -ifqLen $val(ifqlen) \
    -antType $val(ant) \
    -propType $val(prop) \
    -phyType $val(netif) \
    -channel $chan_1_ \
    -topoInstance $topo \
    -agentTrace ON \
    -routerTrace ON \
    -macTrace ON \
    -movementTrace ON

# -----------------------------
# Node Creation
# -----------------------------
for {set i 0} {$i < $val(nn)} {incr i} {

    set node_($i) [$ns node]

    set xpos [expr rand() * $val(x)]
    set ypos [expr rand() * $val(y)]

    $node_($i) set X_ $xpos
    $node_($i) set Y_ $ypos
    $node_($i) set Z_ 0.0

    $ns initial_node_pos $node_($i) 20
}

# -----------------------------
# Random Waypoint Procedure
# -----------------------------
proc random_waypoint {ns node maxx maxy maxspeed pause stoptime t} {

    if {$t >= $stoptime} {
        return
    }

    set dx [expr rand() * $maxx]
    set dy [expr rand() * $maxy]
    set speed [expr 1 + rand() * $maxspeed]

    $ns at $t "$node setdest $dx $dy $speed"

    set next [expr $t + $pause + 5]

    $ns at $next \
        "random_waypoint $ns $node $maxx $maxy $maxspeed $pause $stoptime $next"
}

# Start mobility
for {set i 0} {$i < $val(nn)} {incr i} {
    random_waypoint \
        $ns \
        $node_($i) \
        $val(x) \
        $val(y) \
        $val(maxspeed) \
        $val(pause) \
        $val(stop) \
        1.0
}

# -----------------------------
# Traffic Configuration
# -----------------------------
set udp [new Agent/UDP]
$ns attach-agent $node_(0) $udp

set null [new Agent/Null]
$ns attach-agent $node_([expr $val(nn)-1]) $null

$ns connect $udp $null

set cbr [new Application/Traffic/CBR]
$cbr set packetSize_ $val(pktsize)
$cbr set rate_ $val(rate)
$cbr set random_ false
$cbr attach-agent $udp

$ns at 20.0 "$cbr start"
$ns at 180.0 "$cbr stop"

# -----------------------------
# Finish
# -----------------------------
proc finish {} {
    global ns tracefd namtrace tracefile

    $ns flush-trace
    close $tracefd
    close $namtrace

    puts "Simulation complete."
    puts "Trace file generated: $tracefile"

    exit 0
}

$ns at $val(stop) "finish"

# -----------------------------
# Run
# -----------------------------
$ns run