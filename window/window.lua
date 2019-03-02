require "window/util"

local Window = Object:extend()

local function isTable(n)
	return type(n) == "table"
end

function Window.pixelPerfect()
	love.graphics.setDefaultFilter("nearest", "nearest", 1)
	love.graphics.setLineStyle("rough")
	love.graphics.setLineWidth(1)
end

function Window:new(o)
	o = o or {}
	
	-- Game Title & Save Folder Name
	self.title = o.title or "Untitled"
	self.version = o.version or "v0.0"
	
	-- Icon
	self.icon = o.icon or nil
	
	-- Window Position
	self.width, self.height = o.width or 640, o.height or 480
	self.fullscreen = o.fullscreen or false
	
	-- Game Running
	self.running = true
	
	-- Game Tick
	self.tick = 0.0
	self.tickMaximum = 1.0 / 60.0
	
	-- Game Frames
	self.frames = 0
	self.trueFrames = 0
	-- === Why have separate window.frames and window.trueFrames? ===
	-- Your draw function should use window.frames so that it completely freezes when the debug menu is up.
	-- If you never debug, you can just delete window.trueFrames and nothing will be different.
	
	-- Game callbacks
	self.callbacks = {}
	self.callbacks.setup = o.setup
	self.callbacks.update = o.update
	self.callbacks.draw = o.draw
	
	-- Love Function Management
	self.loveFunctions = require("window/loveFunctions")
	self.loveFunctions.addLoveFunctionWithRunCheck = function(lf, key, name, func)
		lf:addLoveFunction(key, name, function(...)if self.running then func(...) end end)
	end
	
	-- Screen Size
	if o.screen then
		local n = {
			scale = 2,
			x = 0, y = 0
		}
		self.screen = n
		
		if not isTable(o.screen) then o.screen = {} end
		
		n.width  = o.screen.width  or 360
		n.height = o.screen.height or 240
		
		n.canvas = love.graphics.newCanvas(n.width, n.height)
	end
	
	-- Backdrop
	if o.backdrop then
		local n = {}
		self.backdrop = n
		
		assert(isTable(o.backdrop), "(Window.backdrop) Please make backdrop a table.")
		assert(o.backdrop.image, "(Window.backdrop) Please include a background image.")
		
		n.image = o.backdrop.image
		n.image:setWrap("repeat", "repeat")
		
		n.width, n.height = n.image:getDimensions()
		
		self:updateBackdropQuad()
	end
	
	-- Screen Shake
	if o.shake then
		local n = {
			-- Shake X and Y
			x = 0, y = 0,
			
			-- Calculated Shake X and Y
			cx = 0, cy = 0
		}
		self.shake = n
		
		if not isTable(o.shake) then o.shake = {} end
		
		n.enabled = false
		
		n.screenCoords = o.shake.screenCoords or false
		n.extremes = o.shake.extremes or true
		n.windowBonk = o.shake.windowBonk or true
	end
	
	-- Button
	if o.button then
		self.button = {}
		
		if isTable(o.button) then
			local k, _
			local buttons = {}
			
			for k, _ in pairs(o.button) do
				table.insert(buttons, k)
			end
			
			self.button = Util.watch(buttons, function(key) return love.keyboard.isDown(self.button.map[key]) end)
			self.button.map = o.button
		end
	end
	
	-- Mouse
	if o.mouse then
		local n = Util.watch({1, 2, 3, 4, 5}, function(key) return love.mouse.isDown(key) end)
		self.mouse = n
		
		if not isTable(o.mouse) then o.mouse = {} end
		
		n.show = true
		n.image = o.mouse.image or nil
		
		n.x, n.y = 0, 0
		
		n.home = {
			x = o.mouse.home and o.mouse.home.x or 0,
			y = o.mouse.home and o.mouse.home.y or 0
		}
	end
	
	-- Debug
	if o.debug then
		local n = {}
		self.debug = n
		
		if not isTable(o.debug) then o.debug = {} end
		
		n.profile = o.debug.profile or false
		
		n.console = require("window/debug/console")
		n.menu = require("window/debug/menu")
		n.stats = require("window/debug/stats")
		
		n.keys = {
			menu  = o.debug.keys and o.debug.keys.menu  or "=",
			stats = o.debug.keys and o.debug.keys.stats or "-"
		}
		
		-- Default Debug Stuff Ahead
		
		self.loveFunctions:addLoveFunction("keypressed", "ConsoleKeyPressed", function(key)
			if self.debug.console.enabled or key == self.debug.openKey then
				self.debug.console:keypressed(key)
			elseif key == self.debug.keys.menu then
				-- if self.running then
				-- 	if self.screen then
				-- 		self.screen.x = self.screen.x + (16 * self.screen.scale)
				-- 	end
				-- else
				-- 	if self.screen then
				-- 		self:updateScreen(self.width, self.height)
				-- 	end
				-- end
				
				-- Toggle menu
				self.debug.menu.enabled = self.running
				
				-- Toggle game
				self.running = not self.running
			elseif key == self.debug.keys.stats then
				self.debug.stats.enabled = not self.debug.stats.enabled
			end
		end)
		self.loveFunctions:addLoveFunction("textinput", "ConsoleInput", function(key)
			self.debug.console:textinput(key)
		end)
		
		self.debug.menu:addOption("Toggle Stats", function() self.debug.stats.enabled = not self.debug.stats.enabled end)
		self.debug.menu:addOption("Toggle Console", function() self.debug.console.enabled = not self.debug.console.enabled end)
		self.debug.menu:addDivider()
		self.debug.menu:addOption("Take Screenshot", function()
			if window.backdrop.enabled then
				love.graphics.captureScreenshot(window.title .. " " .. window.version .. " " .. os.time() .. ".png")
			else
				window.screen.canvas:newImageData():encode("png", window.title .. " " .. window.version .. " " .. os.time() .. ".png")
			end
			
			print("Screenshot taken!")
		end)
		self.debug.menu:addOption("Exit Game", love.event.quit)
		
		if self.debug.profile then
			self.debug.profiler = require("modules/debug/profile")
			self.debug.profiler.hookall("Lua")
			self.debug.profiler.start()
		end
	end
	
	-- Data now exists, do stuff with this data
	
	-- Set up screen size and position
	if self.screen then
		self.width  = self.screen.width  * self.screen.scale
		self.height = self.screen.height * self.screen.scale
		self:updateScreen()
	end
	
	-- Make window proper size, look nice, and save to the right place
	love.window.setMode(self.width, self.height, {
		vsync = true,
		resizable = true,
		
		fullscreen = self.fullscreen
	})
	love.window.setTitle(self.title)
	love.filesystem.setIdentity(self.title)
	
	-- The window has moved to its proper place. Now you can do window position functions
	self.x, self.y = love.window.getPosition()
	
	-- Update mouse coords before any of your code runs
	if self.mouse then
		self:updateMouse()
	end
	
	-- If there's an icon, add that too.
	if self.icon then
		love.window.setIcon(self.icon)
	end
	
	-- F4 will make the window fullscreen. Feel free to remove this.
	self.loveFunctions:addLoveFunction("keypressed", "WindowKeys", function(key)
		if key == "f4" then
			self.fullscreen = not self.fullscreen
			love.window.setFullscreen(self.fullscreen)
		end
	end)
	
	-- Don't remove this. It resizes and repositions the smaller screen on resize.
	self.loveFunctions:addLoveFunction("resize", "WindowResize", function(width, height)
		self.width, self.height = width, height
		if self.screen then self:updateScreen() end
	end)
	
	-- If there's already a mouse graphic, don't draw this mouse
	love.mouse.setVisible(self.mouse.image == nil)
	
	-- Keyboard repeaaaaaaaaaaaaaaaaaaaaaaaat
	love.keyboard.setKeyRepeat(true)
