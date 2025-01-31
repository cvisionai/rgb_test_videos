
function make_color_video()
{
  color=$1
  resolution=$2
  ffmpeg -y -f lavfi -i nullsrc -filter_complex color=${color}:s=${resolution}x${resolution} -r 1 -frames:v 90000 -c:v libx264 -preset fast -g 25 -movflags faststart+frag_keyframe+empty_moov+default_base_moof -tune fastdecode ${color}.mp4
  python3 -m tator.transcode.make_fragment_info -o ${color}.json ${color}.mp4
}

make_color_video FF0000 1080
make_color_video 00FF00 720
make_color_video 0000FF 360


ffmpeg -y -f lavfi -i nullsrc -filter_complex "color=white:s=720x720[s];[s]fps=30[r];[r]drawtext=fontfile=FreeSans.ttf: text='Frame=%{frame_num}': x=20: y=20: fontcolor=black: fontsize=32: box=1: boxcolor=white: boxborderw=10" -frames:v 1000 -c:v libx264 -preset fast -g 25 -movflags faststart+frag_keyframe+empty_moov+default_base_moof -tune fastdecode count.mp4
python3 -m tator.transcode.make_fragment_info -o count.json count.mp4

ffmpeg -y -i count.mp4 -vf scale=-2:360 -c:v libx264 -preset fast -g 25 -movflags faststart+frag_keyframe+empty_moov+default_base_moof -tune fastdecode count_360.mp4
ffmpeg -y -i count.mp4  -c:v libx264 -preset fast -g 25 -movflags faststart+frag_keyframe+empty_moov+default_base_moof -tune fastdecode -r 1 count_1fps.mp4
python3 -m tator.transcode.make_fragment_info -o count_360.json count_360.mp4

echo "Checking OCR status of video"
python3 frame_to_text.py count.mp4
python3 frame_to_text.py count_360.mp4
