#!/bin/bash
# Smart portable FLAC splitter/tagger/renamer
# Handles detoxed filenames gracefully

# Step 0: Find cue file
CUE=$(ls *.cue 2>/dev/null | head -n1)
if [[ -z "$CUE" ]]; then
    echo "No .cue file found in current directory."
    exit 1
fi

# Step 1: Parse associated FLAC from cue (first FILE line)
ALBUM=$(grep -i '^FILE' "$CUE" | head -n1 | cut -d\" -f2)

# Step 2: Check if referenced FLAC exists
if [[ ! -f "$ALBUM" ]]; then
    echo "Cue references '$ALBUM' but file not found."

    # Normalize the base name (strip spaces, dashes, underscores)
    BASE=$(basename "$ALBUM" .flac)
    NORMALIZED=$(echo "$BASE" | tr -d ' _-')

    # Search for a detoxed candidate that matches normalized base
    DETOXED=$(ls *.flac 2>/dev/null | while read f; do
        NAME=$(basename "$f" .flac | tr -d ' _-')
        [[ "$NAME" == "$NORMALIZED" ]] && echo "$f"
    done | head -n1)

    if [[ -n "$DETOXED" ]]; then
        echo "Using detoxed FLAC: $DETOXED"
        ALBUM="$DETOXED"
    else
        echo "No matching detoxed FLAC found."
        exit 1
    fi
fi

# Step 3: Confirm with user
echo "Cue file:   $CUE"
echo "Album file: $ALBUM"
read -p "Proceed with splitting/tagging? [y/N] " CONFIRM
[[ "$CONFIRM" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 1; }

# Step 3.1: Update cue FILE line to match identified filename
echo "Updating cue file to reference: $ALBUM"
sed -i "s|^FILE .*|FILE \"$ALBUM\" WAVE|" "$CUE"

# Step 4: Split FLAC into tracks
cuebreakpoints "$CUE" | shnsplit -o flac "$ALBUM"

# Step 5: Apply tags
cuetag.sh "$CUE" split-track*.flac

# Step 6: Rename files based on tags
for f in split-track*.flac; do
    TITLE=$(metaflac --show-tag=TITLE "$f" | cut -d= -f2)
    TRACK=$(metaflac --show-tag=TRACKNUMBER "$f" | cut -d= -f2)
    ARTIST=$(metaflac --show-tag=ARTIST "$f" | cut -d= -f2)

    SAFE_TITLE=$(echo "$TITLE" | tr -d '/:"?*<>|')
    NEWNAME="${TRACK} - ${ARTIST} - ${SAFE_TITLE}.flac"

    mv -v "$f" "$NEWNAME"
done

# Step 7: Clean filenames (optional)
detox -r .
