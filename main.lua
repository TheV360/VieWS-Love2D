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
		title = "Template",
		icon = love.image.newImageData("resources/icon.png"),
		
		screen = {
			width  = 360,
			height = 240
		},
		
		mouse = {
			-- image = love.graphics.newImage("resources/mouse.png"),
			-- home = {x = 1, y = 2},
			
			image = love.graphics.newImage("resources/hand.png"),
			home = {x = 4, y = 1}
		},
		debug = true,
		
		setup = setup,
		update = update,
		draw = draw
	}
	
	function window:drawMouse()
		local shadowDistance = 1
		
		if self.screen then
			if self.running then
				if self.mouse.show then
					love.graphics.setScissor(self.screen.x, self.screen.y, self.screen.width * self.screen.scale, self.screen.height * self.screen.scale)
					
					love.graphics.setColor(0, 0, 0, 0.25)
					love.graphics.draw(self.mouse.image, self.screen.x + (self.mouse.sx - self.mouse.home.x + shadowDistance) * self.screen.scale, self.screen.y + (self.mouse.sy - self.mouse.home.y + shadowDistance) * self.screen.scale, 0, self.screen.scale)
					
					love.graphics.setColor(1, 1, 1)
					love.graphics.draw(self.mouse.image, self.screen.x + (self.mouse.sx - self.mouse.home.x) * self.screen.scale, self.screen.y + (self.mouse.sy - self.mouse.home.y) * self.screen.scale, 0, self.screen.scale)
					
					love.graphics.setScissor()
				end
			else
				love.graphics.setColor(0, 0, 0, 0.25)
				love.graphics.draw(self.mouse.image, self.mouse.x - (self.mouse.home.x + shadowDistance) * self.screen.scale, self.mouse.y - (self.mouse.home.y + shadowDistance) * self.screen.scale, 0, self.screen.scale)
				
				love.graphics.setColor(1, 1, 1)
				love.graphics.draw(self.mouse.image, self.mouse.x - self.mouse.home.x * self.screen.scale, self.mouse.y - self.mouse.home.y * self.screen.scale, 0, self.screen.scale)
			end
		else
			love.graphics.setColor(0, 0, 0, 0.25)
			love.graphics.draw(self.mouse.image, self.mouse.x - self.mouse.home.x + shadowDistance, self.mouse.y - self.mouse.home.y + shadowDistance)
			
			love.graphics.setColor(1, 1, 1)
			love.graphics.draw(self.mouse.image, self.mouse.x - self.mouse.home.x, self.mouse.y - self.mouse.home.y)
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
