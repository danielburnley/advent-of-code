from unittest import TestCase

from src.day_10.Day10 import Bot, Output


class TestBot(TestCase):
    def test_givenBot_whenAddingSingleValue_addValueCorrectly(self):
        bot = Bot()
        bot.give_value(10)
        self.assertEqual([10], bot.values)

    def test_givenBotWithDestinations_whenAddingLowValueThenHighValue_sendValuesToCorrectDestinationsAndAddComparisonToLog(self):
        bot = Bot()
        high_destination = Output()
        low_destination = Output()
        bot.high_destination = high_destination
        bot.low_destination = low_destination
        low_value = 10
        high_value = 20
        bot.give_value(low_value)
        bot.give_value(high_value)
        bot.swap_values_if_appropriate()
        self.assertEqual([low_value], low_destination.values)
        self.assertEqual([high_value], high_destination.values)
        self.assertEqual(0, len(bot.values))
        self.assertEqual([(low_value, high_value)], bot.comparison_log)

    def test_givenBotWithDestinations_whenAddingHighValueThenLowValue_sendValuesToCorrectDestinationsAndAddComparisonToLog(self):
        bot = Bot()
        high_destination = Output()
        low_destination = Output()
        bot.high_destination = high_destination
        bot.low_destination = low_destination
        low_value = 10
        high_value = 20
        bot.give_value(high_value)
        bot.give_value(low_value)
        bot.swap_values_if_appropriate()
        self.assertEqual([low_value], low_destination.values)
        self.assertEqual([high_value], high_destination.values)
        self.assertEqual(0, len(bot.values))
        self.assertEqual([(low_value, high_value)], bot.comparison_log)