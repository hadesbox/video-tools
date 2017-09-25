# ffplay used for testing; filtergraph can be directly inserted into ffmpeg

ffpl -f v4l2 -i /dev/video0 \
   -vf\
      "split=3[r][g][b];\
      nullsrc=size=640x360[base1];\
      nullsrc=size=640x360[base2];\
      nullsrc=size=640x360[base3];\
      [r]lutrgb=g=0:b=0[red];\
      [g]lutrgb=r=0:b=0[green];\
      [b]lutrgb=r=0:g=0[blue];\
      [base1][red]overlay=x=10:shortest=1,format=rgb24[x];\
      [base2][green]overlay=x=0:shortest=1,format=rgb24[y];\
      [base3][blue]overlay=y=10:shortest=1,format=rgb24[z];\
      [x][y]blend=all_mode='addition'[xy];\
      [xy][z]blend=all_mode='addition'[xyz];\
      [xyz]crop=630:350:10:10,scale=640:360:out_color_matrix=bt709" salida_aberration.avi

# 'format=rgb24' needs to be included to stop overlaying layers as YUV
# 'scale=out_color_matrix=bt709' for correct RGB to YUV colourspace conversion
# 'crop & scale' at end to remove border areas missing full RGB data




#  20px Y horizontal offset, 10px V vertical offset

# ffplay\
#   -i short.mkv\
#   -vf\
#      "split=3[y][u][v];\
#      nullsrc=size=640x360[base1];\
#      nullsrc=size=640x360[base2];\
#      nullsrc=size=640x360[base3];\
#      [y]lutyuv=u=0:v=0[Yaxis];\
#     [u]lutyuv=v=0:y=0[Uaxis];\
#      [v]lutyuv=u=0:y=0[Vaxis];\
#      [base1][Yaxis]overlay=x=20:shortest=1[x];\
#      [base2][Uaxis]overlay=x=0:shortest=1[y];\
#      [base3][Vaxis]overlay=y=20:shortest=1[z];\
#      [x][y]blend=all_mode='lighten'[xy];\
#      [xy][z]blend=all_mode='lighten'[xyz];\
#      [xyz]crop=620:340:20:20,scale=640:480"

# 'format=rgb24' & 'scale=out_color_matrix=bt709' are omitted from YUV version