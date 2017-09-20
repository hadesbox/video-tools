
ffmpeg -i $1 -i $2 -codec copy -shortest $1_with_audio.mp4
