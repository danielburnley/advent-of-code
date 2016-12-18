from src.day_9.Day9 import Day9
from src.day_9.Day9V2 import get_decompressed_data_length

data = open('input.txt', 'r').read().strip()
solver = Day9()

print("A:", len(solver.decompress_data(data)))
print("B:", get_decompressed_data_length(data))
