#!/bin/bash

rm -rf "$3"

#ffmpeg -i "$1" -i "$2" -filter_complex "[0:v:0]pad=iw*2:ih[bg]; [bg][1:v:0]overlay=w" "$3"
#ffmpeg -i "$1" -i "$2" -filter_complex "[0:v]setpts=PTS-STARTPTS, pad=iw*2:ih[bg]; [1:v]setpts=PTS-STARTPTS[fg]; [bg][fg]overlay=w" "$3"

ffmpeg -i "$1" -i "$2" -filter_complex '[0:v]pad=iw*2:ih[int];[int][1:v]overlay=W/2:0[vid]' -map [vid] -c:v libx264 -crf 23 -preset veryfast "$3"