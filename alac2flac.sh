#!/bin/bash

# Recursively find all .m4a files and convert them to FLAC
find . -type f -name "*.m4a" | while read -r f; do
    echo "Converting: $f"
    ffmpeg -i "$f" -c:a flac "${f%.m4a}.flac"
    if [ $? -eq 0 ]; then
        echo "Conversion successful, removing original: $f"
        rm "$f"
    else
        echo "Conversion failed for: $f"
    fi
done
