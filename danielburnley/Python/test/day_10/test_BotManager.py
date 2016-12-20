from unittest import TestCase

from src.day_10.Day10 import BotManager, Bot, Output

BOT_NAME = "MeowBot2000"


class TestBotManager(TestCase):
    def assert_high_destination(self, bot_name, expected_destination):
        self.assertEqual(expected_destination, self.manager.bots[bot_name].high_destination)

    def assert_low_destination(self, bot_name, expected_destination):
        self.assertEqual(expected_destination, self.manager.bots[bot_name].low_destination)

    def setUp(self):
        super().setUp()
        self.manager = BotManager()

    def test_givenBotName_whenAddingBot_CreateBotSuccessfully(self):
        self.manager.create_bot(BOT_NAME)
        self.assertIsInstance(self.manager.bots[BOT_NAME], Bot)

    def test_GivenNoBots_whenGettingDoesBotExist_returnFalse(self):
        self.assertFalse(self.manager.bot_exists(BOT_NAME))

    def test_givenBot_whenGettingDoesBotExist_returnTrue(self):
        self.manager.create_bot(BOT_NAME)
        self.assertTrue(self.manager.bot_exists(BOT_NAME))

    def test_givenNoBot_whenRegisteringDestinations_createBotAndRegisterCorrectDestinations(self):
        high_destination = Output()
        low_destination = Output()
        self.manager.register_destinations(BOT_NAME, high_destination, low_destination)
        self.assert_high_destination(BOT_NAME, high_destination)
        self.assert_low_destination(BOT_NAME, low_destination)

    def test_givenBot_whenRegisteringDestinations_RegisterDestinationsAndDoNotCreateExtraBot(self):
        high_destination = Bot()
        low_destination = Bot()
        self.manager.create_bot(BOT_NAME)
        self.manager.register_destinations(BOT_NAME, high_destination, low_destination)
        self.assertEqual(1, len(self.manager.bots))
        self.assert_high_destination(BOT_NAME, high_destination)
        self.assert_low_destination(BOT_NAME, low_destination)

    def test_givenNoBot_whenGivingValueToBot_createBotAndGiveValueToBot(self):
        value = 10
        self.manager.give_value_to_bot(BOT_NAME, value)
        self.assertIsInstance(self.manager.bots[BOT_NAME], Bot)
        self.assertEqual([value], self.manager.bots[BOT_NAME].values)

    def test_givenBot_whenGivingValueToBot_giveValueToBotAndDoNotCreateExtraBot(self):
        value = 10
        self.manager.create_bot(BOT_NAME)
        self.manager.give_value_to_bot(BOT_NAME, value)
        self.assertEqual(1, len(self.manager.bots))
        self.assertEqual([value], self.manager.bots[BOT_NAME].values)