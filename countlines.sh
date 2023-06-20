#!/bin/bash

display_usage() {
    echo "Usage: $0 [-o <owner>] [-m <month>]"
    echo "Options:"
    echo "  -o <owner>      Select files where the owner is <owner>"
    echo "  -m <month>      Select files where the creation month is <month>"
}

count_lines() {
    file="$1"
    line_count=$(wc -l < "$file")
    echo "File: $file, Lines: $line_count $file"
}

filter_by_owner() {
    owner="$1"
    echo "Looking for files where the owner is: $owner"
    for file in *; do
        if [ -f "$file" ]; then
            file_owner=$(stat -c "%U" "$file")
            if [ "$file_owner" = "$owner" ]; then
                count_lines $file
            fi
        fi
    done
}

filter_by_month() {
    month="$1"
    echo "Looking for files where the month is: $month"
    for file in *; do
        if [ -f "$file" ]; then
            creation_month=$(ls -l --time-style="+%b" "$file" | awk '{print $6}')
            if [ "$creation_month" = "$month" ]; then
                count_lines $file
            fi
        fi
    done
}

# Accept only two arguments
if [ $# -ne 2 ]; then
    display_usage
    exit 1
fi

while getopts ":o:m:" option; do
    case "$option" in
        o) filter_by_owner "$OPTARG" ;;
        m) filter_by_month "$OPTARG" ;;
        *) display_usage; exit 1 ;;
    esac
done