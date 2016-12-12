import hashlib


class Day5:
    def __init__(self):
        pass

    @staticmethod
    def get_password(door_id: str) -> str:
        password = ""
        i = 0
        while len(password) < 8:
            door_index_id = bytes(door_id, 'ascii') + bytes(str(i), 'ascii')
            hex_md5 = hashlib.md5(door_index_id).hexdigest()
            if hex_md5.startswith("00000"):
                print("ding")
                password += hex_md5[5]
            i += 1
        return password

    @staticmethod
    def get_cinematic_password(door_id: str) -> str:
        password = ["_", "_", "_", "_", "_", "_", "_", "_"]
        i = 0
        print("".join(password))
        while "_" in password:
            door_index_id = bytes(door_id, 'ascii') + bytes(str(i), 'ascii')
            hex_md5 = hashlib.md5(door_index_id).hexdigest()
            if hex_md5.startswith("00000") and hex_md5[5].isnumeric():
                if int(hex_md5[5]) < 8 and password[int(hex_md5[5])] == "_":
                    password[int(hex_md5[5])] = hex_md5[6]
                    print("".join(password))
            i += 1
        return "".join(password)
