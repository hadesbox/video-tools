ffmpeg -i $1 -ss 00:00:03 -t 00:00:30 -async 1 "out_$1"