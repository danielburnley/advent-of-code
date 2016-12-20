from unittest import TestCase

from src.day_10.Day10 import Solver


class Day10AcceptanceTest(TestCase):
    def setUp(self):
        super().setUp()
        self.solver = Solver()

    def test_givenExampleInputs_assertOutputCorrect(self):
        instructions = """value 5 goes to bot 2
bot 2 gives low to bot 1 and high to bot 0
value 3 goes to bot 1
bot 1 gives low to output 1 and high to bot 0
bot 0 gives low to output 2 and high to output 0
value 2 goes to bot 2""".split("\n")
        self.solver.execute_instructions(instructions)
        self.solver.run_bots()
        bots = self.solver.bot_manager.bots
        outputs = self.solver.bot_manager.outputs
        self.assertEqual([5], outputs["0"].values)
        self.assertEqual([2], outputs["1"].values)
        self.assertEqual([3], outputs["2"].values)
        self.assertEqual([(2, 5)], bots["2"].comparison_log)
