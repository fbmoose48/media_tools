# media_tools
scripts to manage media files via cli
---

This repository contains a collection of helper scripts for audio, video, and cue/FLAC workflows.  
Below is a summary of each script, its purpose, and required dependencies.

---

## flac-split.sh
Splits a single album‑length FLAC into individual tracks using a `.cue` file.  
- **Dependencies:** `shntool`, `cuetools` (`cuebreakpoints.sh`, `cuetag.sh`), `metaflac`, `detox`.

---

## alac2flac.sh
Converts audio files between formats (ALAC → FLAC) using `ffmpeg`.  
- **Dependencies:** `ffmpeg`.

---

## flac2mp3.sh
Converts audio files between formats (FLAC → mp3) using `ffmpeg`, `lame`.  
- **Dependencies:** `ffmpeg`, `lame`.
---

## mp3compress128.sh
Compresses mp3 files to 128kbps.  
- **Dependencies:** `ffmpeg`, `lame`.

---

## vid2mp3con.sh
Convert mp4 to mp3
- **Dependencies:** `ffmpeg`, `lame`.
