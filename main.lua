-- OOP stuff.
Object = require("util.object") -- Renamed from "Classic" by rxi
OptObject = require("util.optobject")

-- Math stuff.
VectorTypes = require("util.geometry.vector")
Vec2, Vec3, Vec4 = unpack(VectorTypes.float)

-- Helpful stuff.
CallbackWrapper = require("util.callbackwrapper")
InputHandler = require "util.input" -- Renamed from "Baton" by Tesselode
PixelScreen = require("util.pixelscreen")
Util = require("util.util")
utf8 = require("utf8")

-- Gives you a console and a stats widget. Pretty good. Maybe I'm biased.
-- You can pass "false" to this and the debug tools will be disabled.
DebugHelper = require("debug.helper")(true)

function love.load()
	-- Makes everything nice and pixel-perfect.
	PixelScreen.PixelPerfect()
	
	-- Set up pixel font.
	local supportedCharacters = [[ !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~◆◇▼▲▽△★☆■□🙂☹←↑→↓😔🙃]]
	font = love.graphics.newImageFont("resources/fonts/6x8.png", supportedCharacters)
	
	-- local supportedCharacters = [[ !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~]]
	-- font = love.graphics.newImageFont("resources/fonts/graph.png", supportedCharacters, 1)
	
	-- local supportedCharacters = [[ !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~]]
	-- font = love.graphics.newImageFont("resources/fonts/ms_gothic.png", supportedCharacters)
	
	love.graphics.setFont(font)
	
	require("views/views")
	
	screen = PixelScreen(Vec2(512, 342))
	screen:centerScaleIn(Vec2(love.graphics.getDimensions()))
	CallbackWrapper:addLoveFunction('resize', function(width, height)
		screen:centerScaleIn(Vec2(width, height))
	end, "screen resize")
	
	-- Adds a few (okay, one... so far) shortcuts to do common tasks.
	CallbackWrapper:addLoveFunction("keypressed", function(key)
		if key == "f4" then
			love.window.setFullscreen(not love.window.getFullscreen())
			screen:centerScaleIn(Vec2(love.graphics.getDimensions()))
		end
	end, "shortcuts")
	
	Util.setWindowIdentity {
		name = "VieWS", version = "0.1",
		icon = "resources/icon.png",
	}
	
	-- Keyboard repeaaaaaaaaaaaaaaaaaaaaaaaat
	love.keyboard.setKeyRepeat(true)
	
	view = VieWS{
		width  = screen.size.x,
		height = screen.size.y,
	}
	
	require("apps/init")
	
	timeSpent = 0
end

function love.update(dt)
	-- Update VieWS
	view:update(dt)
	
	-- Maybe update the debug tools.
	DebugHelper:update(dt)
	
	-- Push time forward.
	timeSpent = timeSpent + dt
end

function love.draw()
	love.graphics.clear()
	
	love.graphics.setColor(1, 1, 1)
	screen:renderThenDraw(function()
		-- Update VieWS
		view:draw()
	end)
	
	-- Maybe draw the debug tools.
	love.graphics.setColor(1, 1, 1)
	DebugHelper:draw(screen, font)
end
