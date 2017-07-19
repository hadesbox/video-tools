#!/bin/bash
################################################################################
# Generate an image of tiled results from all of FFmpeg's 'blend' filter types
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
   fontsize=24: 
   borderw=1: 
   x=(w-text_w)/2:
   y=(h-text_h)-10
"

# Create originals row
filter=\
"
   [0:v] $scale, 
      drawtext=text='Input A': $fontStyle,
      pad=iw*2.5:0:ow-iw:0:black [a];
   [1:v] $scale, 
      drawtext=text='Input B': $fontStyle,
      pad=iw*2.5:0:0:0:black [b];
   [a][b] hstack [originals];
"

# for loop to build filters with filter types array
for (( i=0; i<"${#blend[@]}"; i++ ))
{
   filter="${filter}
      [0:v] $scale, $format, split=5 [ac0][ac1][ac2][ac3][aall];
      [1:v] $scale, $format, split=5 [bc0][bc1][bc2][bc3][ball];
      [ac0][bc0] blend=c0_mode=${blend[i]}, 
         $format,
         drawtext=text='c0|${blend[i]}': $fontStyle [c0];
      [ac1][bc1] blend=c1_mode=${blend[i]},
         $format,
         drawtext=text='c1|${blend[i]}': $fontStyle [c1];
      [c0][c1] hstack [c0c1];
      [ac2][bc2] blend=c2_mode=${blend[i]},
         $format,
         drawtext=text='c2|${blend[i]}': $fontStyle [c2];
      [c0c1][c2] hstack [c0c1c2];
      [ac3][bc3] blend=c3_mode=${blend[i]},
         $format,
         drawtext=text='c3|${blend[i]}': $fontStyle [c3];
      [c0c1c2][c3] hstack [c0c1c2c3];
      [aall][ball] blend=all_mode=${blend[i]},
         $format,
         drawtext=text='all|${blend[i]}': $fontStyle [all];
      [c0c1c2c3][all] hstack [row${blend[i]}];
      "
}

# Create and stack column 1 of blend results
filter="${filter} [originals][row${blend[0]}] vstack [col1];"
for (( i=1; i<10; i++ ))
{
   filter="${filter} [col1][row${blend[i]}] vstack [col1];"
}

# Create and stack column 2 of blend results
filter="${filter} [row${blend[10]}][row${blend[11]}] vstack [col2];"
for (( i=12; i<21; i++ ))
{
   filter="${filter} [col2][row${blend[i]}] vstack [col2];"
}
filter="${filter} [col1][col2] hstack [stacked];"

# Create and stack column 3 of blend results
filter="${filter} [row${blend[21]}][row${blend[22]}] vstack [col3];"
for (( i=23; i<32; i++ ))
{
   filter="${filter} [col3][row${blend[i]}] vstack [col3];"
}
filter="${filter} [stacked][col3] hstack"

### BEGIN ######################################################################

ffmpeg \
   -i "$1" \
   -i "$2" \
   -filter_complex "$filter" \
   "blend_${1}-${2}.png" \
   -y