#!/bin/bash

set -e

readonly VERSION="1.0.0"
readonly YOUTUBE_DL_COMMAND="youtube-dl -j --flat-playlist"

# Print usage instructions
function usage {
  echo "Usage: $(basename "$0") playlist_link"
  echo "Fetches video links from a YouTube playlist and groups them by uploader."
}

# Print version number
function version {
  echo "$(basename "$0") version $VERSION"
}

# Fetch video records from the playlist
function fetch_videos {
  local playlist_link="$1"
  local youtube_dl_output="$($YOUTUBE_DL_COMMAND "$playlist_link")"
  echo "$youtube_dl_output"
}

# Group the video records by uploader
function group_by_uploader {
  local youtube_dl_output="$1"
  local jq_expression='group_by(.uploader)
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
  echo "$youtube_dl_output" | jq -s -r "$jq_expression"
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
      exec 1>&2
      echo "Error: incorrect number of arguments"
      usage
      exit 1
    fi
    ;;
esac

function main {
  local playlist_link="$1"
  local youtube_dl_output="$(fetch_videos "$playlist_link")"
  local grouped_output="$(group_by_uploader "$youtube_dl_output")"
  printf "%s\n" "$grouped_output"
}

main "$@"
