my_jq_expression='
    group_by(.uploader)
  | map({
      uploader: .[0].uploader,
      videos: [.[]
              | "https://youtu.be/\(.id) \(.title | @sh)"
              ]
    })
  | sort_by(-(.videos | length))
  | .[]
  | "\(.uploader)\n\(.videos[])\n"
'

youtube-dl \
  -j \
	--flat-playlist \
	"https://www.youtube.com/playlist?list=PLmpL10r_giI1ipR20I16Qwa3lEfENtYPv" \
| jq \
    -s \
    "$my_jq_expression"

