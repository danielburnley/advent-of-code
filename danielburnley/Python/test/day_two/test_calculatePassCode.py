from unittest import TestCase
from src.day_two.CalculatePassCode import CalculatePassCode


class TestCalculatePassCode(TestCase):
    def assertPassCode(self, expectedPassCode):
        self.assertEqual(expectedPassCode, self.useCase.execute(self.instructions))

    def setUp(self):
        super().setUp()
        self.instructions = ""
        self.useCase = CalculatePassCode()

    def test_givenFourSimpleInstructions_whenGettingPassCode_returnCorrectPassCode(self):
        self.instructions = "U\nD\nU\nD"
        self.assertPassCode("2525")