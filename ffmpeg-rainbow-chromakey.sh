#!/bin/bash

# Generate ['Scanimate' inspired] rainbow trail video effect with FFmpeg
# (N.B. Resource intensive - consider multiple passes for longer trails) 
# version: 2017.08.08.13.47.31
# source: http://oioiiooixiii.blogspot.com

function rainbowFilter() #1:delay 2:keytype 3:color 4:sim val 5:blend 6:loop num
{
   local delay="PTS+${1:-0.1}/TB" # Set delay between video instances
   local keyType="${2:-colorkey}" # Select between 'colorkey' and 'chromakey'
   local key="0x${3:-000000}"     # 'key colour
   local chromaSim="${4:-0.1}"    # 'key similarity level
   local chromaBlend="${5:-0.4}"  # 'key blending level
   local colourReset="colorchannelmixer=2:2:2:2:0:0:0:0:0:0:0:0:0:0:0:0
                     ,smartblur"
   # Reset colour after each colour change (stops colours heading to black)
   # 'smartblur' to soften edges caused by setting colours to white

   # Array of rainbow colours. Ideally, this could be generated algorithmically
   local colours=(
      "2:0:0:0:0:0:0:0:2:0:0:0:0:0:0:0" "0.5:0:0:0:0:0:0:0:2:0:0:0:0:0:0:0"
      "0:0:0:0:0:0:0:0:2:0:0:0:0:0:0:0" "0:0:0:0:2:0:0:0:0:0:0:0:0:0:0:0"
      "2:0:0:0:2:0:0:0:0:0:0:0:0:0:0:0" "2:0:0:0:0.5:0:0:0:0:0:0:0:0:0:0:0"
      "2:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0"
   )

   # Generate body of filtergraph (default: 7 loops. Also, colour choice mod 7)
   for (( i=0;i<${6:-7};i++ ))
   {
      local filter=" $filter
                     [a]$colourReset,
                        colorchannelmixer=${colours[$((i%7))]},
                        setpts=$delay,
                        split[a][c];
                     [b]colorkey=${key}:${chromaSim}:${chromaBlend}[b];
                     [c][b]overlay[b];"
   }
   printf "split [a][b];${filter}[a][b]overlay"
}

ffmpeg -i "$1" -vf "$(rainbowFilter)" -c:v huffyuv "${1}_rainbow.avi"

# try using https://www.youtube.com/watch?v=god7hAPv8f0