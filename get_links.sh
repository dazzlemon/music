#!/bin/bash

if [[ $# -ne 1 ]]; then
  echo "Usage: $(basename "$0") playlist_link" >&2
  exit 1
fi

youtube-dl -j --flat-playlist "$1" | jq -sr '
  group_by(.uploader) |
  map({
    uploader: .[0].uploader,
    videos: [ .[] | "https://youtu.be/\(.id) \(.title)" ]
  }) |
  sort_by(-(.videos | length)) |
  .[] |
  "\(.uploader)\n" + (.videos | join("\n")) + "\n"
'
