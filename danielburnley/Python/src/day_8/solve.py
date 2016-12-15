from src.day_8.Day8 import Day8

commands = open('input.txt', 'r').read().split("\n")
solver = Day8(50, 6)
solver.run_commands(commands)
print("Number on:", solver.count_on_pixels())
solver.print_screen()