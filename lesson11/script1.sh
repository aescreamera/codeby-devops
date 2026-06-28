#!/bin/bash
# const
readonly TARGET_DIR="$HOME/myfolder"
readonly STRING_LENGTH=20

# func for creating dir myfolder
create_dir() {
    if ! mkdir -p "$TARGET_DIR"; then
        echo "error while creating dir" >&2
        return 1
    fi
    return 0
}

create_file_1() {
    local FILE_PATH="$TARGET_DIR/1.txt"

    echo "hello bro!" > "$FILE_PATH"
    date +"%Y-%m-%d %H:%M:%S" >> "$FILE_PATH"
    return 0
}

create_file_2() {
    local FILE_PATH="$TARGET_DIR/2.txt"
    if touch "$FILE_PATH" && chmod 777 "$FILE_PATH"; then
        return 0
    else
        echo "error file 2" >&2
        return 1
    fi
}

create_file_3() {
    local FILE_PATH="$TARGET_DIR/3.txt"
    if tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c "$STRING_LENGTH" > "$FILE_PATH"; then
        return 0
    else
        echo "error file 3" >&2
        return 1
    fi
}

create_files_4_5() {
    if touch "$TARGET_DIR/4.txt" "$TARGET_DIR/5.txt"; then
        return 0
    else
        echo "error files 4 5" >&2
        return 1
    fi
}

# main func
main() {
    create_dir
    create_file_1
    create_file_2
    create_file_3
    create_files_4_5

    echo "script1 done"
}

main
