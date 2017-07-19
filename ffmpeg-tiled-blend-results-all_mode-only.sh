#!/bin/bash
################################################################################
# Generate an image of tiled results from all of FFmpeg's 'blend' filter types
# ( Only ouputs 'all_mode' blend results. )
# - takes two images as input (identical dimensions not necessary)

# version: 2017.01.11.20.47.18
# source: http://oioiiooixiii.blogspot.com
################################################################################

# Array of all blend types
declare -a blend=('addition' 'addition128' 'and' 'average' 'burn'
'darken' 'difference' 'difference128' 'divide' 'dodge' 'freeze'
'exclusion' 'glow' 'hardlight' 'hardmix' 'heat' 'lighten' 'linearlight'
'multiply' 'multiply128' 'negation' 'normal' 'or' 'overlay' 'phoenix'
'pinlight' 'reflect' 'screen' 'softlight' 'subtract' 'vividlight' 'xor'
)

# Set dimensions for blend tests (square ratio for simplicity in formating)
scale="scale=320x320,setsar=1/1"

# Set pixel format for blends
format="format=rgb24"

# Generic font filter
fontStyle=\
"
   fontfile=/usr/share/fonts/truetype/freefont/FreeSansBold.ttf:
   fontcolor=white: 
   fontsize=32: 
   borderw=1: 
   x=(w-text_w)/2:
   y=(h-text_h)-10
"

# for loop to build filters with filter types array
for (( i=0; i<"${#blend[@]}"; i++ ))
{
   filter="${filter}
      [0:v] $scale, 
         $format [aall];
      [1:v] $scale, 
         $format [ball];
      [aall][ball] blend=all_mode=${blend[i]},
         $format,
         drawtext=text='${blend[i]}': $fontStyle [all${blend[i]}];
      "
}

# Create originals section
filter="${filter}
   [0:v] $scale, 
      drawtext=text='Input A': $fontStyle [a];
   [1:v] $scale, 
      drawtext=text='Input B': $fontStyle,
      pad=0:ih*2:0:0:black [b];
   [a][b] vstack [originals];
"

# Create first column
filter="${filter}
   [originals][all${blend[0]}][all${blend[1]}] vstack=inputs=3 [col0];
"

# Bootstrap other columns
filter="${filter}
   [all${blend[2]}] null [col1];
   [all${blend[7]}] null [col2];
   [all${blend[12]}] null [col3];
   [all${blend[17]}] null [col4];
   [all${blend[22]}] null [col5];
   [all${blend[27]}] null [col6];
"

# Build columns
for (( i=3; i<7; i++ ))
{
   filter="$filter
   [col1][all${blend[i]}] vstack [col1];
   [col2][all${blend[i+5]}] vstack [col2];
   [col3][all${blend[i+10]}] vstack [col3];
   [col4][all${blend[i+15]}] vstack [col4];
   [col5][all${blend[i+20]}] vstack [col5];
   [col6][all${blend[i+25]}] vstack [col6];
   "
}

# Merge columns
filter="${filter}
[col0][col1][col2][col3][col4][col5][col6] hstack=inputs=7,
"

# Add title to final image [just to make use of black space]
# N.B. newline characters '\n' not working
filter="${filter}
   drawtext=text=
FFmpeg
\"blend\" filter
(all_mode)
$format:
   fontfile=/usr/share/fonts/truetype/freefont/FreeSansBold.ttf:
   fontcolor=white: 
   fontsize=38: 
   borderw=1: 
   x=w/52:
   y=h/2.20
"

#### BEGIN #####################################################################

ffmpeg \
   -i "$1" \
   -i "$2" \
   -filter_complex "$filter" \
   "blend_${1}-${2}.png" \
   -y