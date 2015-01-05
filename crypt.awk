/^#/ || /^$/ { next }
NF>4 { print "a valid crypttab has max 4 cols not " NF >"/dev/stderr"; next }
{
    # decode the src variants
    split($2, o_src, "=")
    if (o_src[1] == "UUID") "/sbin/blkid -t " $2 " -l -o device" |& getline src;
    else src=o_src[1];

    # no password or none is given, ask fo it
    if ( NF == 2 ) system("cryptsetup luksOpen " src " " $1);
    else if (NF == 3 )
    {
        split($3, po, "=");
        if ( po[1] == "none") system("cryptsetup luksOpen " src " " $1);
        else system("cryptsetup luksOpen -d " $3 " " src" " $1);
    }
    else
    # the option fild is not empty parse the options
    {
        split($4, opts, ",");
        for(i in opts)
        {
            split(opts[i], para, "=");
            if ( para[1] == "readonly" ) cmd=cmd "-r ";
            else if ( para[1] == "cipher" ) cmd=cmd "-c " para[2] " ";
            else if ( para[1] == "size" ) cmd=cmd "-s " para[2] " ";
            else if ( para[1] == "hash" ) cmd=cmd "-h " para[2] " ";
            else if ( para[1] == "offset" ) cmd=cmd "-o " para[2] " ";
            else if ( para[1] == "skip" ) cmd=cmd "-p " para[2] " ";
            else if ( para[1] == "tries" ) cmd=cmd "-T " para[2] " ";
            else if ( para[1] == "verify" ) cmd=cmd "-y ";
            else if ( para[1] == "discard" ) cmd=cmd "--allow-discards ";
            else if ( para[1] == "swap" ) makeswap="y";
            else if ( para[1] == "tmp" ) maketmp="y";
            else if ( para[1] == "luks" ) useluks="y";
            else if ( para[1] == "keyscript" ) keyscript=para[2];
            else if ( para[1] == "keyslot" ) luksparams="--key-slot " para[2] " ";
            else
            {
                print "no valid option " para[1] >"/dev/stderr";
                cmd="";
                makeswap="";
                maketmp="";
                useluks="";
                luksparams="";
                next;
            }
        }
        if ( makeswap == "y" )
        {
            system("cryptsetup " cmd " -d " $3 " create " src " " $1);
            system("mkswap /dev/mapper/" $1 );
        }
        else if ( maketmp == "y" )
        {
            system("cryptsetup " cmd " -d " $3 " create " src " " $1"_unformatted");
            system("mkefs -t ext4 -q /dev/mapper/" $1"_unformatted" );
            mdir="/run/cryptsetup/" $1;
            system("mkdir -p " mdir);
            system("mount /dev/mapper/" $1 "_unformatted  " mdir);
            system("chmod 1777 " mdir);
            system("umount " mdir);
            #system("rmdir" mdir);
            system("dmsetup rename " $1"_unformated " $1)
        }
        else if ( system("cryptsetup isLuks " src ) )
        {
            print "options are invalid for LUKS partitions" >"/dev/stderr";
            system("cryptsetup Open -d " $3 " " src " " $1);
        }
        else if (para[1] == "keyscript" )
        {
            system( keyscript "| cryptsetup luksOpen -d - " src " " $1);
        }
        else print "other" >"/dev/stderr";
    }
}
