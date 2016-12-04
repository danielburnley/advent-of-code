class GetPossibleTriangles:
    def __init__(self):
        pass

    def isValidTriangle(self, a, b, c):
        return (a + b > c and a + c > b and b + c > a)

    def executeRows(self, triangles: str) -> int:
        possibleTriangles = triangles.split("\n")
        count = 0
        for possibleTriangle in possibleTriangles:
            possibleTriangle = possibleTriangle.split()
            if self.isValidTriangle(int(possibleTriangle[0]), int(possibleTriangle[1]), int(possibleTriangle[2])):
                count += 1
        return count

    def executeCols(self, triangles: str)-> int:
        count = 0
        triangles = triangles.split("\n")
        trianglesList = []
        for triangle in triangles:
            trianglesList.append(triangle.split())
        i = 0
        while i < len(trianglesList):
            for j in range(3):
                if self.isValidTriangle(int(trianglesList[i][j]), int(trianglesList[i+1][j]), int(trianglesList[i+2][j])):
                    count += 1
            i += 3
        return count
