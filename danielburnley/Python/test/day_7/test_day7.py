from unittest import TestCase

from src.day_7.Day7 import Day7


class TestDay7(TestCase):
    def setUp(self):
        super().setUp()
        self.solver = Day7()

    def test_givenTextWithoutABBA_whenGettingDoesHaveABBA_returnFalse(self):
        self.assertFalse(self.solver.text_contains_abba("gefe"))

    def test_givenTextWithABBA_whenGettingDoesHaveABBA_returnTrue(self):
        self.assertTrue(self.solver.text_contains_abba("abba"))

    def test_givenInvalidABBA_whenGettingDoesHaveABBA_returnFalse(self):
        self.assertFalse(self.solver.text_contains_abba("aaaa"))

    def test_givenABBASurroundedByOtherText_whenGettingDoesHaveABBA_returnTrue(self):
        self.assertTrue(self.solver.text_contains_abba("abcdefabbaabcdef"))

    def test_givenIPWhichSupportsTLS_whenGettingDoesSupportTLS_returnTrue(self):
        self.assertTrue(self.solver.ip_supports_tls("abba[mnop]qrst"))

    def test_givenIPWhichDoesNotSupportTLS_whenGettingDoesSupportTLS_returnFalse(self):
        self.assertFalse(self.solver.ip_supports_tls("abcd[bddb]xyyx"))

    def test_givenListOfOneIPWithTLSAndOneWithout_whenGettingCountOfTLSIPs_returnOne(self):
        self.assertEqual(1, self.solver.count_ips_which_support_tls(["abba[mnop]qrst", "abcd[bddb]xyyx"]))

    def test_givenIPWithNoABAs_whenGettingABAs_returnEmptyList(self):
        self.assertEqual([], self.solver.find_ABAs_in_IP("abcdefghijkl"))

    def test_givenIPWithSingleABA_whenGettingABAs_returnListOfOne(self):
        self.assertEqual(["aba"], self.solver.find_ABAs_in_IP("abaaaaaaaa"))

    def test_givenTextWithTwoABAs_whenGettingABAs_returnBothABAs(self):
        self.assertEqual(["aba", "bcb"], self.solver.find_ABAs_in_IP("abaaaabcb"))

    def test_givenTextWithOverlappingABAs_whenGettingABAs_returnBothABAs(self):
        self.assertEqual(["aba", "bab"], self.solver.find_ABAs_in_IP("ababjklmnop"))

    def test_givenNoABAs_whenGettingDoesTextContainBAB_returnFalse(self):
        self.assertFalse(self.solver.ip_contains_BAB([], "abc[abc]abc"))

    def test_givenABAAndTextWhichContainsNoBAB_whenGettingDoesTextContainBAB_returnFalse(self):
        self.assertFalse(self.solver.ip_contains_BAB(["aba"], "abc[abc]abc"))

    def test_givenABAAndTextWhichContainsBAB_whenGettingDoesTextContainBAB_returnTrue(self):
        self.assertTrue(self.solver.ip_contains_BAB(["aba"], "abc[bab]abc"))

    def test_givenABAAndTextWhichContainsMultipleBracketsWithOneBAB_whenGettingDoesTextContainBAB_returnTrue(self):
        self.assertTrue(self.solver.ip_contains_BAB(["aba"], "aba[aaa]abc[bab]"))

    def test_givenIPWhichDoesntSupportSSL_whenGettingDoesIPSupportSSL_returnFalse(self):
        self.assertFalse(self.solver.ip_supports_ssl("abcde[fghijk]lmnop"))

    def test_givenIPWhichSupportsSSL_whenGettingDoesIPSupportSSL_returnTrue(self):
        self.assertTrue(self.solver.ip_supports_ssl("aba[bab]abcdef"))

    def test_givenTwoIPsWithOnlyOneSupportingSSL_whenGettingCountOfIPsThatSupportSSL_returnOne(self):
        self.assertEqual(1, self.solver.count_ips_which_support_ssl(["aba[bab]abcdef", "abc[def]ghijk"]))
