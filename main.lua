function love.load()
	Object = require("objects/object")
	OptObject = require("objects/optobject")
	
	TileMap = require("objects/tilemap")
	TileLayer = require("objects/tilelayer")
	
	GameWindow = require("window/window")
	GameWindow.pixelPerfect()
	
	-- Set up pixel font
	local supportedCharacters = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~◆◇▼▲▽△★☆■□"
	font = love.graphics.newImageFont("resources/font_6x8.png", supportedCharacters)
	love.graphics.setFont(font)
	
	require "game"
	
	window = GameWindow{
		title = "VieWS",
		version = "v0.1",
		icon = love.image.newImageData("resources/icon.png"),
		
		screen = {
			width  = 360,
			height = 240
		},
		
		mouse = {
			cursors = {
				["mouse"] = {
					image = love.graphics.newImage("resources/cursors/mouse.png"),
					home = {x = 0, y = 0} -- home on first white pixel
					-- home = {x = 1, y = 2} -- home on first black pixel
				},
				["hand"] = {
					image = love.graphics.newImage("resources/cursors/hand.png"),
					home = {x = 4, y = 0} -- home on first white pixel
					-- home = {x = 4, y = 1} -- home on first black pixel
				},
				["movable"] = {
					image = love.graphics.newImage("resources/cursors/movable.png"),
					home = {x = 4, y = 0} -- home on first white pixel
					-- home = {x = 4, y = 1} -- home on first black pixel
				},
				["move"] = {
					image = love.graphics.newImage("resources/cursors/move.png"),
					home = {x = 4, y = 0} -- home on first white pixel
					-- home = {x = 4, y = 1} -- home on first black pixel
				}
			},
			defaultCursor = "mouse"
		},
		debug = true,
		
		setup = setup,
		update = update,
		draw = draw
	}
	
	-- Modified version of drawMouse function with shadow
	function window:drawMouse()
		local cc = self.mouse.cursors[self.mouse.currentCursor]
		
		if type(cc) ~= "table" then return end
		if not cc.image then return end
		
		local shadowDistance = 1
		
		if self.screen then
			if self.running then
				love.graphics.setScissor(self.screen.x, self.screen.y, self.screen.width * self.screen.scale, self.screen.height * self.screen.scale)
				
				love.graphics.setColor(0, 0, 0, 0.25)
				love.graphics.draw(cc.image, self.screen.x + (self.mouse.sx - cc.home.x + shadowDistance) * self.screen.scale, self.screen.y + (self.mouse.sy - cc.home.y + shadowDistance) * self.screen.scale, 0, self.screen.scale)
				
				love.graphics.setColor(1, 1, 1)
				love.graphics.draw(cc.image, self.screen.x + (self.mouse.sx - cc.home.x) * self.screen.scale, self.screen.y + (self.mouse.sy - cc.home.y) * self.screen.scale, 0, self.screen.scale)
				
				love.graphics.setScissor()
			else
				love.graphics.setColor(0, 0, 0, 0.25)
				love.graphics.draw(cc.image, self.mouse.x - (cc.home.x + shadowDistance) * self.screen.scale, self.mouse.y - (cc.home.y + shadowDistance) * self.screen.scale, 0, self.screen.scale)
				
				love.graphics.setColor(1, 1, 1)
				love.graphics.draw(cc.image, self.mouse.x - cc.home.x * self.screen.scale, self.mouse.y - cc.home.y * self.screen.scale, 0, self.screen.scale)
			end
		else
			love.graphics.setColor(0, 0, 0, 0.25)
			love.graphics.draw(cc.image, self.mouse.x - cc.home.x + shadowDistance, self.mouse.y - cc.home.y + shadowDistance)
			
			love.graphics.setColor(1, 1, 1)
			love.graphics.draw(cc.image, self.mouse.x - cc.home.x, self.mouse.y - cc.home.y)
		end
	end
	
	window:setup()
end

function love.update(dt)
	window:update(dt)
end

function love.draw()
	window:draw()
end
