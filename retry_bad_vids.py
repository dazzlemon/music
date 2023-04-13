"""
INPUT FILE for this program is output of extract_vid_info.py
OUTPUT WILL be the same with attempt to resolve unknown authors/titles
"""

from sys import stdin
from pytube import YouTube
from pytube.exceptions import PytubeError

lines = stdin.readlines()
records = [ group.split('\n') for group in ''.join(lines).split('\n\n') if group ]

for i, record in enumerate(records):
    url = record[0]
    print(url)
    if len(record) != 3:
        try:
            vid = YouTube(url)
            print(vid.author)
            print(vid.title)
        except PytubeError:
            pass
    else:
        print(record[1])
        print(record[2])
    print()
