"""
INPUT_FILE contains urls of youtube videos (1 per line)

OUTPUT_FILE will chunks of url, author, title (each on their own line).
The chunks will be split by empty line.
The Author and title may be omitted if unavailable.
"""
from sys import stdin
from pytube import YouTube
from pytube.exceptions import PytubeError

def ytvid_author_and_title(url):
    """
    Returns author and title of youtube video by its link.
    Both can be None
    """
    try:
        yt_vid = YouTube(url)
        return (yt_vid.author, yt_vid.title)
    except PytubeError:
        return (None, None)

for yt_url in map(lambda u: u.strip(), stdin):
    (author, title) = ytvid_author_and_title(yt_url)
    print(yt_url)
    if author is not None:
        print(author)
    if title is not None:
        print(title)
    print()
