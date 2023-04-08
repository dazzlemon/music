"""
INPUT_FILE contains line of following format: 'youtube video url | author | title\n'
OUTPUT_FILE will contain the same lines, but sorted by author
all of the lines that have unique author will appear at the end of the list
those with empty author/title will appear at the end
"""

from more_itertools import partition

INPUT_FILE = 'to_download3.log'
OUTPUT_FILE = 'to_download4.log'

with open(INPUT_FILE, encoding='utf-8') as input_file:
    lines = input_file.readlines()
    records = map(lambda line: line.strip().split(' | '), lines)

    bad_records, normal_records = partition(
        lambda r: len(r) == 3,
        records
    )

    normal_records_list = list(normal_records)

    records_with_unique_author, records_with_non_unique_author = partition(
      lambda r: len(list(filter(lambda other_r: other_r[1] == r[1], normal_records_list))) > 1,
      normal_records_list
    )

    sorted_records_with_non_unique_author = list(records_with_non_unique_author)
    sorted_records_with_non_unique_author.sort(key=lambda r: r[1])

    # some are still okay, just split poorly
    sorted_bad_records = list(bad_records)
    sorted_bad_records.sort(key=lambda r: r[1])

    def record_to_line(record):
        """
        Util function to convert record to line
        """
        return ' | '.join(record) + '\n'

    with open(OUTPUT_FILE, 'w+', encoding='utf-8') as output_file:
        output_file.writelines(map(record_to_line, sorted_records_with_non_unique_author))
        output_file.writelines(map(record_to_line, sorted_bad_records))
        output_file.writelines(map(record_to_line, records_with_unique_author))