end

function Window:setup()
	if self.callbacks.setup then
		self.callbacks.setup()
	end
end

function Window:update(dt)
	dt = math.min(dt, self.tickMaximum)
	self.tick = self.tick + dt
	
	if self.tick < self.tickMaximum then
		return
	else
		self.tick = self.tick - self.tickMaximum
	end
	
	-- Update button and mouse
	if self.button then
		self.button:update()
	end
	if self.mouse then
		self:updateMouse()
	end
	
	if self.running then
		if self.shake then
			if self.shake.enabled then
				self:calculateShake()
			else
				self.x, self.y = love.window.getPosition()
			end
		end
		
		if self.callbacks.update then
			self.callbacks.update(dt)
		end
		
		if self.shake then
			self:autoShake()
		end
	end
	
	-- Debug stuff
	if self.debug then
		self.debug.console:update()
		self.debug.menu:update()
		self.debug.stats:update()
	end
	
	if self.running then self.frames = self.frames + 1 end
	self.trueFrames = self.trueFrames + 1
end

function Window:draw()
	-- Reset Color
	love.graphics.setColor(1, 1, 1)
	
	if self.backdrop then
		love.graphics.draw(
			self.backdrop.image,
			self.backdrop.quad,
			-(math.floor(self.trueFrames / 2) % self.backdrop.width),
			-(math.floor(self.trueFrames / 2) % self.backdrop.height)
		)
	end
	
	-- Reset Color
	love.graphics.setColor(1, 1, 1)
	
	if self.screen then
		if self.callbacks.draw and self.running then
			self.screen.canvas:renderTo(self.callbacks.draw)
		end
		
		-- Reset Color
		love.graphics.setColor(1, 1, 1)
		
		if self.shake and self.shake.enabled then
			if self:canShakeWindow() then
				-- I n n o v a t i o n
				love.window.setPosition(self.x + self.shake.cx, self.y + self.shake.cy)
				
				love.graphics.draw(self.screen.canvas, self.screen.x - self.shake.cx, self.screen.y - self.shake.cy, 0, self.screen.scale)
			else
				love.graphics.draw(self.screen.canvas, self.screen.x + self.shake.cx, self.screen.y + self.shake.cy, 0, self.screen.scale)
			end
		else
			love.graphics.draw(self.screen.canvas, self.screen.x, self.screen.y, 0, self.screen.scale)
		end
	else
		if self.callbacks.draw then
			self.callbacks.draw()
		end
		
		if self:canShakeWindow() then
			love.window.setPosition(self.x + self.shake.x, self.y + self.shake.y)
		end
	end
	
	if self.debug then
		self.debug.console:draw()
		self.debug.menu:draw()
		self.debug.stats:draw()
	end
	
	-- Reset Color
	love.graphics.setColor(1, 1, 1)
	
	-- Draw mouse
	if self.mouse and self.mouse.image then
		self:drawMouse()
	end
	
	-- Profiler
	if self.debug and self.debug.profile and self.trueFrames % 60 == 0 then
		local report = self.debug.profiler.report("time", 20)
		print(report)
		self.debug.profiler.reset()
	end
