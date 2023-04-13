"""
INPUT_FILE contains line of following format: 'youtube video url | author | title\n'
OUTPUT_FILE will contain the same lines, but sorted by author
all of the lines that have unique author will appear at the end of the list
those with empty author/title will appear at the end
"""

from sys import stdin
from itertools import groupby
from more_itertools import partition

lines = stdin.readlines()
records = [ group.split('\n') for group in ''.join(lines).split('\n\n') if group ]


records_with_unique_author, records_with_non_unique_author = partition(
  lambda r: len(list(filter(lambda other_r: other_r[1] == r[1], records))) > 1,
  records
)

sorted_records_with_non_unique_author = list(records_with_non_unique_author)
sorted_records_with_non_unique_author.sort(key=lambda r: r[1])

def record_to_line(record):
    """
    Util function to convert record to line
    """
    return ' | '.join(record)

grouped_non_unique = [
    list(g) for _, g
        in groupby(
            sorted_records_with_non_unique_author,
            key=lambda r: r[1]
        )
]

grouped_non_unique.sort(key=len, reverse=True)

for vid in sum(grouped_non_unique, []):
    print(record_to_line(vid))

for vid in records_with_unique_author:
    print(record_to_line(vid))
