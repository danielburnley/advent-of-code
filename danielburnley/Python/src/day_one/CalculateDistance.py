class CalculateDistance:


    def __init__(self):
        # [North,East,South,West]
        self.distances = [0, 0, 0, 0]
        self.currentDirection = 0

    def calculate_new_direction(self, rotation : str):
        if rotation == "R":
            self.currentDirection = (self.currentDirection + 1) % 4
        else:
            self.currentDirection = (self.currentDirection - 1) % 4

    def calculateDistance(self) -> int:
        verticalMovement = abs(self.distances[0] - self.distances[2])
        horizontalMovement = abs(self.distances[1] - self.distances[3])
        return verticalMovement + horizontalMovement

    def execute(self, directions: str) -> int:
        directionsList = directions.split(", ") if len(directions) > 0 else []
        for direction in directionsList:
            self.calculate_new_direction(direction[0])
            self.distances[self.currentDirection] += int(direction[1:])
        return self.calculateDistance()