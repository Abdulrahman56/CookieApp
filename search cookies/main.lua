_SCREEN = {
	HEIGHT = display.contentHeight,
	WIDTH = display.contentWidth
}
--Add to the SCREEN table the centerpoint of the screen
_SCREEN.CENTER = {
	x = display.contentCenterX,
	y = display.contentCenterY
}

display.setStatusBar(display.HiddenStatusBar)

--Import the storyboard library
local composer = require("composer")
composer.gotoScene("menu")