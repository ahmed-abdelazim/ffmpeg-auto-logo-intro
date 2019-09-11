mkdir -p output
CURRENT=$PWD
ffmpeg -i intro.mp4 -r 30 -c:v libx265 -c:a libmp3lame -crf 22 -preset ultrafast -c:a libmp3lame intro-converted.mp4
ffmpeg -i outro.mp4 -r 30 -c:v libx265 -c:a libmp3lame -crf 22 -preset ultrafast -c:a libmp3lame outro-converted.mp4
cd input
for f in *.mp4
do
cd input
ffmpeg -i $f -i ../overlay.png \
-filter_complex "[1:v]scale=520:-1,format=rgba,colorchannelmixer=aa=0.5[fg];[0][fg]overlay=1380:920:enable='between(t,0,20)'" \
-r 30 -pix_fmt yuv420p -c:v libx265 -preset ultrafast -crf 22  -c:a libmp3lame \
temp-$f
echo "file 'intro-converted.mp4'" > ../list.txt
echo "file 'input/temp-$f'" >> ../list.txt
echo "file 'outro-converted.mp4'" >> ../list.txt
echo $PWD
echo $f
cd $CURRENT
ffmpeg -f concat -safe 0 -i list.txt -r 30 -pix_fmt yuv420p -c:v libx264 -preset ultrafast -crf 22  -c:a libmp3lame output/$f
#rm input/temp-$f
done
rm list.txt
rm input/temp-*
rm output/temp-*
