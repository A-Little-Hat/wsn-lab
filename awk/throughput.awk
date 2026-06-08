BEGIN{
    bytes=0
    first=-1
    last=0
}

{
    if($1=="r" && $4=="AGT"){

        if(first==-1)
            first=$2

        last=$2

        bytes += $8
    }
}

END{

    duration=last-first

    if(duration<=0){
        print "0"
        exit
    }

    throughput=(bytes*8)/(duration*1000)

    printf("%.4f\n",throughput)
}
