"""
INPUT_FILE contains line of following format: 'youtube video url | author | title\n'
OUTPUT_FILE will contain the same lines, but sorted by author
all of the lines that have unique author will appear at the end of the list
those with empty author/title will appear at the end
"""

from itertools import islice

INPUT_FILE = 'to_download3.log'
OUTPUT_FILE = 'to_download4.log'

with open(INPUT_FILE, encoding='utf-8') as input_file:
    lines = input_file.readlines()
    records = map(lambda line: line.strip().split(' | '), lines)
    print(islice(records, 30))
