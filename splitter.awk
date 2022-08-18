#!/usr/bin/env -S awk -f

BEGIN {
    FS=","
    SOURCE=ARGV[2]
    ARGV[2]=""
    OUT_DIR=ARGV[3]
    sub(/\/$/, "", OUT_DIR)
    ARGV[3]=""

    FILE_TYPE= file_extension(SOURCE)
}

function file_extension(file) {
    n = split(file, a, ".")
    return a[n]
}

function out_path(title, nr) {
    sub(/[ \t]+$/, "", title);
    return sprintf("%s/%0.2d_%s.%s", OUT_DIR, nr, title, FILE_TYPE )
}

function print_ffmpeg_command(from, to, title){
    if (to == "") {
        printf "ffmpeg -i \"%s\" -ss %s -c copy \"%s\"\n",
            SOURCE,
            from,
            out_path(title, NR)
    } else {
        printf "ffmpeg -i \"%s\" -ss %s -to %s -c copy \"%s\"\n",
            SOURCE,
            from,
            to,
            out_path(title, NR - 1)
    }
}

NR > 1 {
    print_ffmpeg_command(prevTime, $2, prevTitle)
}

END {
    print_ffmpeg_command($2, "", $1)
}

{
    prevTime=$2
    prevTitle=$1
}
