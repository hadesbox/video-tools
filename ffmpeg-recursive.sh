# Twelve stacked 'tblend=all_mode=difference128' filters.
# Deblocking 'spp' and 'average' filters used to mimimise strobing effects.
# Due to latency issues, the result in ffplay will differ from a ffmpeg rendering.

rm -rf "$1_out.mp4"

# ffplay -i video.mp4 -vf "
ffmpeg -i "$1" -vf "
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
   "  "$1_out.mp4"