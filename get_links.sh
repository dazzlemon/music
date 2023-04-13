youtube-dl -j --flat-playlist "https://www.youtube.com/playlist?list=PLmpL10r_giI1ipR20I16Qwa3lEfENtYPv" | jq -r '.id' | sed 's_^_https://youtu.be/_'
