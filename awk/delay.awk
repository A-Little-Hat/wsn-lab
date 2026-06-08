BEGIN{
    total=0
    recv=0
}

{
    if($1=="s" && $4=="AGT"){
        st[$6]=$2
    }

    if($1=="r" && $4=="AGT"){

        if($6 in st){

            total += ($2-st[$6])
            recv++
        }
    }
}

END{

    if(recv>0)
        printf("%.6f\n",total/recv)
    else
        print "0"
}
