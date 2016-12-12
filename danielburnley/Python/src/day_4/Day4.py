import re
from collections import OrderedDict
ASCII_OFFSET = 97


class Day4:
    def __init__(self):
        pass

    def count_characters(self, string: str) -> dict:
        count = {}
        for char in string:
            if char.isalpha():
                try:
                    count[char] += 1
                except KeyError:
                    count[char] = 1
        return count

    def is_valid_checksum(self, room_name: str, checksum: str) -> bool:
        character_count = self.count_characters(room_name)
        sorted_character_count = OrderedDict(sorted(character_count.items(), key=lambda x: (-x[1], x[0])))
        top_occurring_characters = []
        for char in sorted_character_count:
            if sorted_character_count[char] > 1 and len(top_occurring_characters) < 5:
                top_occurring_characters.append(char)
        if len(top_occurring_characters) < 5:
            for char in top_occurring_characters:
                sorted_character_count.pop(char)
            sorted_remaining_chars = sorted(sorted_character_count.keys())
            for i in range(5 - len(top_occurring_characters)):
                top_occurring_characters.append(sorted_remaining_chars[i])
        calculated_checksum = ""
        for char in top_occurring_characters:
            calculated_checksum += char

        print(room_name + ": " + str((checksum == calculated_checksum)) + " " + calculated_checksum)
        return checksum == calculated_checksum

    def is_real_room(self, room: str) -> bool:
        room_name = re.match("([a-z]+-)+[a-z]+", room).group(0)
        checksum = re.match(".+\[([a-z]{5})\]", room).group(1)
        return self.is_valid_checksum(room_name, checksum)

    def sum_sector_ids(self, rooms: list) -> int:
        sum_of_ids = 0
        for room in rooms:
            id = re.search("\d+", room).group(0)
            sum_of_ids += int(id)
        return sum_of_ids

    def get_sum_of_real_sector_ids(self, rooms: list) -> int:
        real_rooms = [room for room in rooms if self.is_real_room(room)]
        ids = self.sum_sector_ids(real_rooms)
        return ids

    # Part 2

    def shift_char(self, char, amount):
        char_value = (ord(char) - ASCII_OFFSET)
        new_char_value = (char_value + amount) % 26
        return chr(new_char_value + ASCII_OFFSET)

    def decrypt_room_name(self, room):
        room_name = re.match("([a-z]+-)+[a-z]+", room).group(0)
        sector_id = re.search("\d+", room).group(0)
        decrypted_name = ""
        for char in room_name:
            if char == "-":
                decrypted_name += " "
            else :
                decrypted_name += self.shift_char(char, int(sector_id))

        return decrypted_name

    def decrypt_valid_rooms(self, rooms):
        return [(self.decrypt_room_name(room), re.search("\d+", room).group(0)) for room in rooms if self.is_real_room(room)]
