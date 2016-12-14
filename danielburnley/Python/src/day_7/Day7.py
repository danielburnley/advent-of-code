import re

class Day7:
    def __init__(self):
        pass

    # Part A

    def get_text_outside_brackets(self, ip):
        return [x for x in re.findall(r'\[[^\]]*\]|(\b\w+\b)', ip) if x]

    def get_text_inside_brackets(self, ip):
        return [x for x in re.findall(r'\[[a-z]+]', ip) if x]

    def text_contains_abba(self, text: str) -> bool:
        pattern = re.compile(r'([a-z])([a-z])\2\1')
        res = pattern.search(text)
        if res:
            if not (res.group(1) == res.group(2)):
                return True
        return False

    def ip_supports_tls(self, ip: str) -> bool:
        text_outside_brackets = self.get_text_outside_brackets(ip)
        abba_outside_brackets = False
        for text in text_outside_brackets:
            if self.text_contains_abba(text):
                abba_outside_brackets = True

        text_inside_brackets = self.get_text_inside_brackets(ip)
        abba_inside_brackets = False
        for text in text_inside_brackets:
            if self.text_contains_abba(text):
                abba_inside_brackets = True
        return abba_outside_brackets and not abba_inside_brackets

    def count_ips_which_support_tls(self, ips: list) -> int:
        count = 0
        for ip in ips:
            if self.ip_supports_tls(ip):
                count += 1
        return count

    # Part B

    def find_ABAs_in_IP(self, ip: str) -> list:
        text_outside_brackets = self.get_text_outside_brackets(ip)
        ABAs = []
        for text in text_outside_brackets:
            for i in range(len(text) - 2):
                if text[i] == text[i+2] and not text[i] == text[i+1]:
                    ABAs.append(text[i:i+3])
        return ABAs

    def ip_contains_BAB(self, abas: list, ip: str) -> bool:
        text_inside_brackets = self.get_text_inside_brackets(ip)
        for text in text_inside_brackets:
            for aba in abas:
                bab = aba[1] + aba[0] + aba[1]
                if text.find(bab) > -1:
                    return True
        return False

    def ip_supports_ssl(self, ip: str) -> bool:
        if self.ip_contains_BAB(self.find_ABAs_in_IP(ip), ip):
            return True
        else:
            return False

    def count_ips_which_support_ssl(self, ips: list) -> int:
        count = 0
        for ip in ips:
            if self.ip_supports_ssl(ip):
                count += 1
        return count
