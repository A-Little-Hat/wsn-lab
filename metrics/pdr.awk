BEGIN {
    sent = 0;
    recv = 0;
}

{
    event = $1;
    layer = $4;

    if (event == "s" && layer == "AGT") {
        sent++;
    }

    if (event == "r" && layer == "AGT") {
        recv++;
    }
}

END {
    if (sent > 0)
        print (recv / sent) * 100;
    else
        print 0;
}
