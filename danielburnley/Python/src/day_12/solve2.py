from src.day_12.speedy_execute import execute
part_a_registers = {'a': 0, 'b': 0, 'c': 0, 'd': 0}
part_b_registers = {'a': 0, 'b': 0, 'c': 1, 'd': 0}
program = [(0, 1, 'a'), (0, 1, 'b'), (0, 26, 'd'), (3, 'c', 2), (3, 1, 5), (0, 7, 'c'), (1, 'd'), (2, 'c'),
           (3, 'c', '-2'), (0, 'a', 'c'), (1, 'a'), (2, 'b'), (3, 'b', '-2'), (0, 'c', 'b'), (2, 'd'), (3, 'd', '-6'),
           (0, 19, 'c'), (0, 11, 'd'), (1, 'a'), (2, 'd'), (3, 'd', '-2'), (2, 'c'), (3, 'c', '-5')]

print(execute(program, part_a_registers))
print(execute(program, part_b_registers))