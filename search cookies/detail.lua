local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")
local Prefs = require("Prefs")
local cookies = require("cookies")

local navHeight = 44
local bg
local img
local titleText
local shadowText
local descriptionText
local menuBtn

function scene:create(e)
	local index = e.params.index
	local cookies = cookies[index]
	local brownGradientFill = {
		type = "gradient",
		color1 = {--Roughly, brown
			65/255, --Red
			34/255, --Green
			0, --Blue
			1 --Alpha
		},
			color2 = {
			75/255,
			38/255,
			0/255,
			1
		},
	direction = "down" --"down", "up", "left", "right"
	}
	bg = display.newRect(0, 0, _SCREEN.WIDTH, _SCREEN.HEIGHT)
	bg.x = _SCREEN.CENTER.x
	bg.y = _SCREEN.CENTER.y
	bg.fill = brownGradientFill

	img = display.newImageRect(cookies.image,320,180)
	img.anchorX = 0
	img.anchorY = 0
	img.y = navHeight

	local font = Prefs.subheader.font
	local size = Prefs.subheader.size
	titleText = display.newText(cookies.name, 0, 0, font, size)
	titleText.anchorX = 0
	titleText.anchorY = 1
	titleText.x = Prefs.margin
	titleText.y = img.y + img.height - 12

	shadowText = display.newText(cookies.name, 0, 0, font, size)
	shadowText.anchorX = 0
	shadowText.anchorY = 1
	shadowText.x = titleText.x+1
	shadowText.y = titleText.y+1
	shadowText.fill = {0,0,0,1}

	--Use the declartion style to set a width for the text box
	--where the text will wrap to the width
	font = Prefs.body.font
	size = Prefs.body.size
	descriptionText = display.newText({
		text = cookie.description,
		width = _SCREEN.WIDTH - (Prefs.margin * 2),
		font = font,
		fontSize = size 
	})
	descriptionText.anchorX = 0
	descriptionText.anchorY = 0
	descriptionText.x = Prefs.margin
	descriptionText.y = img.y + img.height + Prefs.margin

	font = Prefs.menu.font
	size = Prefs.menu.size
	menuBtn = display.newText("< Our Cookies", 0, 0, font, size)
	menuBtn.anchorX = 0
	menuBtn.x = Prefs.margin
	menuBtn.y = navHeight * 0.5

	self.view:insert(bg)
	self.view:insert(img)
	self.view:insert(shadowText)
	self.view:insert(titleText)
	self.view:insert(descriptionText)
	self.view:insert(menuBtn)
end

function scene:show(e)
	if(e.phase == "will") then
		function menuBtn:tap(e)
			composer.gotoScene("inventory", {effect="slideRight"})
		end
		menuBtn:addEventListener("tap", menuBtn)
	end
end

function scene:hide(e)
	if(e.phase == "will") then
		composer.removeScene("detail")
	end
end

-- "create" event is dispatched if scene's view does not exist
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

--Important: return the scene var
return scene;