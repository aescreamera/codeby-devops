#!/bin/bash
readonly TARGET_DIR="$HOME/myfolder"
readonly FILE_2_PATH="$TARGET_DIR/2.txt"
readonly FILE_2_PERMISSIONS="664"

check_dir() {
    if [ ! -d "$TARGET_DIR" ]; then
        echo "netu papki myfolder"
        exit 0
    fi
    return 0
}

count_files() {
    FILE_COUNT=$(find "$TARGET_DIR" -maxdepth 1 -type f | wc -l)
    echo "myfolder file count: $FILE_COUNT"
}

change_permissions() {
    if [ -f "$FILE_2_PATH" ]; then
        chmod "$FILE_2_PERMISSIONS" "$FILE_2_PATH"
        echo "prava 2.txt izmeneni"
    fi
}

clear_files() {
    find "$TARGET_DIR" -maxdepth 1 -type f -empty -delete
    echo "empty files deleted"

    for file in "$TARGET_DIR"/*; do
        if [ -f "$file" ]; then
            sed -i '2,$d' "$file"
        fi
    done
}

main () {
    check_dir
    count_files
    change_permissions
    clear_files

    echo "script2 done"
}

main
