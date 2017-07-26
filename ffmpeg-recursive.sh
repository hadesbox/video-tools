# http://oioiiooixiii.blogspot.com.es/2016/08/ffmpeg-recursive-effects-of-stacking.html
# Twelve stacked 'tblend=all_mode=difference128' filters.
# Deblocking 'spp' and 'average' filters used to mimimise strobing effects.
# Due to latency issues, the result in ffplay will differ from a ffmpeg rendering.

# - all_mode=difference128
# - all_mode=difference
# - all_mode=multiply128
# - all_mode=multiply
# - c0_mode=difference128
# - unknown 'average_test.mkv'
# - unknown 'all_average_test.mkv'
# - unknown 'difference_test.mkv'
# - unknown 'difference128_test.mkv'



rm -rf "$1_out.mp4"

#add       scale=-2:720,     to scale

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