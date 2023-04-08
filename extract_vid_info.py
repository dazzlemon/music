"""
INPUT_FILE contains urls of youtube videos (1 per line)

OUTPUT_FILE will contain records of youtube video urls, author and title
1 per line sorted by authors
"""
from pytube import YouTube
from pytube.exceptions import PytubeError

INPUT_FILE = 'to_download2.log'
OUTPUT_FILE = 'to_download3.log'

def yt_url_to_datastring(url):
    """
    maps youtube video url to string in format: 'url | author | title\n'
    """
    try:
        yt_vid = YouTube(url.strip())

        return f'{url.strip()} | {yt_vid.author} | {yt_vid.title}\n'
    except PytubeError:
        return f'{url.strip()} |  |  \n'

with open(INPUT_FILE, encoding='utf-8') as input_file:
    yt_urls = input_file.readlines()
    yt_records = map(yt_url_to_datastring, yt_urls)
    with open(OUTPUT_FILE, 'w+', encoding='utf-8') as output_file:
        output_file.writelines(yt_records)
