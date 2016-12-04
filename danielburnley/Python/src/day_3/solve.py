from src.day_3.GetPossibleTriangles import GetPossibleTriangles

triangles = open('input.txt', 'r').read()

print("Rows", GetPossibleTriangles().executeRows(triangles))
print("Rows", GetPossibleTriangles().executeCols(triangles))
