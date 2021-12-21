colors="FF0000 00FF00 0000FF"
for color in ${colors}; do
  ffmpeg -y -f lavfi -i nullsrc=s=512x512 -filter_complex color=${color} -r 30 -frames:v 3000 -c:v libx264 -preset fast -g 25 -movflags faststart+frag_keyframe+empty_moov+default_base_moof -tune fastdecode ${color}.mp4
  python3 -m tator.transcode.make_fragment_info -o ${color}.json ${color}.mp4
done

ffmpeg -y -f lavfi -i nullsrc -filter_complex "color=white[s];[s]fps=30[r];[r]drawtext=fontfile=FreeSans.ttf: text='Frame=%{frame_num}': x=20: y=20: fontcolor=black: fontsize=32: box=1: boxcolor=white: boxborderw=10" -frames:v 1000 -c:v libx264 -preset fast -g 25 -movflags faststart+frag_keyframe+empty_moov+default_base_moof -tune fastdecode count.mp4
python3 -m tator.transcode.make_fragment_info -o count.json count.mp4
echo "Checking OCR status of video"
python3 frame_to_text.py count.mp4