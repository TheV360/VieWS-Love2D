-- VieWS.

require("views/geometry")

VieWSRect = require("views/viewsrect")
VieWSEventRect = require("views/eventrect")
Desktop = require("views/desktop")
Popup = require("views/popup")

Effects = {}
Effects.Effect = require("views/effects/effect")
Effects.OpenWindow = require("views/effects/openWindow")
Effects.CloseWindow = require("views/effects/closeWindow")

Controls = {}
Controls.Control = require("views/controls/control")
Controls.Panel = require("views/controls/panel")
Controls.Label = require("views/controls/label")
Controls.Image = require("views/controls/image")
Controls.Button = require("views/controls/button")
Controls.CheckBox = require("views/controls/checkbox")
Controls.Slider = require("views/controls/slider")
Controls.Picker = require("views/controls/picker")
Controls.PixelGrid = require("views/controls/pixelGrid")
Controls.Window = require("views/controls/window")

VieWS = VieWSRect:extend()
-- VieWS = VieWSEventRect:extend()

VieWS.WindowSort = function(wa, wb) return wa.z < wb.z end

VieWS.PALETTE_GRAY = {
	{ 0, 0, 0 },
	{ 1/3, 1/3, 1/3 },
	{ 2/3, 2/3, 2/3 },
	{ 1, 1, 1 },
}
VieWS.PALETTE_CGA = {
	{ 0, 0, 0 },
	{ 0, 1, 1 },
	{ 1, 0, 1 },
	{ 1, 1, 1 },
}
VieWS.PALETTE_PURPLE = {
	{ 0, 0, 0 },
	{ 3/5, 9/20, 13/15 },
	{ 9/10, 17/20, 1 },
	{ 1, 1, 1 },
}
VieWS.PALETTE_AYU_DARK = {
	{ 3/4, 3/4, 3/4 },
	{ 1, 180/255, 84/255 },
	{ 178/255, 148/255, 187/255 },
	{ 15/255, 20/255, 26/255 },
}
VieWS.PALETTE = VieWS.PALETTE_CGA

function VieWS:new(o)
	VieWS.super.new(self, o)
	
	-- The mouse
	self.mouse = {
		x = 0, y = 0,
		
		drag = {
			index = nil,
			
			-- Offset while dragging
			x = 0,
			y = 0
		}
	}
	
	-- Desktop
	self.desktop = Desktop{
		parent = self
	}
	
	-- Popups (right click stuff, menu bar stuff.)
	self.popups = {}
	
	-- Window stuff
	self.windows = {}
	
	-- For getting width and height of text
	self.font = love.graphics.getFont()
	
	-- Stack of effects objects (window close, etc.)
	self.effects = {}
	
	-- Handles all love callbacks
	self.loveFunctions = o.loveFunctions
	
	-- Lazy way to do this...
	self.corner = love.graphics.newImage("resources/corner.png")
end

function VieWS:addWindow(w)
	w.parent = self
	w.z = #self.windows + 1
	
	table.insert(self.windows, w)
end

