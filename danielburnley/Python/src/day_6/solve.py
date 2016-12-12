from src.day_6.Day6 import Day6

data = open('input.txt', 'r').read().split("\n")
solver = Day6()

print(solver.get_corrected_message(data))
print(solver.get_corrected_message(data, True))
