from unittest import TestCase
from src.day_3.GetPossibleTriangles import GetPossibleTriangles


class TestGetPossibleTriangles(TestCase):
    def setUp(self):
        super().setUp()
        self.use_case = GetPossibleTriangles()

    def test_givenInvalidTriang_whenGettingIsValidTriangle_returnFalse(self):
        self.assertFalse(self.use_case.isValidTriangle(5, 5, 100))

    def test_givenValidTriangle_whenGettingIsValidTriangle_returnTrue(self):
        self.assertTrue(self.use_case.isValidTriangle(5, 5, 7))
