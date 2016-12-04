from src.day_two.CalculatePassCode import CalculatePassCode
from src.day_two.Keypads import SIMPLE_KEY_PAD, MANAGEMENT_KEY_PAD

instructions = open('input.txt').read()
print(CalculatePassCode(SIMPLE_KEY_PAD, [1,1]).execute(instructions))
print(CalculatePassCode(MANAGEMENT_KEY_PAD, [2,0]).execute(instructions))