from unittest import TestCase

from src.day_4.Day4 import Day4


class TestDay4(TestCase):
    def assertRoomNotReal(self, room: str):
        self.assertFalse(self.use_case.is_real_room(room))

    def assertRoomReal(self, room: str):
        self.assertTrue(self.use_case.is_real_room(room))

    def setUp(self):
        super().setUp()
        self.rooms = []
        self.use_case = Day4()

    def test_givenSingleInvalidRoom_returnRoomNotValid(self):
        self.assertRoomNotReal("totally-real-room-200[decoy]")

    def test_givenSingleRealRoom_returnRoomIsReal(self):
        self.assertRoomReal("aaaaa-bbb-z-y-x-123[abxyz]")

    def test_givenSingleRealRoom_whenGettingSumOfSectorIds_returnSectorId(self):
        self.assertEqual(123, self.use_case.get_sum_of_real_sector_ids(["aaaaa-bbb-z-y-x-123[abxyz]"]))

    def test_givenMultipleRealRooms_whenGettingSumOfSectorIds_returnCorrectSum(self):
        self.assertEqual(246, self.use_case.get_sum_of_real_sector_ids(["aaaaa-bbb-z-y-x-123[abxyz]", "aaaaa-bbb-z-y-x-123[abxyz]"]))

    def test_givenMultipleRoomsWithOneFake_whenGettingSumOfSectorIds_returnCorrectSumNotIncludingFakeRoom(self):
        rooms = [
            "aaaaa-bbb-z-y-x-123[abxyz]",
            "a-b-c-d-e-f-g-h-987[abcde]",
            "not-a-real-room-404[oarel]",
            "totally-real-room-200[decoy]"
        ]
        self.assertEqual(1514, self.use_case.get_sum_of_real_sector_ids(rooms))

    def test_givenRoom_whenDecrypting_returnCorrectName(self):
        self.assertEqual("very encrypted name", self.use_case.decrypt_room_name("qzmt-zixmtkozy-ivhz-343"))