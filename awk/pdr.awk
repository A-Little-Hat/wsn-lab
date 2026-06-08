BEGIN{
    sent=0
    recv=0
}

{
    if($1=="s" && $4=="AGT")
        sent++

    if($1=="r" && $4=="AGT")
        recv++
}

END{
    if(sent>0)
        printf("%.2f\n",(recv/sent)*100)
    else
        print "0"
}
