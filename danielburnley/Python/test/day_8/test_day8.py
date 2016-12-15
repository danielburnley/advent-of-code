from unittest import TestCase

from src.day_8.Day8 import Day8

WIDTH = 50
HEIGHT = 5


class TestDay8(TestCase):
    def assertScreenCorrect(self, expected_width, expected_height):
        screen = self.solver.generate_screen(expected_width, expected_height)
        self.assertEqual(expected_height, len(screen))
        for row in screen:
            self.assertEqual(expected_width, len(row))

    def assertPixel(self, x, y):
        self.assertEqual("#", self.solver.screen[y][x])

    def assertRectangle(self, width, height):
        for i in range(height):
            for j in range(width):
                self.assertPixel(j, i)

    def setUp(self):
        super().setUp()
        self.solver = Day8(WIDTH, HEIGHT)

    def test_givenWidthAndHeightOfOne_whenGeneratingScreen_returnOneByOneList(self):
        self.assertScreenCorrect(1, 1)

    def test_givenWidthOfOneAndHeightOfTen_whenGeneratingScreen_returnOneByTenList(self):
        self.assertScreenCorrect(1, 10)

    def test_givenWidthOfTenAndHeightOfOne_whenGeneratingScreen_returnTenByOneScreen(self):
        self.assertScreenCorrect(10, 1)

    def test_givenWidthOfTenAndHeightOfFive_whenGeneratingScreen_returnTenByFiveScreen(self):
        self.assertScreenCorrect(10, 5)

    def test_givenRectOneByOne_whenDrawingRectangle_drawHashInTopLeftCorner(self):
        self.solver.draw_rect(1, 1)
        self.assertRectangle(1, 1)

    def test_givenRectOneByFive_whenDrawingRectangle_DrawOneByFiveHashes(self):
        self.solver.draw_rect(1, 5)
        self.assertRectangle(1, 5)

    def test_givenRectFiveByOne_whenDrawingRectangle_DrawFiveByOneHashes(self):
        self.solver.draw_rect(5, 1)
        self.assertRectangle(5, 1)

    def test_givenRectFiveByFive_whenDrawingRectangle_drawFiveByFiveRectangle(self):
        self.solver.draw_rect(5, 5)
        self.assertRectangle(5, 5)

    def test_givenRotatingXByOneWithPixelInLeftMostColumn_whenRotating_movePixelRightOne(self):
        self.solver.draw_rect(1, 1)
        self.solver.rotate_x(0, 1)
        self.assertPixel(1, 0)

    def test_givenRotatingXByTwoWithPixelInLeftMostColumn_whenRotating_movePixelRightTwo(self):
        self.solver.draw_rect(1, 1)
        self.solver.rotate_x(0, 2)
        self.assertPixel(2, 0)

    def test_givenRotatingXByOnePixelOnRowTwoWithPixelInLeftMostColumn_whenRotating_movePixelRightOne(self):
        self.solver.draw_rect(1, 2)
        self.solver.rotate_x(1, 1)
        self.assertPixel(1, 1)

    def test_givenRotatingXByOnePixelWhenPixelIsInLastColumn_whenRotating_movePixelToFirstColumn(self):
        self.solver.screen[0][WIDTH - 1] = "#"
        self.solver.rotate_x(0, 1)
        self.assertPixel(0, 0)

    def test_givenRotatingYByOnePixelInFirstColumnWithPixelInFirstRow_whenRotating_movePixelDownOneSquare(self):
        self.solver.draw_rect(1, 1)
        self.solver.rotate_y(0, 1)
        self.assertPixel(0, 1)

    def test_givenRotatingYByTwoPixelsInFirstColumnWithPixelInFirstRow_whenRotating_movePixelDownTwoSquares(self):
        self.solver.draw_rect(1, 1)
        self.solver.rotate_y(0, 2)
        self.assertPixel(0, 2)

    def test_givenRotatingYByOnePixelInFirstColumnWithPixelInLastRow_whenRotating_movePixelToTopRow(self):
        self.solver.screen[HEIGHT - 1][0] = "#"
        self.solver.rotate_y(0, 1)
        self.assertPixel(0, 0)

    def test_givenRotatingYByOnePixelInSecondColumnWithPixelInFirstRow_whenRotating_movePixelDownOne(self):
        self.solver.screen[0][1] = "#"
        self.solver.rotate_y(1, 1)
        self.assertPixel(1, 1)

    def test_givenRectCommand_whenParsingCommand_CreateCorrectRectangle(self):
        self.solver.parse_command("rect 2x3")
        self.assertRectangle(2, 3)

    def test_givenRotateRowCommand_whenParsingCommand_RotateCorrectly(self):
        self.solver.screen[0][0] = "#"
        self.solver.parse_command("rotate row y=0 by 1")
        self.assertPixel(1, 0)

    def test_givenRotateColCommand_whenParsingCommand_RotateCorrectly(self):
        self.solver.screen[0][0] = "#"
        self.solver.parse_command("rotate column x=0 by 1")
        self.assertPixel(0, 1)

    def test_givenRotateColCommandWithColumnTen_whenParsingCommand_RotateCorrectly(self):
        self.solver.screen[0][10] = "#"
        self.solver.parse_command("rotate column x=10 by 1")
        self.assertPixel(10, 1)

    def test_givenOnePixelOn_whenCountingOnPixels_returnOne(self):
        self.solver.screen[0][0] = "#"
        self.assertEqual(1, self.solver.count_on_pixels())

    def test_givenTenPixelsOn_whenCountingOnPixels_returnTen(self):
        self.solver.draw_rect(5, 2)
        self.assertEqual(10, self.solver.count_on_pixels())

    def test_givenOneCommand_whenRunningCommands_runCommandSuccessfully(self):
        self.solver.run_commands(["rect 2x3"])
        self.assertRectangle(2, 3)

    def test_givenTwoCommands_whenRunningCommands_runCommandsSuccessfully(self):
        self.solver.run_commands(["rect 1x1", "rotate row y=0 by 1"])
        self.assertPixel(1, 0)
