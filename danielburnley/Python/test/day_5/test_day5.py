from unittest import TestCase
from src.day_5.Day5 import Day5


class TestDay5(TestCase):
    def test_givenInput_whenGettingPassword_returnCorrectPassword(self):
        self.assertEqual("18f47a30", Day5.get_password("abc"))

    def test_givenInput_whenGettingCinematicPassword_returnCorrectPassword(self):
        self.assertEqual("05ace8e3", Day5.get_cinematic_password("abc"))

