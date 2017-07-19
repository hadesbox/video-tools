#!/bin/bash

# Create Predator [1987 movie] "Adaptive Camo" chromakey effect in FFmpeg
# - Takes arguments: filename, colour hex value (defaults to green).
# ver. 2017.06.25.16.29.43
# source: http://oioiiooixiii.blogspot.com

function setDimensionValues() # Sets global size variables based on file source 
{
   dimensions="$(\
      ffprobe \
      -v error \
      -show_entries stream=width,height \
      -of default=noprint_wrappers=1 \
      "$1"\
   )"
      
   # Create "$height" and "$width" var vals
   eval "$(head -1 <<<"$dimensions");$(tail -1 <<<"$dimensions")"
}

function buildFilter() # Builds filter using core filterchain inside for-loop
{
   # Set video dimensions and key colour
   setDimensionValues "$1"
   colour="0x${2:-00FF00}"
   oWidth="$width"
   oHeight="$height"
   
   # Arbitary scaling values - adjust to preference
   for ((i=0;i<4;i++))
   {
      width="$((width-100))"
      height="$((height-50))"
      printf "split[a][b];
            [a]chromakey=$colour:0.3:0.06[keyed];
            [b]scale=$width:$height:force_original_aspect_ratio=decrease,
               pad=$oWidth:$oHeight:$((width/4)):$((height/4))[b];
            [b][keyed]overlay,"
   }
   printf "null" # Deals with hanging , character in filtergraph
}

# Generate output
ffplay -i "$1" -vf "$(buildFilter "$@")"
#ffmpeg -i "$1" -vf "$(buildFilter "$@")" -an "${1}_predator-fx.mkv"