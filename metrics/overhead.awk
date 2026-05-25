BEGIN {
    routing = 0;
    delivered = 0;
}
{
    event = $1;
    layer = $4;
    pkt = $7;
    if (event == "s" && layer == "RTR" && pkt == "AODV")
        routing++;

    if (event == "r" && layer == "AGT")
        delivered++;
}
END {
    if (delivered > 0)
        print routing / delivered;
    else
        print 0;
}
