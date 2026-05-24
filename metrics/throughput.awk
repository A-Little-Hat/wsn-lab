BEGIN {
    bytes = 0;
    start = -1;
    stop = 0;
}

{
    event = $1;
    time = $2;
    layer = $4;

    if (event == "r" && layer == "AGT") {

        if (start < 0)
            start = time;

        stop = time;
        bytes += $8;
    }
}

END {
    duration = stop - start;

    if (duration > 0)
        print (bytes * 8) / (duration * 1000);
    else
        print 0;
}
