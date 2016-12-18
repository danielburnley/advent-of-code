from unittest import TestCase

from src.day_9.Day9 import Day9


class Day9AcceptanceTests(TestCase):
    def setUp(self):
        super().setUp()
        self.solver = Day9()

    def test_acceptance_tests(self):
        self.assertEqual("ADVENT", self.solver.decompress_data("ADVENT"))

    def test_two(self):
        self.assertEqual("ABBBBBC", self.solver.decompress_data("A(1x5)BC"))

    def test_three(self):
        self.assertEqual("XYZXYZXYZ", self.solver.decompress_data("(3x3)XYZ"))

    def test_four(self):
        self.assertEqual("ABCBCDEFEFG", self.solver.decompress_data("A(2x2)BCD(2x2)EFG"))

    def test_five(self):
        self.assertEqual("  (1x3)A", self.solver.decompress_data("(6x1)(1x3)A"))

    def test_six(self):
        self.assertEqual("X(3x3)ABC(3x3)ABCY", self.solver.decompress_data("X(8x2)(3x3)ABCY"))
