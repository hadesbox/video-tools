#!/bin/bash

PFORMAT="rgb24"
VCODEC="-c:v qtrle"
VFORMAT="pal"

IMAGE="$1"
DURATION=180
FADEOUT=`echo $DURATION-30 | bc`
SPEED1=90
SPEED2=`echo $SPEED1*5/4 | bc`
SPEED3=`echo $SPEED1*6/5 | bc`

MODE=glow
OUTPUT="$1.mp4"
OPTS="-y -pix_fmt $PFORMAT $VCODEC -s $VFORMAT"
OPTS="-y -pix_fmt $PFORMAT -s $VFORMAT"

rm $OUTPUT

exec ffmpeg -loop 1 -i $IMAGE -t $DURATION $OPTS -filter_complex "
split=3 [j1][j2], rotate=PI/3+2*PI*t/$SPEED1, negate, hue=h=20 [j3];
[j1] rotate=PI/3+2*PI*t/$SPEED2, hflip, [j3] blend=all_mode=$MODE [r1];
[j2] rotate=PI/3+2*PI*t/-$SPEED3, vflip, hue=h=10:s=1 [r2];
[r1][r2] blend=all_mode=$MODE, crop=1/2*iw:1/2*ih, scale=$VFORMAT, fade=in:0:50, fade=t=out:st=$FADEOUT:d=27
" $OUTPUT