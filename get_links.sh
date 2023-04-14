#!/bin/bash

set -e

VERSION="1.0.0"
YOUTUBE_DL_COMMAND="youtube-dl -j --flat-playlist"

# Print usage instructions
function usage {
  echo "Usage: $(basename "$0") playlist_link"
  echo "Fetches video links from a YouTube playlist and groups them by uploader."
}

# Print version number
function version {
  echo "$(basename "$0") version $VERSION"
}

# Parse command-line arguments
case "$1" in
  --version)
    version
    exit 0
    ;;
  --help)
    usage
    exit 0
    ;;
  *)
    if [[ $# -ne 1 ]]; then
      echo "Error: incorrect number of arguments"
      usage
      exit 1
    fi
    ;;
esac

# Fetch video links from the playlist
youtube_playlist_link="$1"
youtube_dl_output=$($YOUTUBE_DL_COMMAND "$youtube_playlist_link")
count=$(echo "$youtube_dl_output" | grep -c '^{"_type": "url", "ie_key": "Youtube", "id": "')
if [[ "$count" -eq 0 ]]; then
  echo "No video links found." >&2
  exit 1
fi

# Parse the output and group the videos by uploader
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

# Print the formatted output
printf '%s\n' "$youtube_dl_output" | jq -s -r "$my_jq_expression"
