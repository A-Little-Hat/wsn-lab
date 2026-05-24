BEGIN {
    sent=0;
    recv=0;
    drop=0;
    bytes=0;
}

{
    event=$1;

    if(event=="s" && $4=="AGT")
        sent++;

    if(event=="r" && $4=="AGT") {
        recv++;
        bytes += $8;
    }

    if(event=="D")
        drop++;
}

END {
    pdr=(recv/sent)*100;
    throughput=(bytes*8)/(100*1000);

    print "PDR:", pdr;
    print "Throughput(kbps):", throughput;
    print "Dropped:", drop;
}