ffmpeg -i $1 -i $2 -vf "tblend=all_mode=difference128" $3
