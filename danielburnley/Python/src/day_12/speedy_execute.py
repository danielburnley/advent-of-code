def execute(program, registers):
    pointer = 0
    program_length = len(program)
    while pointer < program_length:
        instruction = program[pointer]
        command = instruction[0]
        if command == 0:
            registers[instruction[2]] = int(instruction[1]) if instruction[1] not in registers \
                else registers[instruction[1]]
        elif command == 1:
            registers[instruction[1]] += 1
        elif command == 2:
            registers[instruction[1]] -= 1
        elif command == 3:
            pointer += instruction[2] if instruction[1] not in registers and instruction[1] != 0 \
                else 1 if registers[instruction[1]] == 0 \
                else int(instruction[2]) if instruction[2] not in registers \
                else registers[instruction[2]]
        if command != 3:
            pointer += 1
    return registers
