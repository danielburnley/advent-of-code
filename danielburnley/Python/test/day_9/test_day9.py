from unittest import TestCase

from src.day_9.Day9 import Day9

TEST_STRING = "meow"


class TestDay9(TestCase):
    def assert_decompressed_string(self, expected_string):
        self.assertEqual(expected_string, self.solver.decompressed_string)

    def setUp(self):
        super().setUp()
        self.solver = Day9()

    def test_givenStringToRepeatOnceWithEmptyCurrentString_whenRepeatingString_addStringOnce(self):
        self.solver.repeat_string(1, TEST_STRING)
        self.assert_decompressed_string(TEST_STRING)

    def test_givenStringToRepeatTwiceWithEmptyCurrentString_whenRepeatingString_addStringTwice(self):
        self.solver.repeat_string(2, TEST_STRING)
        self.assert_decompressed_string(TEST_STRING + TEST_STRING)

    def test_givenStringToRepeatOnceWithCurrentStringAlreadyContainingData_whenRepeatingString_addStringCorrectly(self):
        self.solver.decompressed_string = TEST_STRING
        self.solver.repeat_string(1, TEST_STRING)
        self.assert_decompressed_string(TEST_STRING + TEST_STRING)

    def test_givenStringWithNoMarkers_whenDecompressingData_returnOriginalData(self):
        self.assertEqual(TEST_STRING, self.solver.decompress_data(TEST_STRING))

    def test_givenStringWithSingleMarkerWithLengthZero_whenDecompressingData_returnDataWithoutMarker(self):
        self.assertEqual(TEST_STRING, self.solver.decompress_data("(0x0)" + TEST_STRING))

    def test_givenStringWithSingleMarkerWithLengthOneRepeatingOnce_whenDecompressingData_returnDataWithoutMarker(
            self):
        self.assertEqual("abcdefg", self.solver.decompress_data("(1x1)abcdefg"))

    def test_givenStringWithSingleMarkerWithLengthOneRepeatingTwice_whenDecompressingData_returnDataExpandedCorrectly(
            self):
        self.assertEqual("aabcdefg", self.solver.decompress_data("(1x2)abcdefg"))

    def test_givenStringWithSingleMarkerWithLengthTwoRepeatingTwice_whenDecompressingData_returnDataExpandedCorrectly(
            self):
        self.assertEqual("ababcdefg", self.solver.decompress_data("(2x2)abcdefg"))

    def test_givenStringWithTwoMarkersWithLengthTwoRepeatingTwice_whenDecompressingData_returnDataExpandedCorrectly(
            self):
        self.assertEqual("ababcdefgfg", self.solver.decompress_data("(2x2)abcde(2x2)fg"))

    def test_givenStringWithMarkerWithLengthTenRepeatingTwice_whenDecompressingData_returnDataExpandedCorrectly(self):
        self.assertEqual("abcdefghijabcdefghij", self.solver.decompress_data("(10x2)abcdefghij"))