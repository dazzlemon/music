#!/bin/bash

set -e

if [[ "$#" -ne 1 ]]; then
  echo "Usage: $0 playlist_link" >&2
  exit 1
fi

youtube_playlist_link="$1"
youtube_dl_output=$(youtube-dl -j --flat-playlist "$youtube_playlist_link")
count=$(echo "$youtube_dl_output" | grep -c '^{"_type": "url", "ie_key": "Youtube", "id": "')

if [[ "$count" -eq 0 ]]; then
  echo "No video links found." >&2
  exit 1
fi

my_jq_expression='
    group_by(.uploader)
  | map({
      uploader: .[0].uploader,
      videos: [ .[]
              | "https://youtu.be/\(.id) \(.title)"
              ]
    })
  | sort_by(-(.videos | length))
  | .[]
  | "\(.uploader)\n"
  + (.videos | join("\n"))
  + "\n"
'

echo "$youtube_dl_output" | jq -s -r "$my_jq_expression"
