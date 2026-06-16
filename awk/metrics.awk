BEGIN {
    sent=0
    received=0
    bytes=0
    total_delay=0
}

{
    event=$1
    time=$2
    layer=$4
    pkt_id=$6

    if(event=="s" && layer=="AGT") {
        sent++
        send_time[pkt_id]=time
    }

    if(event=="r" && layer=="AGT") {
        received++
        bytes += $8

        if(pkt_id in send_time) {
            total_delay += (time-send_time[pkt_id])
        }
    }
}

END {

    pdr=0
    if(sent>0)
        pdr=(received/sent)*100

    delay=0
    if(received>0)
        delay=total_delay/received

    throughput=(bytes*8)/(100*1000)

    printf("%.4f %.4f %.4f\n",pdr,throughput,delay)
}
