import re


def get_decompressed_data_length(data):
    marker_matcher = re.compile(r'\(\d+x\d+\)')
    length = 0
    if not marker_matcher.search(data):
        return len(data)
    while marker_matcher.search(data):
        next_marker = marker_matcher.search(data)
        data_length = next_marker.start()
        marker = [int(x) for x in data[next_marker.start() + 1:next_marker.end() - 1].split('x')]
        data = data[next_marker.end():]
        if marker_matcher.search(data[:marker[0]]):
            length += data_length + get_decompressed_data_length(data[:marker[0]]) * marker[1]
        else:
            length += data_length + (marker[0] * marker[1])
        data = data[marker[0]:]
    length += len(data)
    return length