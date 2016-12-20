from typing import List
import re


class Destination:
    def __init__(self):
        self.values = []

    def give_value(self, value):
        return NotImplementedError


class Bot(Destination):
    def __init__(self):
        super().__init__()
        self.high_destination = None  # type: Destination
        self.low_destination = None  # type: Destination
        self.comparison_log = []

    def give_value(self, value):
        self.values.append(value)

    def swap_values_if_appropriate(self):
        if len(self.values) == 2:
            if self.values[0] > self.values[1]:
                self.high_destination.give_value(self.values[0])
                self.low_destination.give_value(self.values[1])
                self.comparison_log.append((self.values[1], self.values[0]))
            else:
                self.high_destination.give_value(self.values[1])
                self.low_destination.give_value(self.values[0])
                self.comparison_log.append((self.values[0], self.values[1]))
            self.values = []


class Output(Destination):
    def __init__(self):
        super().__init__()

    def give_value(self, value):
        self.values.append(value)


class BotManager:
    def __init__(self):
        self.outputs = {}  # type: dict[str, Output]
        self.bots = {}  # type: dict[str, Bot]

    def bot_exists(self, bot_name: str) -> bool:
        return bot_name in self.bots

    def output_exists(self, output_name: str) -> bool:
        return output_name in self.outputs

    def create_bot(self, bot_name: str):
        self.bots[bot_name] = Bot()

    def create_output(self, output_name: str):
        self.outputs[output_name] = Output()

    def register_destinations(self, bot_name: str, high_destination: Destination, low_destination: Destination):
        if not self.bot_exists(bot_name):
            self.create_bot(bot_name)
        self.bots[bot_name].high_destination = high_destination
        self.bots[bot_name].low_destination = low_destination

    def give_value_to_bot(self, bot_name: str, value: int):
        if not self.bot_exists(bot_name):
            self.create_bot(bot_name)
        self.bots[bot_name].give_value(value)

    def has_bots_holding_two_values(self):
        for bot in self.bots.values():
            if len(bot.values) == 2:
                return True
        return False


class Solver:
    def __init__(self):
        self.bot_manager = BotManager()

    def execute_instructions(self, instructions: List[str]):
        for instruction in instructions:
            self.parse_instruction(instruction)

    def parse_instruction(self, instruction: str):
        bot_instruction = re.match(r'bot', instruction)
        value_match = re.match(r'value', instruction)
        if bot_instruction:
            self.execute_bot_instruction(instruction)
        elif value_match:
            instruction = re.match(r'value (\d+) goes to bot (\d+)', instruction)
            self.bot_manager.give_value_to_bot(instruction.group(2), int(instruction.group(1)))

    def execute_bot_instruction(self, instruction: str):
        bot_name = re.match('bot (\d+)', instruction).group(1)
        low_destination_instruction = re.search(r'low to (output|bot) (\d+)', instruction)
        high_destination_instruction = re.search(r'high to (output|bot) (\d+)', instruction)
        low_destination = self.get_destination_from_instruction(low_destination_instruction)
        high_destination = self.get_destination_from_instruction(high_destination_instruction)
        self.bot_manager.register_destinations(bot_name, high_destination, low_destination)

    def get_destination_from_instruction(self, destination_instruction) -> Destination:
        if destination_instruction.group(1) == "output":
            if not self.bot_manager.output_exists(destination_instruction.group(2)):
                self.bot_manager.create_output(destination_instruction.group(2))
            return self.bot_manager.outputs[destination_instruction.group(2)]
        else:
            if not self.bot_manager.bot_exists(destination_instruction.group(2)):
                self.bot_manager.create_bot(destination_instruction.group(2))
            return self.bot_manager.bots[destination_instruction.group(2)]

    def get_comparison_logs(self):
        return [(name, bot.comparison_log) for name, bot in self.bot_manager.bots.items()]

    def run_bots(self):
        while self.bot_manager.has_bots_holding_two_values():
            for bot in self.bot_manager.bots.values():
                bot.swap_values_if_appropriate()
