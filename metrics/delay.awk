BEGIN {
    total_delay = 0;
    recv = 0;
}

{
    event = $1;
    time = $2;
    layer = $4;
    seq = $6;

    if (event == "s" && layer == "AGT") {
        send_time[seq] = time;
    }

    if (event == "r" && layer == "AGT") {
        if (seq in send_time) {
            total_delay += (time - send_time[seq]);
            recv++;
        }
    }
}

END {
    if (recv > 0)
        print total_delay / recv;
    else
        print 0;
}
