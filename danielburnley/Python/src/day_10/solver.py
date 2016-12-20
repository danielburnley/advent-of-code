from src.day_10.Day10 import Solver

instructions = open('input.txt', 'r').readlines()
solver = Solver()
solver.execute_instructions(instructions)
solver.run_bots()
logs = solver.get_comparison_logs()
for log in logs:
    if log[1][0] == (17, 61):
        print(log)
outputs = solver.bot_manager.outputs
print(outputs["0"].values[0] * outputs["1"].values[0] * outputs["2"].values[0])