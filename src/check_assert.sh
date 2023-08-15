#!/bin/bash

if [ ! -d "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
else
    dest_dir="$1"
fi

find "$dest_dir" -mindepth 1 -maxdepth 1 -type d | while IFS= read -r student; do
    echo "$student"
    # NOTE: 現状の実装では、assert文に引っかかったか否かのみ判定している。
    # もっと詳細にassert文がそれぞれ通ったか確認するには、pytest等でラップする必要がある。
    python "$student"/import_all.py > "$student"/$(basename "$student")_results.txt
done
