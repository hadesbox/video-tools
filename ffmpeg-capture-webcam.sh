# To list devices 
# v4l2-ctl --list-devices   OR
# To list device capabilities
# ffmpeg -f v4l2 -list_formats all -i /dev/video0

# To capture/encode
ffmpeg -f v4l2 -framerate 25 -video_size 640x480 -i /dev/video0 output.mkv


# To view
#ffplay -f v4l2 -list_formats all -i /dev/video0