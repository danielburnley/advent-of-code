from src.day_two.CalculatePassCode import CalculatePassCode
from src.day_two.Keypads import SIMPLE_KEY_PAD, MANAGEMENT_KEY_PAD

instructions = open('input.txt').read()
print(CalculatePassCode(SIMPLE_KEY_PAD, [1,1]).get_sum_of_real_sector_ids(instructions))
print(CalculatePassCode(MANAGEMENT_KEY_PAD, [2,0]).get_sum_of_real_sector_ids(instructions))