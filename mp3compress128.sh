#!/bin/bash

# compress mp3 to 128kbps

# Requires
# ffmpeg installed
# lame installed

for file in *.mp3; do lame --preset 128 -ms -h "$file"; done

for i in *.mp3.mp3 ; do
n=`basename "$i" .mp3.mp3`
mv "$i" "$n".mp3
done
