# Basic FFmpeg chromakey filter command - see also: 'colorkey'

# $1 is baselayer
# $2 is overlay
# $3 is output
ffmpeg \
   -i "$1" \
   -i "$2" \
   -filter_complex \
      "[1:v]chromakey=green:0.1:0.5[keyed];\
       [0:v][keyed]overlay[out]" \
   -map "[out]" \
   -vf "
      tblend=all_mode=difference128,
      tblend=all_mode=difference128,
      tblend=all_mode=difference128,
      spp=4:10,
      tblend=all_mode=average,
      tblend=all_mode=difference128,
      tblend=all_mode=difference128,
      tblend=all_mode=difference128,
      spp=4:10,
      tblend=all_mode=average,
      tblend=all_mode=difference128,
      tblend=all_mode=difference128,
      tblend=all_mode=difference128,
      spp=4:10,
      tblend=all_mode=average,
      tblend=all_mode=difference128,
      tblend=all_mode=difference128,
      tblend=all_mode=difference128 
   " \
   "$3"