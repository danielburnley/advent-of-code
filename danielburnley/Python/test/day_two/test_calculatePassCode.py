from unittest import TestCase
from src.day_two.CalculatePassCode import CalculatePassCode
from src.day_two.Keypads import SIMPLE_KEY_PAD, MANAGEMENT_KEY_PAD


class TestCalculatePassCode(TestCase):
    def assertPassCode(self, expectedPassCode):
        self.assertEqual(expectedPassCode, self.useCase.execute(self.instructions))

    def setUp(self):
        super().setUp()
        self.instructions = ""
        self.useCase = CalculatePassCode(SIMPLE_KEY_PAD, [1,1])

    def test_givenInstruction_whenGettingPassCode_thenReturnSingleCharacterPassCode(self):
        self.instructions = "U"
        self.assertPassCode("2")

    def test_givenFourSimpleInstructions_whenGettingPassCode_returnCorrectPassCode(self):
        self.instructions = "U\nD\nU\nD"
        self.assertPassCode("2525")

    def test_givenInstructionsThatGoOffTheEdge_whenGettingPassCode_thenReturnCorrectPassCode(self):
        self.instructions = "UUUUUU"
        self.assertPassCode("2")

    def test_givenKeyPadWithMinusOnesAndDirectionsThatLeadIntoMinusOne_whenGettingPassCode_thenReturnCorrectPassCode(self):
        self.useCase = CalculatePassCode(MANAGEMENT_KEY_PAD, [2,0])
        self.instructions = "UUUU"
        self.assertPassCode("5")