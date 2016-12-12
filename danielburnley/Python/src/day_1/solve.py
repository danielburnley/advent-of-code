from src.day_one.CalculateDistance import CalculateDistance

f = open("input.txt", 'r')
input = f.readline()

print(CalculateDistance().get_sum_of_real_sector_ids(input))