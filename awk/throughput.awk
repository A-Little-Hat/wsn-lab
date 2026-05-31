BEGIN {
    bytes = 0
    first = -1
    last = 0
}

{
    if ($1=="r" && $4=="AGT" && $7=="cbr") {

        if (first < 0)
            first = $2

        last = $2

        bytes += $8
    }
}

END {

    duration = last - first

    throughput = (bytes * 8) / duration

    printf("Received Bytes : %d\n", bytes)
    printf("Duration       : %.2f sec\n", duration)
    printf("Throughput     : %.2f bps\n", throughput)
}
