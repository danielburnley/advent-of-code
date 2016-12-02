from src.day_two.CalculatePassCode import CalculatePassCode

instructions = open('input.txt').read()
print(CalculatePassCode().execute(instructions))