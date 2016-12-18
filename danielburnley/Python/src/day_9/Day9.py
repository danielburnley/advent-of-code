import re


class Day9:
    def __init__(self):
        self.decompressed_string = ""

    def repeat_string(self, num_of_repeats: int, string: str):
        for i in range(num_of_repeats):
            self.decompressed_string += string

    def decompress_data(self, data):
        decompressing = True
        marker_matcher = re.compile(r'\(\d+x\d+\)')

        while decompressing:
            next_marker = marker_matcher.search(data)
            if not next_marker:
                self.decompressed_string += data
                decompressing = False
            else:
                self.decompressed_string += data[:next_marker.start()]
                marker = data[next_marker.start():next_marker.end()]
                length, num_of_repeats = int(marker[1:marker.find("x")]), int(marker[marker.find("x") + 1:-1])
                data_to_repeat = data[next_marker.end():next_marker.end() + length]
                self.repeat_string(num_of_repeats, data_to_repeat)
                data = data[next_marker.end() + length:]

        return self.decompressed_string