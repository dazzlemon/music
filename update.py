"""
input
    file1 with youtube urls, one per line
		file2 with chunks in form: url, author, title (each on separate line),
		    chunks are separated by empty lines
output
    file2 with chunks that arent in file1 removed, and new chunks from file1 appended
"""

import argparse
from pytube import YouTube
from pytube.exceptions import PytubeError

parser = argparse.ArgumentParser(description='Read contents of two files')
parser.add_argument('links', type=str, help='the first file to read from')
parser.add_argument('links_with_metadata', type=str, help='the second file to read from')
parser.add_argument('links_with_metadata_output', type=str, help='the third file')
args = parser.parse_args()

with open(args.links, 'r', encoding='UTF-8') as links_file:
    links = list(map(lambda r: r.strip(), links_file.readlines()))
with open(args.links_with_metadata, 'r', encoding='UTF-8') as links_with_metadata_file:
    links_with_metadata = links_with_metadata_file.readlines()
links_with_metadata = [
    group.split('\n') for group in ''.join(links_with_metadata).split('\n\n') if group ]

print(f'input links count: {len(links)}')
print(f'sorted links count: {len(links_with_metadata)}')

links_with_metadata = list(filter(
    lambda r: r[0] in links,
    links_with_metadata
))

print(f'sorted links count: {len(links_with_metadata)}')

already_resolved_links = list(map(lambda r: r[0], links_with_metadata))
links_to_resolve = list(filter(lambda url: url not in already_resolved_links, links))
for i, url in enumerate(links_to_resolve):
    print(f'resolving link {i}/{len(links_to_resolve)}')
    while True:
        try:
            vid = YouTube(url)
            links_with_metadata.append((url, vid.author, vid.title))
            break
        except PytubeError:
            print('retry')

print(f'sorted links count: {len(links_with_metadata)}')

with open(args.links_with_metadata_output, 'w', encoding='UTF-8') \
        as links_with_metadata_output_file:
    for vid in links_with_metadata:
        links_with_metadata_output_file.write(f'{vid[0]}\n')
        links_with_metadata_output_file.write(f'{vid[1]}\n')
        links_with_metadata_output_file.write(f'{vid[2]}\n')
        links_with_metadata_output_file.write('\n')
