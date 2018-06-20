local composer = require("composer")
local scene = composer.newScene()
local Prefs = require("Prefs")

local bg
local cookie
local titleText
local inventoryText
local titleGroup
local doneAnimating

function scene:create(e)

	local brownGradientFill = {
		type = "gradient",
		color1 = {--Roughly, brown
			65/255, --Red
			34/255, --Green
			0, --Blue
			1 --Alpha
		},
		color2 = {--Roughly, a darker brown
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

	--Load an image from the images folder of a cookie
	cookie = display.newImageRect("images/cookie.png", 220, 170)
	cookie.alpha = 0
	
	--Create some title text
	local font = Prefs.header.font
	local size = Prefs.header.size
	titleText = display.newText("Cookie Search", 0, 0, font, size)
	titleText.alpha = 0

	--Create some menu text
	font = Prefs.subheader.font
	size = Prefs.subheader.size
	inventoryText = display.newText("Our cookies", 0, 0, font, size)
	inventoryText.alpha = 0

	--Create a group to hold the cookie image and the title text
	titleGroup = display.newGroup()

	titleGroup:insert(cookie)
	titleGroup:insert(titleText)
	titleGroup:insert(inventoryText)

	--Position the text object after insertion into the group
	titleText.y = cookie.height * 0.5 + 36

	--Position the menu text
	inventoryText.y = titleText.y + inventoryText.height + 36

	--Position the group
	titleGroup.x = _SCREEN.CENTER.x
	titleGroup.y = _SCREEN.CENTER.y - 48

	self.view:insert(bg)
	self.view:insert(titleGroup)

	--Animate the cookie and titleText
	transition.from(cookie, {
		time = 1000,
		yScale = 0.1,
		xScale = 0.1,
		transition = easing.outBounce,
		onComplete = function()
			print("cookie complete")
		end
	})
	transition.to(cookie,{
		time = 1000,
		alpha = 1,
		transition = easing.outQuad,
		onComplete = function()
			print("cookie complete")
		end
	})
	transition.to(titleText,{
		time = 1000,
		delay = 750,
		alpha = 1,
		transition = easing.outQuad,
		onComplete = function()
			inventoryText.alpha = 1
		end
	})
end

function scene:show(e)
	if(e.phase == "will") then
		function inventoryText:tap(e)
			composer.gotoScene("inventory", {effect="slideLeft"})
		end
		inventoryText:addEventListener("tap", inventoryText)
	end
end

function scene:hide(e)
	if(e.phase == "will") then
		composer.removeScene("menu")
	end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene 








