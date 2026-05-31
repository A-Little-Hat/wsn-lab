BEGIN {
    totalDelay = 0
    received = 0
}

{
    if ($1 == "s" && $4 == "AGT" && $7 == "cbr") {
        sendTime[$6] = $2
    }

    if ($1 == "r" && $4 == "AGT" && $7 == "cbr") {

        if ($6 in sendTime) {

            delay = $2 - sendTime[$6]

            totalDelay += delay
            received++
        }
    }
}

END {

    printf("Packets Used : %d\n", received)

    if (received > 0)
        printf("Average Delay = %.6f sec\n", totalDelay/received)
}
