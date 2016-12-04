from src.day_one.CalculateDistance import CalculateDistance

f = open("input.txt", 'r')
input = f.readline()

print(CalculateDistance().execute(input))