from unittest import TestCase

from src.day_12.Day12 import AssembunnyRunner


class TestAssembunnyRunner(TestCase):
    def setUp(self):
        super().setUp()
        self.runner = AssembunnyRunner()

    def test_givenCopyingValueIntoRegisterA_copyValueToRegisterCorrectly(self):
        value = 12
        self.runner.add_instruction("cpy " + str(value) + " a")
        self.runner.execute()
        self.assertEqual(value, self.runner.registers["a"])

    def test_givenIncrementingValueInRegisterA_IncrementValueCorrectly(self):
        instruction = "inc a"
        self.runner.add_instruction(instruction)
        self.runner.execute()
        self.assertEqual(1, self.runner.registers["a"])

    def test_givenDecrementingValueInRegisterA_DecrementValueCorrectly(self):
        self.runner.add_instruction("dec a")
        self.runner.execute()
        self.assertEqual(-1, self.runner.registers["a"])

    def test_givenJumpingBackOneInstructionWhenRegisterEqualsZero_JumpForwardInstructionCorrectly(self):
        self.runner.add_instruction("cpy -2 a")
        self.runner.add_instruction("inc a")
        self.runner.add_instruction("jnz a -1")
        self.runner.execute()
        self.assertEqual(0, self.runner.registers["a"])
