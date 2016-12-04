from enum import Enum


class Directions(Enum):
    north = 0
    east = 1
    south = 2
    west = 3


class CalculateDistance:
    def __init__(self):
        # [North,East,South,West]
        self.distances = [0, 0, 0, 0]
        self.currentCoordinates = (0, 0)
        self.visitedCoordinates = [(0, 0)]
        self.currentDirection = 0
        self.twiceLocation = None
        self.visitedTwice = False

    def calculate_new_direction(self, rotation: str):
        if rotation == "R":
            self.currentDirection = (self.currentDirection + 1) % 4
        else:
            self.currentDirection = (self.currentDirection - 1) % 4

    def calculate_distances(self) -> (int, int):
        vertical_movement = abs(self.distances[0] - self.distances[2])
        horizontal_movement = abs(self.distances[1] - self.distances[3])
        final_distance = vertical_movement + horizontal_movement
        if self.visitedTwice:
            twice_visited_distance = abs(self.twiceLocation[0]) + abs(self.twiceLocation[1])
        else:
            twice_visited_distance = 0
        return final_distance, twice_visited_distance

    def execute(self, directions: str) -> (int, int):
        directions_list = directions.split(", ") if len(directions) > 0 else []
        for direction in directions_list:
            rotation = direction[0]
            distance = int(direction[1:])
            self.calculate_new_direction(rotation)
            self.distances[self.currentDirection] += distance
            if not self.twiceLocation:
                self.calculate_coordinates_visited(distance)
        return self.calculate_distances()

    def calculate_coordinates_visited(self, distance):
        for i in range(distance):
            if self.currentDirection == Directions.north.value:
                self.currentCoordinates = (self.currentCoordinates[0], self.currentCoordinates[1] + 1)
            elif self.currentDirection == Directions.east.value:
                self.currentCoordinates = (self.currentCoordinates[0] + 1, self.currentCoordinates[1])
            elif self.currentDirection == Directions.south.value:
                self.currentCoordinates = (self.currentCoordinates[0], self.currentCoordinates[1] - 1)
            elif self.currentDirection == Directions.west.value:
                self.currentCoordinates = (self.currentCoordinates[0] - 1, self.currentCoordinates[1])
            if self.currentCoordinates not in self.visitedCoordinates:
                self.visitedCoordinates.append(self.currentCoordinates)
            else:
                self.visitedTwice = True
                self.twiceLocation = self.currentCoordinates
