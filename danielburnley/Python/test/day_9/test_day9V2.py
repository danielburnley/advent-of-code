from unittest import TestCase

from src.day_9.Day9V2 import get_decompressed_data_length


class TestDay9V2(TestCase):
    def test_givenDataWithNoMarkers_returnOriginalDataLength(self):
        self.assertEqual(len("MEOW"), get_decompressed_data_length("MEOW"))

    def test_givenDataWithSingleMarkerWhichRepeatsOneCharacterOneTime_returnDataLengthCorrectly(self):
        self.assertEqual(1, get_decompressed_data_length("(1x1)A"))

    def test_givenDataWithOverlappingMarkers_whenDecompressing_decompressForBothMarkersCorrectly(self):
        self.assertEqual(3, get_decompressed_data_length("(6x1)(1x3)A"))

    def test_givenDataWithMultipleOverlappingMarkers_whenDecompressing_decompressForAllMarkersCorrectly(self):
        self.assertEqual(241920, get_decompressed_data_length("(27x12)(20x12)(13x14)(7x10)(1x12)A"))

    def test_givenDataWithContentBeforeOverlappingMarkers_returnLengthCorrectly(self):
        self.assertEqual(5, get_decompressed_data_length("AA(6x1)(1x3)A"))

    def test_givenDataWithMultipleNonOverlappingMarkers_returnLengthCorrectly(self):
        self.assertEqual(11, get_decompressed_data_length("A(2x2)BCD(2x2)EFG"))
