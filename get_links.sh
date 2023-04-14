#!/bin/bash

set -e

VERSION="1.0.0"

function usage {
  echo "Usage: $(basename "$0") playlist_link"
  echo "Fetches video links from a YouTube playlist and groups them by uploader."
}

function version {
  echo "$(basename "$0") version $VERSION"
}

if [[ "$#" -ne 1 ]]; then
  exec 1>&2
  usage
	exit 1
fi

if [[ "$1" == "--version" ]]; then
  version
  exit 0
fi

if [[ "$1" == "--help" ]]; then
  usage
	exit 0
fi

youtube_playlist_link="$1"
youtube_dl_output=$(youtube-dl -j --flat-playlist "$youtube_playlist_link")
count=$(echo "$youtube_dl_output" | grep -c '^{"_type": "url", "ie_key": "Youtube", "id": "')

if [[ "$count" -eq 0 ]]; then
  echo "No video links found." >&2
  exit 1
fi

my_jq_expression='group_by(.uploader)
                | map({ uploader: .[0].uploader
								      , videos: [ .[]
                                | "https://youtu.be/\(.id) \(.title)"
                                ]
                      }
										 )
                | sort_by(-(.videos | length))
                | .[]
                | "\(.uploader)\n"
                  + (.videos | join("\n"))
                  + "\n"
'

printf '%s\n' "$youtube_dl_output" | jq -s -r "$my_jq_expression"
