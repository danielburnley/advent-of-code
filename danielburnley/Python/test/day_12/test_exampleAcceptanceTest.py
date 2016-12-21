from unittest import TestCase

from src.day_12.Day12 import AssembunnyRunner


class AcceptanceTest(TestCase):
    def test_example(self):
        runner = AssembunnyRunner()
        instructions = """cpy 41 a
inc a
inc a
dec a
jnz a 2
dec a""".splitlines()
        for instruction in instructions:
            runner.add_instruction(instruction)
        runner.execute()
        self.assertEqual(42, runner.registers["a"])
