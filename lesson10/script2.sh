#!/bin/bash
TARGET_DIR="$HOME/myfolder"
if [ ! -d "$TARGET_DIR" ]; then
    echo "netu papki myfolder"
    exit 0
fi

FILE_COUNT=$(find "$TARGET_DIR" -maxdepth 1 -type f | wc -l)
echo "myfolder file count: $FILE_COUNT"

if [ -f "$TARGET_DIR/2.txt" ]; then
    chmod 664 "$TARGET_DIR/2.txt"
    echo "prava 2.txt izmeneni"
fi

find "$TARGET_DIR" -maxdepth 1 -type f -empty -delete
echo "empty files deleted"

for file in "$TARGET_DIR"/*; do
    if [ -f "$file" ]; then
        sed -i '2,$d' "$file"
    fi
done

echo "script2 done"
