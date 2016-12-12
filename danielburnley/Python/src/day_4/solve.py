from src.day_4.Day4 import Day4

rooms = open('input.txt', 'r').read().split("\n")

solver = Day4()
print("Sum of sector ids = " + str(solver.get_sum_of_real_sector_ids(rooms)))

decryptedRooms = solver.decrypt_valid_rooms(rooms)
for room in decryptedRooms:
    print(room)
