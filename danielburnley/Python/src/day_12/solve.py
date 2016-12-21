from src.day_12.Day12 import AssembunnyRunner

instructions = open('input.txt', 'r').readlines()
runner = AssembunnyRunner()
for instruction in instructions:
    runner.add_instruction(instruction.strip())
runner.execute()
for register, value in runner.registers.items():
    print(register + ": " + str(value))

partB = AssembunnyRunner()
partB.registers['c'] = 1
for instruction in instructions:
    partB.add_instruction(instruction.strip())
partB.execute()
for register, value in partB.registers.items():
    print(register + ": " + str(value))
