/^#/ || /^$/ { next }
NF>4 { print "a valid crypttab has max 4 cols not " NF >"/dev/stderr"; next }
{
    # decode the src variants
    split($2, o_src, "=")
    if (o_src[1] == "UUID" || o_src[1] == "PARTUUID") ("blkid -l -o device -t " $2) | getline src;
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
        commonopts="";
        swapopts="";
        luksopts="";
        for(i in opts) {
            split(opts[i], para, "=");
            par=para[1];
            val=para[2];
            if ( par == "readonly" || par == "read-only") commonopts=commonopts "-r ";
            else if ( par == "discard" ) commonopts=commonopts "--allow-discards ";
            else if ( par == "no-read-workqueue" ) commonopts=commonopts "--perf-no_read_workqueue ";
            else if ( par == "no-write-workqueue" ) commonopts=commonopts "--perf-no_write_workqueue ";
            else if ( par == "tries" ) commonopts=commonopts "-T " val " ";
            else if ( par == "swap" ) makeswap="y";
            else if ( par == "cipher" ) swapopts=swapopts "-c " val " ";
            else if ( par == "size" ) swapopts=swapopts "-s " val " ";
            else if ( par == "hash" ) swapopts=swapopts "-h " val " ";
            else if ( par == "offset" ) swapopts=swapopts "-o " val " ";
            else if ( par == "skip" ) swapopts=swapopts "-p " val " ";
            else if ( par == "verify" ) swapopts=swapopts "-y ";
            #else if ( par == "noauto" )
            #else if ( par == "nofail" )
            #else if ( par == "plain" )
            #else if ( par == "timeout" )
            #else if ( par == "tmp" )
            else if ( par == "luks" ) use_luks="y";
            else if ( par == "keyscript" ) {use_keyscript="y"; keyscript=val;}
            else if ( par == "keyslot" || par == "key-slot" ) luksopts=luksopts "-S " val " ";
            else if ( par == "keyfile-size" ) luksopts=luksopts "-l " val " ";
            else if ( par == "keyfile-offset" ) luksopts=luksopts "--keyfile-offset=" val " ";
            else if ( par == "header" ) luksopts=luksopts "--header=" val " ";
            else if ( par == "perf-same_cpu_crypt" ) commonopts=commonopts "--perf-same_cpu_crypt ";
            else if ( par == "perf-submit_from_crypt_cpus" ) commonopts=commonopts "--perf-submit_from_crypt_cpus ";
            else if ( par == "perf-no_read_workqueue" ) commonopts=commonopts "--perf-no_read_workqueue ";
            else if ( par == "perf-no_write_workqueue" ) commonopts=commonopts "--perf-no_write_workqueue ";
            else {
                print "option: " par " not supported " >"/dev/stderr";
                makeswap="";
                use_luks="";
                use_keyscript="";
                next;
            }
        }
        if ( makeswap == "y" && use_luks != "y" ) {
            ccmd="cryptsetup " swapopts commonopts "-d " key " create " dest " " src;
            ccmd_2="mkswap /dev/mapper/" dest;
            makeswap="";
            use_luks=""; 
            use_keyscript="";
            system(ccmd);
            system(ccmd_2);
            ccmd="";
            ccmd_2="";
            next;
        }
        if ( use_luks == "y" && makeswap != "y" ){
            if ( use_keyscript == "y") {
                ccmd=keyscript " | cryptsetup " luksopts commonopts "luksOpen -d - " src " " dest;
                use_keyscript="";
            }
            else {
                if ( key == "none" ){
                    ccmd="cryptsetup " luksopts commonopts "luksOpen " src " " dest;
                }
                else {
                    ccmd="cryptsetup " luksopts commonopts "luksOpen -d " key " " src " " dest;
                }
            }
        }
        else {
            print "use swap OR luks as option" >"/dev/stderr";
            ccmd="";
        }
        makeswap="";
        use_luks="";
        use_keyscript="";
        if ( ccmd != ""){
            system(ccmd);
            ccmd=""
        }
    }
}
