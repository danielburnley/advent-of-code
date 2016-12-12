import operator


class Day6:
    def __init__(self):
        pass

    def get_most_occurring_character(self, char_list: str) -> str:
        occurrences = self.get_character_occurrences(char_list)
        return sorted(occurrences.items(), key=operator.itemgetter(1), reverse=True)[0][0]

    def get_least_occurring_character(self, char_list: str) -> str:
        occurrences = self.get_character_occurrences(char_list)
        return sorted(occurrences.items(), key=operator.itemgetter(1))[0][0]

    def get_character_occurrences(self, char_list):
        occurrences = {}
        for char in char_list:
            try:
                occurrences[char] += 1
            except KeyError:
                occurrences[char] = 1
        return occurrences

    def get_corrected_message(self, noisy_input: list, modified = False) -> str:
        cols = len(noisy_input[0])
        col_values = ["" for x in range(cols)]
        message = ""
        for row in noisy_input:
            for i in range(len(row)):
                col_values[i] += row[i]

        for value in col_values:
            if not modified:
                message += self.get_most_occurring_character(value)
            else:
                message += self.get_least_occurring_character(value)
        return message
