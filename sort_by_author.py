"""
INPUT_FILE contains line of following format: 'youtube video url | author | title\n'
OUTPUT_FILE will contain the same lines, but sorted by author
all of the lines that have unique author will appear at the end of the list
those with empty author/title will appear at the end
"""

from sys import stdin
from itertools import groupby

lines = stdin.readlines()
records = [ group.split('\n') for group in ''.join(lines).split('\n\n') if group ]
grouped = [
    list(g) for _, g
        in groupby(
            sorted(records ,key=lambda r: r[1]),
            key=lambda r: r[1]
        )
]
grouped.sort(key=len, reverse=True)
for vid in sum(grouped, []):
    print(' | '.join(vid))
