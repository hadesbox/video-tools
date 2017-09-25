# Generate video motion vectors, in various colours, and merge together
# NB: Includes fixed 'curve' filters for issue outlined in blog post

ffmpeg \
   -flags2 +export_mvs \
   -i $1 \
   -vf \
      "
         split=3 [original][original1][vectors];
         [vectors] codecview=mv=pf+bf+bb [vectors];
         [vectors][original] blend=all_mode=difference128,
            eq=contrast=7:brightness=-0.3,
            split=3 [yellow][pink][black];
         [yellow] curves=r='0/0 0.1/0.5 1/1':
                         g='0/0 0.1/0.5 1/1':
                         b='0/0 0.4/0.5 1/1' [yellow];
         [pink] curves=r='0/0 0.1/0.5 1/1':
                       g='0/0 0.1/0.3 1/1':
                       b='0/0 0.1/0.3 1/1' [pink];
         [original1][yellow] blend=all_expr=if(gt(X\,Y*(W/H))\,A\,B) [yellorig];
         [pink][black] blend=all_expr=if(gt(X\,Y*(W/H))\,A\,B) [pinkblack];
         [pinkblack][yellorig]blend=all_expr=if(gt(X\,W-Y*(W/H))\,A\,B)
      " \
    "$1_out.mp4"

# Process:
# 1: Three copies of input video are made
# 2: Motion vectors are applied to one stream
# 3: The result of #2 is 'difference128' blended with an original video stream
#    The brightness and contrast are adjusted to improve clarity
#    Three copies of this vectors result are made
# 4: Curves are applied to one vectors stream to create yellow colour
# 5: Curves are applied to another vectors stream to create pink colour
# 6: Original video stream and yellow vectors are combined diagonally
# 7: Pink vectors stream and original vectors stream are combined diagonally
# 8: The results of #6 and #7 are combined diagonally (opposite direction)


# try with https://www.youtube.com/watch?v=Djdm7NaQheU