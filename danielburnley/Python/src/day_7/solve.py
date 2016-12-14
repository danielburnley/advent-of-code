from src.day_7.Day7 import Day7

ips = open('input.txt', 'r').read().split("\n")
solver = Day7()

print("TLS:", solver.count_ips_which_support_tls(ips))
print("SSL:", solver.count_ips_which_support_ssl(ips))
