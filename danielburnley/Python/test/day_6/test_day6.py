from unittest import TestCase

from src.day_6.Day6 import Day6


class TestDay6(TestCase):
    def setUp(self):
        self.solver = Day6()

    def test_givenStringWithSingleCharacter_whenGettingMostOccurringCharacter_returnMostCharacter(self):
        self.assertEqual("a", self.solver.get_most_occurring_character("a"))

    def test_givenStringWithMultipleCharacters_whenGettingMostOccurringCharacter_returnMostOccurringCharacter(self):
        self.assertEqual("a", self.solver.get_most_occurring_character("aaaaaaaaaaaaaabcdef"))

    def test_givenExampleInput_whenGettingErrorCorrectedMessage_returnCorrectMessage(self):
        example_input = [
            "eedadn",
            "drvtee",
            "eandsr",
            "raavrd",
            "atevrs",
            "tsrnev",
            "sdttsa",
            "rasrtv",
            "nssdts",
            "ntnada",
            "svetve",
            "tesnvt",
            "vntsnd",
            "vrdear",
            "dvrsen",
            "enarar"
        ]
        self.assertEqual("easter", self.solver.get_corrected_message(example_input))
