local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")
local Prefs = require("Prefs")
local cookies = require("cookies")

local navHeight = 44
local bg
local tableView
local menuBtn

local function onRowRender(e)
	local row = e.row --this is the row's display group
	local rowIndex = row.index
	local rowLabel
	local rowThumbnail

	--This is a known bug
	-- http://forums.coronalabs.com/topic/38014-tableview-params-working-for-anyone/
	if(e.row.params == nil) then
		rowLabel = ""
		rowThumbnail = ""
	else  
		rowLabel = e.row.params.title  
		rowThumbnail = e.row.params.thumbnail
	end
	
	row.rowThumbnail = display.newImageRect(rowThumbnail, 60, 60)
	row.rowThumbnail.anchorX = 0
	row.rowThumbnail.x = Prefs.margin
	row.rowThumbnail.y = row.height * 0.5

	local font = Prefs.body.font
	local size = Prefs.body.size

	row.rowText = display.newText(rowLabel, 0, 0, font, size)
	row.rowText.anchorX = 0
	row.rowText.x = row.rowThumbnail.width + row.rowThumbnail.x + Prefs.margin
	row.rowText.y = row.height * 0.5
	row.rowText.fill = {0,0,0,1}

	row:insert(row.rowThumbnail)
	row:insert(row.rowText)
end

local function onRowTouch(e)
	if(e.phase == "tap") then
		if(e.target.params) then
			composer.gotoScene("detail", {
				effect = "slideLeft",
				params = {
					index = e.target.params.index
				}
			})
		end
	end
end

function scene:create(e)
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

	local font = Prefs.menu.font
	local size = Prefs.menu.size

	menuBtn = display.newText("< Menu", 0, 0, font, size)
	menuBtn.anchorX = 0
	menuBtn.x = Prefs.margin 
	menuBtn.y = navHeight * 0.5

	local tableView = widget.newTableView({
		left = 0,
		top = navHeight,
		height = _SCREEN.HEIGHT - navHeight,
		width = _SCREEN.WIDTH,
		--This is the method that is called each time a row is rendered
		onRowRender = onRowRender,
		--This is the method that is called each time a row is touched
		onRowTouch = onRowTouch
	})

	self.view:insert(bg)
	self.view:insert(tableView)
	self.view:insert(menuBtn)

	--Populate the table with rows
	for i = 1, #cookies do
		local cookie = cookies[i].name
		local thumbnail = cookies[i].thumbnail

		local params = {
			isCategory = false,
			rowHeight = 60,
			rowColor = {
				default = {1,1,1,1},
				over = {1,1,1,1}
			},
			params = {
				title = cookie,
				thumbnail = thumbnail,
				index = i
			}
		}
		--Insert the cookie row
		tableView:insertRow(params)
	end

end

function scene:show(e)
	if(e.phase == "will") then
		function menuBtn:tap(e)
			composer.gotoScene("menu", {effect="slideRight"})
		end
		menuBtn:addEventListener("tap", menuBtn)
	end
end

function scene:hide(e)
	if(e.phase == "will") then
		composer.removeScene("inventory.lua")
	end
end

-- "create" event is dispatched if scene's view does not exist
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

--Important: return the scene var
return scene;