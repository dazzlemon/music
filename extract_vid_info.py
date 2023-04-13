"""
INPUT_FILE contains urls of youtube videos (1 per line)

OUTPUT_FILE will contain records of youtube video urls, author and title
1 per line sorted by authors
"""
from sys import stdin
from pytube import YouTube
from pytube.exceptions import PytubeError

def ytvid_author_and_title(url):
    """
    returns author and title of youtube video by its link
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
