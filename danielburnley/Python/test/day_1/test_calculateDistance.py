from unittest import TestCase
from src.day_1.CalculateDistance import CalculateDistance

class TestCalculateDistance(TestCase):
    def assertDistance(self, expectedDistance):
        self.assertEqual(expectedDistance, self.use_case.execute(self.directions)[0])

    def assertTwiceVisited(self, expectedCoordinates):
        self.use_case.execute(self.directions)
        self.assertEqual(expectedCoordinates, self.use_case.twiceLocation)

    def setUp(self):
        super().setUp()
        self.use_case = CalculateDistance()
        self.directions = None

    def test_givenNoDirections_whenCalculatingDistance_return0(self):
        self.directions = ""
        self.assertDistance(0)

    def test_givenRightOne_whenCalculatingDistance_return1(self):
        self.directions = "R1"
        self.assertDistance(1)

    def test_givenMultipleDirections_whenCalculatingDistance_returnCorrectDistance(self):
        self.directions = "R1, R1, L1"
        self.assertDistance(3)

    def test_givenDirectionsThatLeaveYouTwoSouth_whenCalculatingDistance_returnTwo(self):
        self.directions = "R2, R2, R2"
        self.assertDistance(2)

    def test_givenLongStringOfDirections_whenCalculatingDistance_returnCorrectDistance(self):
        self.directions = "R5, L5, R5, R3"
        self.assertDistance(12)

    def test_givenDirectionsWithTwoDigits_whenCalculatingDistance_returnCorrectDistance(self):
        self.directions = "R10, L10"
        self.assertDistance(20)

    def test_givenVisitedLocationTwice_whenCalculatingDistance_returnCorrectPlaceVisitedTwice(self):
        self.directions = "R8, R4, R4, R8"
        self.assertTwiceVisited((4, 0))