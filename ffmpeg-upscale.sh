# http://timeinpixels.com/2016/07/upscaling-1080p-videos-youtube-vimeo/
# https://vimeo.com/help/compression



# SWScaler AVOptions:
#   -sws_flags E..V…. scaler flags (default 4)
#      fast_bilinear E..V…. fast bilinear
#      bilinear E..V…. bilinear
#      bicubic E..V…. bicubic
#      experimental E..V…. experimental
#      neighbor E..V…. nearest neighbor
#      area E..V…. averaging area
#      bicublin E..V…. luma bicubic, chroma bilinear
#      gauss E..V…. gaussian
#      sinc E..V…. sinc
#      lanczos E..V…. lanczos
#      spline E..V…. natural bicubic spline
#      print_info E..V…. print info
#      accurate_rnd E..V…. accurate rounding
#      full_chroma_int E..V…. full chroma interpolation
#      full_chroma_inp E..V…. full chroma input
#      bitexact E..V….
#      error_diffusion E..V…. error diffusion dither
#   -srcw E..V…. source width (from 1 to INT_MAX) (default 16)
#   -srch E..V…. source height (from 1 to INT_MAX) (default 16)
#   -dstw E..V…. destination width (from 1 to INT_MAX) (default 16)
#   -dsth E..V…. destination height (from 1 to INT_MAX) (default 16)
#   -src_format E..V…. source format (from 0 to 332) (default 0)
#   -dst_format E..V…. destination format (from 0 to 332) (default 0)
#   -src_range E..V…. source range (from 0 to 1) (default 0)
#   -dst_range E..V…. destination range (from 0 to 1) (default 0)
#   -param0 E..V…. scaler param 0 (from INT_MIN to INT_MAX) (default 123456)
#   -param1 E..V…. scaler param 1 (from INT_MIN to INT_MAX) (default 123456)
#   -src_v_chr_pos E..V…. source vertical chroma position in luma grid/256 (from -1 to 512) (default -1)
#   -src_h_chr_pos E..V…. source horizontal chroma position in luma grid/256 (from -1 to 512) (default -1)
#   -dst_v_chr_pos E..V…. destination vertical chroma position in luma grid/256 (from -1 to 512) (default -1)
#   -dst_h_chr_pos E..V…. destination horizontal chroma position in luma grid/256 (from -1 to 512) (default -1)
#   -sws_dither E..V…. set dithering algorithm (from 0 to 6) (default 1)
#      auto E..V…. leave choice to sws
#      bayer E..V…. bayer dither
#      ed E..V…. error diffusion
#      a_dither E..V…. arithmetic addition dither
#      x_dither E..V…. arithmetic xor dither


#ffmpeg -i $1 -vf scale=1920:1080 $1_1080p.mp4

#ffmpeg -i "$1" -vf scale=1920:1080:flags=neighbor "$1_neighbor_1080p.mp4"


#ffmpeg -i "$1" -an -vf yadif -vf scale=1920:1080 "$1_yadif_none_1080p.mp4"

#ffmpeg -i "$1" -vf yadif -c:v libx264 -preset slow -crf 19 -c:a aac -b:a 256k -an -vf scale=1920:1080 "$1_yadif_1080p.mp4"

#ffmpeg -i "$1" -an -c:v prores -profile:v 3 -vf yadif -vf scale=1920:1080 "$1_yadif_prores_1080p.mov"

ffmpeg -i "$1" -an -c:v prores -profile:v 3 -vf yadif -vf scale=1920:1080:flags=bicubic "$1_yadif_prores_bicubic_1080p.mov"

echo "********************************"
echo "********************************"
echo "********************************"

#ffmpeg -i "$1" -vf scale=1920:1080:flags=spline "$1_spline_1080p.mp4"

#ffmpeg -i $1 -vf scale=-1:1080:flags=neighbor test.mkv