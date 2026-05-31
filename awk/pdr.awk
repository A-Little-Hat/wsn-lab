BEGIN {
    sent = 0
    received = 0
}

{
    if ($1 == "s" && $4 == "AGT" && $7 == "cbr")
        sent++

    if ($1 == "r" && $4 == "AGT" && $7 == "cbr")
        received++
}

END {
    printf("Packets Sent     : %d\n", sent)
    printf("Packets Received : %d\n", received)

    if (sent > 0)
        printf("PDR = %.2f %%\n", (received/sent)*100)
}
