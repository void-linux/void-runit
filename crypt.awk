/^#/ || /^$/ { next }
NF>4 { print "a valid crypttab has max 4 cols not " NF >"/dev/stderr"; next }
{
    # decode the src variants
    split($2, o_src, "=")
    if (o_src[1] == "UUID") "blkid -t " $2 " -l -o device" |& getline src;
    else src=o_src[1];

    # no password or none is given, ask fo it
    if ( NF == 2 ) {
        ccmd="cryptsetup luksOpen " src " " $1;
        system(ccmd);
        ccmd="";
    }
    else if (NF == 3 ) {
        dest=$1
        key=$3
        split($3, po, "=");
        if ( po[1] == "none") ccmd="cryptsetup luksOpen " src " " dest;
        else ccmd="cryptsetup luksOpen -d " key " " src" " dest;
        system(ccmd);
        ccmd="";
    }
    else {
    # the option field is not empty parse the options
        dest=$1
        key=$3
        split($4, opts, ",");
        for(i in opts) {
            split(opts[i], para, "=");
            par=para[1];
            val=para[2]
            if ( par == "readonly" || par == "read-only") cmd=cmd "-r ";
            else if ( par == "cipher" ) cmd=cmd "-c " val " ";
            else if ( par == "size" ) cmd=cmd "-s " val " ";
            else if ( par == "hash" ) cmd=cmd "-h " val " ";
            else if ( par == "offset" ) cmd=cmd "-o " val " ";
            else if ( par == "skip" ) cmd=cmd "-p " val " ";
            else if ( par == "tries" ) cmd=cmd "-T " val " ";
            else if ( par == "verify" ) cmd=cmd "-y ";
            else if ( par == "discard" ) cmd=cmd "--allow-discards ";
            else if ( par == "swap" ) makeswap="y";
            else if ( par == "luks" ) use_luks="y";
            #else if ( par == "noauto" )
            #else if ( par == "nofail" )
            #else if ( par == "plain" )
            #else if ( par == "timeout" )
            #else if ( par == "tmp" )
            else if ( par == "keyscript" ) {use_keyscript="y"; keyscript=val;}
            else if ( par == "keyslot" || par == "key-slot" ) luksparams=luksparams "-S " val " ";
            else {
                print "option: " par " not supported " >"/dev/stderr";
                cmd="";
                makeswap="";
                use_luks="";
                use_keyscript="";
                luksparams="";
                next;
            }
        }
        if ( makeswap == "y" && use_luks != "y" ) {
            ccmd="cryptsetup " cmd " -d " key " create " dest " " src;
            ccmd_2="mkswap /dev/mapper/" dest;
            cmd="";
            makeswap="";
            usekeyscript="";
            luksparams="";
            system(ccmd);
            system(ccmd_2);
            ccmd="";
            ccmd_2="";
            next;
        }
        if ( use_luks == "y" && makeswap != "y" ){
            if ( use_keyscript == "y") {
                ccmd=keyscript " | cryptsetup" luksparams " luksOpen -d - " src " " dest;
                use_keyscript="";
            }
            else {
                if ( key == "none" ){
                    ccmd="cryptsetup" luksparams " luksOpen " src " " dest;
                }
                else {
                    ccmd="cryptsetup" luksparams " luksOpen -d " key " " src " " dest;
                }
            }
        }
        else {
            print "use swap OR luks as option" >"/dev/stderr";
            ccmd="";
        }
        cmd="";
        makeswap="";
        use_luks="";
        use_keyscript="";
        luksparams="";
        if ( ccmd != ""){
            system(ccmd);
            ccmd=""
        }
    }
}
