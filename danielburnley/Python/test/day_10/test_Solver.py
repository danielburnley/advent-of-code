from unittest import TestCase

from src.day_10.Day10 import Solver


class TestSolver(TestCase):
    def setUp(self):
        super().setUp()
        self.solver = Solver()

    def test_givenInstructionToGiveValueOneToBotOne_giveValueToBotOneCorrectly(self):
        self.solver.execute_instructions(["value 1 goes to bot 1"])
        self.assertEqual([1], self.solver.bot_manager.bots["1"].values)

