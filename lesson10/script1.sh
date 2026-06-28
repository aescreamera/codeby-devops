#!/bin/bash
TARGET_DIR="$HOME/myfolder"
mkdir -p "$TARGET_DIR"

echo "hello bro!" > "$TARGET_DIR/1.txt"
date +"%Y-%m-%d %H:%M:%S" >> "$TARGET_DIR/1.txt"

touch "$TARGET_DIR/2.txt"
chmod 777 "$TARGET_DIR/2.txt"

tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 20 > "$TARGET_DIR/3.txt"

touch "$TARGET_DIR/4.txt"
touch "$TARGET_DIR/5.txt"

echo "script1 done"