function VieWS:update(dt)
	local i, w, tmp
	
	-- FX
	for i = #self.effects, 1, -1 do
		self.effects[i].life = self.effects[i].life - 1
		
		if self.effects[i].life < 0 then
			table.remove(self.effects, i)
		end
	end
	
	self.mouse.x, self.mouse.y = window.mouse.sx, window.mouse.sy
	
	if self.mouse.drag.window then
		if not window.mouse.down[1] then
			self.mouse.drag.window = nil
			
			window:switchCursor("mouse")
		elseif self.mouse.drag.window then
			-- self.mouse.drag.window.velocity = Util.degreeDistance(self.mouse.drag.window.velocity, (self.mouse.drag.window.position.x - (self.mouse.x - self.mouse.drag.x)) * dt * 16)
			
			self.mouse.drag.window.position.x = self.mouse.x - self.mouse.drag.x
			self.mouse.drag.window.position.y = math.max(24, self.mouse.y - self.mouse.drag.y)
			
			window:switchCursor("move")
		end
	else
		window:switchCursor("mouse")
	end
	
	self.desktop:update()
	
	for i, w in ipairs(self.windows) do
		if w.onTop then
			w.z = 999 + i
		else
			w.z = i
		end
		
		w.hover = w:isOver(Point(self.mouse.x, self.mouse.y))
		
		if w.hover then
			self.mouse.windowTmp = w -- gets topmost window
		end
		
		w:update(dt)
	end
	
	if self.mouse.window and self.mouse.window ~= self.mouse.windowTmp then
		self.mouse.window:mouseExit(self.mouse)
	end
	
	self.mouse.window = self.mouse.windowTmp
	self.mouse.windowTmp = nil
	
	if self.mouse.window then
		local w = self.mouse.window
		
		w:mouse(self.mouse)
		
		if window.mouse.down[1] then w:mouseDown(self.mouse) end
		if window.mouse.release[1] then w:mouseUp(self.mouse) end
		
		if window.mouse.press[1] then
			-- Push window to front.
			w.z = #self.windows + 1
			
			w:mouseClick(self.mouse)
		end
	end
	
	-- Delete windows marked for deletion
	for i = #self.windows, 1, -1 do
		w = self.windows[i]
		
		if w.status == "open" then
			if w.border then
				table.insert(self.effects, Effects.OpenWindow{
					x = w.position.x - w.border.left,
					y = w.position.y - w.border.top,
					width = w.size.width + w.border.left + w.border.right,
					height = w.size.height + w.border.top + w.border.bottom
				})
			else
				table.insert(self.effects, Effects.OpenWindow{
					x = w.position.x,
					y = w.position.y,
					width = w.size.width,
					height = w.size.height
				})
			end
			w.status = "normal"
		elseif w.status == "close" then
			if w.border then
				table.insert(self.effects, Effects.CloseWindow{
					x = w.position.x - w.border.left,
					y = w.position.y - w.border.top,
					width = w.size.width + w.border.left + w.border.right,
					height = w.size.height + w.border.top + w.border.bottom
				})
			else
				table.insert(self.effects, Effects.CloseWindow{
					x = w.position.x,
					y = w.position.y,
					width = w.size.width,
					height = w.size.height
				})
			end
			table.remove(self.windows, i)
		end
	end
	
	-- Lua doesn't like it if you remove a numeric thing while it's in the pairs loop, hence the other loop.
	for i, w in pairs(self.windows) do
		if type(i) ~= "number" then
			if w.status == "open" then
				if w.border then
					table.insert(self.effects, Effects.OpenWindow{
						x = w.position.x - w.border.left,
						y = w.position.y - w.border.top,
						width = w.size.width + w.border.left + w.border.right,
						height = w.size.height + w.border.top + w.border.bottom
					})
				else
					table.insert(self.effects, Effects.OpenWindow{
						x = w.position.x,
						y = w.position.y,
						width = w.size.width,
						height = w.size.height
					})
				end
				w.status = "normal"
			elseif w.status == "close" then
				if w.border then
					table.insert(self.effects, Effects.CloseWindow{
						x = w.position.x - w.border.left,
						y = w.position.y - w.border.top,
						width = w.size.width + w.border.left + w.border.right,
						height = w.size.height + w.border.top + w.border.bottom
					})
				else
					table.insert(self.effects, Effects.CloseWindow{
						x = w.position.x,
						y = w.position.y,
						width = w.size.width,
						height = w.size.height
					})
				end
				self.windows[i] = nil
			end
		end
	end
	
	table.sort(self.windows, VieWS.WindowSort)
end

function VieWS:draw()
	local _, w
	
	self.desktop:draw()
	
	for _, w in ipairs(self.windows) do
		love.graphics.push()
		-- love.graphics.origin()
		love.graphics.translate(w.position.x, w.position.y)
		
		-- love.graphics.translate(w.size.width / 2, 0)
		-- love.graphics.rotate(math.rad(w.velocity))
		-- love.graphics.translate(-w.size.width / 2, 0)
		
		love.graphics.translate(-w.position.x, -w.position.y)
		w:drawShadow()
		
		w:drawBorder()
		
		love.graphics.translate(w.position.x, w.position.y)
		w:draw()
		love.graphics.pop()
	end
	
	-- FX
	for i = 1, #self.effects do
		self.effects[i]:draw()
	end
	
	love.graphics.setColor(VieWS.PALETTE[1])
	love.graphics.draw(self.corner, 0, 0, 0)
	love.graphics.draw(self.corner, window.screen.width, 0, math.rad(90))
	love.graphics.draw(self.corner, 0, window.screen.height, math.rad(270))
	love.graphics.draw(self.corner, window.screen.width, window.screen.height, math.rad(180))
end

function VieWS:mousemoved(m)
end