end

function Window:updateScreen()
	local w, h
	
	self.screen.scale = math.max(1, math.floor(math.min(self.width / self.screen.width, self.height / self.screen.height)))
	
	w = self.screen.width  * self.screen.scale
	h = self.screen.height * self.screen.scale
	
	self.screen.x = math.floor((self.width  - w) / 2)
	self.screen.y = math.floor((self.height - h) / 2)
	
	if self.backdrop then self:updateBackdropQuad() end
end

function Window:updateBackdropQuad()
	self.backdrop.quad = love.graphics.newQuad(0, 0, self.width + self.backdrop.width, self.height + self.backdrop.height, self.backdrop.width, self.backdrop.height)
end

function Window:updateMouse()
	self.mouse.ox, self.mouse.oy = self.mouse.x, self.mouse.y
	self.mouse.x, self.mouse.y = love.mouse.getPosition()
	
	if self.screen then
		self.mouse.osx, self.mouse.osy = self.mouse.sx, self.mouse.sy
		self.mouse.sx, self.mouse.sy = self:screenConvert(self.mouse.x, self.mouse.y)
		
		self.mouse.sx = math.max(0, math.min(self.mouse.sx, self.screen.width  - 1))
		self.mouse.sy = math.max(0, math.min(self.mouse.sy, self.screen.height - 1))
	end
	
	-- Also, the mouse is a watch, so update that.
	self.mouse:update()
end

function Window:drawMouse()
	if self.screen then
		if self.running then
			if self.mouse.show then
				love.graphics.setScissor(self.screen.x, self.screen.y, self.screen.width * self.screen.scale, self.screen.height * self.screen.scale)
				love.graphics.draw(self.mouse.image, self.screen.x + (self.mouse.sx - self.mouse.home.x) * self.screen.scale, self.screen.y + (self.mouse.sy - self.mouse.home.y) * self.screen.scale, 0, self.screen.scale)
				love.graphics.setScissor()
			end
		else
			love.graphics.draw(self.mouse.image, self.mouse.x - self.mouse.home.x * self.screen.scale, self.mouse.y - self.mouse.home.y * self.screen.scale, 0, self.screen.scale)
		end
	else
		love.graphics.draw(self.mouse.image, self.mouse.x - self.mouse.home.x, self.mouse.y - self.mouse.home.y)
	end
end

-- Automatically enables/disables shake when values do things
function Window:autoShake()
	if self.shake.enabled and (self.shake.x == 0 and self.shake.y == 0) then
		self.shake.enabled = false
		
		-- Put window back in place
		if self:canShakeWindow() then
			love.window.setPosition(self.x, self.y)
		end
	elseif not self.shake.enabled and (self.shake.x ~= 0 or self.shake.y ~= 0) then
		self.shake.enabled = true
	end
end

function Window:calculateShake()
	local ox, oy
	
	if self.shake.extremes then
		ox = math.random() >= .5 and self.shake.x or -self.shake.x
		oy = math.random() >= .5 and self.shake.y or -self.shake.y
	else
		ox = math.random(-self.shake.x, self.shake.x)
		oy = math.random(-self.shake.y, self.shake.y)
	end
	
	if self.screen and self.shake.screenCoords then
		ox = ox * self.screen.scale
		oy = oy * self.screen.scale
	end
	
	self.shake.cx = math.floor(ox)
	self.shake.cy = math.floor(oy)
end

function Window:canShakeWindow()
	return self.shake and self.shake.windowBonk and love.window.isVisible() and not (self.fullscreen or love.window.isMaximized())
end

function Window:screenConvert(x, y)
	return math.floor((x - self.screen.x) / self.screen.scale), math.floor((y - self.screen.y) / self.screen.scale)
end

return Window
