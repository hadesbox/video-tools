# Basic FFmpeg chromakey filter command - see also: 'colorkey'

ffmpeg \
   -i baselayer.mkv \
   -i overlay.mkv \
   -filter_complex \
      "[1:v]chromakey=green:0.1:0.5[keyed];\
       [0:v][keyed]overlay[out]" \
   -map "[out]" \
   output.mkv