local json = require("json")

local Prefs = {}
local path = system.pathForFile("Prefs.txt", system.DocumentsDirectory)
local file = io.open(path)

local function readPrefs()
	print("PREFS FILE EXIST; NOW LOADING")
	local content = file:read("*a")
	Prefs = json.decode(content)
end

local function initPrefs()
	print("PREFS FILE DOES NOT EXIST; WILL CREATE")
	Prefs = {}

	Prefs.nav = {
		height = 44
	}
	
	Prefs.margin = 12

	Prefs.header = {
		font = "AmericanTypewriter-Bold" or native.systemFont,
		size = 36,
		color = {1,1,1,1}
	}

	Prefs.subheader = {
		font = Prefs.header.font,
		size = 24,
		color = {1,1,1,1}
	}

	Prefs.body = {
		font = "AmericanTypewriter" or native.systemFont,
		size = 16
	}

	Prefs.menu = {
		font = Prefs.header.font,
		size = 18
	}

end

local function savePrefs()
	local prefs = {}

	for key, val in pairs(Prefs) do
		local kind = type(val)
		if(kind ~= "function") then
			prefs[key] = val
		end
		print(type(val))
	end

	file = io.open(path, "w")
	local JSON_Prefs = json.encode(prefs)
	file:write(JSON_Prefs)
	io.close(file)
end

if(file) then
	print("PREFS FILE EXISTS; NOW LOADING")
	readPrefs()
else
	print("PREFS FILE DOES NOT EXIST; WILL CREATE")
	--File dosen;t exist;
	initPrefs()
	savePrefs()
end

function Prefs:setHeaderColor(color, obj)
	Prefs.header.color = color
	--This is optional: update the affected object to display the change immediately
	obj.fill = color
	
	savePrefs()
end

return Prefs