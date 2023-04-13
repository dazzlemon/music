"""
INPUT_FILE contains urls of youtube videos (1 per line)

OUTPUT_FILE will chunks of url, author, title (each on their own line).
The chunks will be split by empty line.
The Author and title may be omitted if unavailable.
"""
from sys import stdin
from pytube import YouTube
from pytube.exceptions import PytubeError

for yt_url in map(lambda u: u.strip(), stdin):
    print(yt_url)
    try:
        yt_vid = YouTube(yt_url)
        print(yt_vid.author)
        print(yt_vid.title)
    except PytubeError:
        # TODO: retry
        pass
    print()
